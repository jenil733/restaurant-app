import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/di/service_locator.dart';
import 'package:restaurant_app/src/core/error/failure.dart';
import 'package:restaurant_app/src/core/services/api_services.dart';
import 'package:restaurant_app/src/core/services/local_storage_services.dart';
import 'package:restaurant_app/src/core/utils/navigation/app_routes.dart';
import 'package:restaurant_app/src/data/models/send_otp_model.dart';
import 'package:restaurant_app/src/data/models/verify_otp_model.dart';
import 'package:restaurant_app/src/data/repository/otp_repository_impl.dart';
import 'package:restaurant_app/src/domain/usecase/send_otp_usecase.dart';
import 'package:restaurant_app/src/domain/usecase/verify_otp_usecase.dart';
import 'package:restaurant_app/src/presentation/controller/auth/login_controller.dart';
import 'package:restaurant_app/src/presentation/widgets/app_notification.dart';

class OtpController extends GetxController {
  static const int otpLength = 4;

  OtpController({
    SendOtpUseCase? sendOtpUseCase,
    VerifyOtpUseCase? verifyOtpUseCase,
  })  : _sendOtpUseCase = sendOtpUseCase ??
            (sl.isRegistered<SendOtpUseCase>()
                ? sl<SendOtpUseCase>()
                : SendOtpUseCase(OtpRepositoryImpl(ApiService()))),
        _verifyOtpUseCase = verifyOtpUseCase ??
            (sl.isRegistered<VerifyOtpUseCase>()
                ? sl<VerifyOtpUseCase>()
                : VerifyOtpUseCase(OtpRepositoryImpl(ApiService())));

  final SendOtpUseCase _sendOtpUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final LocalStorageService _storage = LocalStorageService();

  final TextEditingController otpController = TextEditingController();
  final FocusNode otpFocusNode = FocusNode();
  final RxString otp = ''.obs;
  final RxInt activeDigit = 0.obs;
  final RxInt secondsRemaining = 30.obs;
  final RxBool isResending = false.obs;
  final RxBool isVerifying = false.obs;

  Timer? _timer;

  String get phoneNumber {
    final argument = Get.arguments;
    return argument is String && argument.isNotEmpty ? argument : '7685342317';
  }

  String get formattedPhoneNumber => '+91 $phoneNumber';

  String get countdown {
    final seconds = secondsRemaining.value.toString().padLeft(2, '0');
    return '00:$seconds';
  }

  bool get canResend =>
      secondsRemaining.value == 0 && !isResending.value && !isVerifying.value;

  @override
  void onInit() {
    super.onInit();
    _startTimer();
    otpFocusNode.addListener(_handleFocusChange);
  }

  void onOtpChanged(String value) {
    otp.value = value;
    activeDigit.value = value.length >= otpLength
        ? otpLength - 1
        : value.length;
  }

  void selectDigit(int index) {
    activeDigit.value = index;
    final textLength = otpController.text.length;

    if (index < textLength) {
      otpController.selection = TextSelection(
        baseOffset: index,
        extentOffset: index + 1,
      );
    } else {
      otpController.selection = TextSelection.collapsed(offset: textLength);
    }

    otpFocusNode.requestFocus();
  }

  Future<void> editPhoneNumber() async {
    await _dismissKeyboard();
    if (Get.isRegistered<LoginController>()) {
      Get.find<LoginController>().phoneController.text = phoneNumber;
    }
    if (Navigator.of(Get.context!).canPop()) {
      Get.back();
    } else {
      Get.offAllNamed<void>(AppRoutes.login, arguments: phoneNumber);
    }
  }

  Future<void> verifyOtp() async {
    if (isVerifying.value) return;

    final enteredOtp = otpController.text.trim();
    if (enteredOtp.length != otpLength) {
      AppNotification.showError(
        title: 'Incomplete OTP',
        message: 'Enter the complete verification code.',
      );
      return;
    }

    await _dismissKeyboard();
    isVerifying.value = true;

    try {
      final response = await _verifyOtpUseCase(
        VerifyOtpRequestModel(
          phone: phoneNumber,
          otp: enteredOtp,
        ),
      );

      if (response.token != null && response.token!.isNotEmpty) {
        await _storage.saveString('auth_token', response.token!);
        await _storage.saveBool('is_logged_in', true);
      }

      if (response.data is Map) {
        final resMap = response.data as Map;
        final possibleId = resMap['restaurant_id'] ??
            resMap['id'] ??
            resMap['user_id'] ??
            (resMap['restaurant'] is Map ? resMap['restaurant']['id'] : null) ??
            (resMap['user'] is Map ? resMap['user']['id'] : null);
        if (possibleId != null && possibleId.toString().trim().isNotEmpty) {
          await _storage.saveString('restaurant_id', possibleId.toString().trim());
        }
      }

      AppNotification.showSuccess(
        title: 'OTP Verified',
        message: response.message.isNotEmpty
            ? response.message
            : 'OTP verified successfully.',
      );

      Get.offNamed<void>(AppRoutes.verificationSuccess);
    } on Failure catch (e) {
      AppNotification.showError(
        title: 'Verification Failed',
        message: e.message,
      );
    } catch (e) {
      AppNotification.showError(
        title: 'Error',
        message: 'Could not verify OTP: $e',
      );
    } finally {
      isVerifying.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (!canResend) {
      return;
    }

    isResending.value = true;
    try {
      final response = await _sendOtpUseCase(
        SendOtpRequestModel(phone: phoneNumber),
      );

      otpController.clear();
      otp.value = '';
      activeDigit.value = 0;
      secondsRemaining.value = 30;
      otpFocusNode.requestFocus();
      _startTimer();

      AppNotification.showSuccess(
        title: 'OTP sent',
        message: response.message.isNotEmpty
            ? response.message
            : 'A new verification code has been sent.',
      );
    } on Failure catch (e) {
      AppNotification.showError(
        title: 'Failed to resend OTP',
        message: e.message,
      );
    } catch (e) {
      AppNotification.showError(
        title: 'Error',
        message: 'Could not resend OTP: $e',
      );
    } finally {
      isResending.value = false;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value == 0) {
        timer.cancel();
        return;
      }
      secondsRemaining.value--;
    });
  }

  void _handleFocusChange() {
    if (!otpFocusNode.hasFocus) {
      activeDigit.value = -1;
    }
  }

  Future<void> _dismissKeyboard() async {
    final focus = FocusManager.instance.primaryFocus;
    if (focus != null && focus.hasFocus) {
      focus.unfocus();
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    otpFocusNode.removeListener(_handleFocusChange);
    otpController.dispose();
    otpFocusNode.dispose();
    super.onClose();
  }
}
