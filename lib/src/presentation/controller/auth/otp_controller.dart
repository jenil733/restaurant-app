import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/utils/navigation/app_routes.dart';
import 'package:restaurant_app/src/presentation/widgets/app_notification.dart';

class OtpController extends GetxController {
  static const int otpLength = 4;

  final TextEditingController otpController = TextEditingController();
  final FocusNode otpFocusNode = FocusNode();
  final RxString otp = ''.obs;
  final RxInt activeDigit = 0.obs;
  final RxInt secondsRemaining = 30.obs;

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

  bool get canResend => secondsRemaining.value == 0;

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
    Get.offAllNamed<void>(AppRoutes.login);
  }

  Future<void> verifyOtp() async {
    if (otpController.text.length != otpLength) {
      AppNotification.showError(
        title: 'Incomplete OTP',
        message: 'Enter the complete verification code.',
      );
      return;
    }

    await _dismissKeyboard();
    Get.offNamed<void>(AppRoutes.verificationSuccess);
  }

  void resendOtp() {
    if (!canResend) {
      return;
    }

    otpController.clear();
    otp.value = '';
    activeDigit.value = 0;
    secondsRemaining.value = 30;
    otpFocusNode.requestFocus();
    _startTimer();
    AppNotification.showSuccess(
      title: 'OTP sent',
      message: 'A new verification code has been sent.',
    );
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
    
    // Delay disposal to allow transition animation to complete safely
    final controller = otpController;
    final focusNode = otpFocusNode;
    Future.delayed(const Duration(milliseconds: 500), () {
      controller.dispose();
      focusNode.dispose();
    });
    
    super.onClose();
  }
}
