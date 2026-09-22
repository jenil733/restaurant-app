import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/di/service_locator.dart';
import 'package:restaurant_app/src/core/error/failure.dart';
import 'package:restaurant_app/src/core/services/api_services.dart';
import 'package:restaurant_app/src/core/utils/navigation/app_routes.dart';
import 'package:restaurant_app/src/data/models/send_otp_model.dart';
import 'package:restaurant_app/src/data/repository/otp_repository_impl.dart';
import 'package:restaurant_app/src/domain/usecase/send_otp_usecase.dart';
import 'package:restaurant_app/src/presentation/widgets/app_notification.dart';

class LoginController extends GetxController {
  LoginController({SendOtpUseCase? sendOtpUseCase})
      : _sendOtpUseCase = sendOtpUseCase ??
            (sl.isRegistered<SendOtpUseCase>()
                ? sl<SendOtpUseCase>()
                : SendOtpUseCase(OtpRepositoryImpl(ApiService())));

  final SendOtpUseCase _sendOtpUseCase;
  final TextEditingController phoneController = TextEditingController();
  final RxBool isLoading = false.obs;

  Future<void> login() async {
    if (isLoading.value) return;

    final phoneNumber = phoneController.text.trim();

    if (phoneNumber.length < 10) {
      AppNotification.showError(
        title: 'Invalid phone number',
        message: 'Enter a valid 10-digit phone number.',
      );
      return;
    }

    final focus = FocusManager.instance.primaryFocus;
    if (focus != null && focus.hasFocus) {
      focus.unfocus();
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }

    isLoading.value = true;

    try {
      final response = await _sendOtpUseCase(
        SendOtpRequestModel(phone: phoneNumber),
      );

      AppNotification.showSuccess(
        title: 'OTP sent',
        message: response.message.isNotEmpty
            ? response.message
            : 'A verification code has been sent.',
      );

      Get.toNamed<void>(AppRoutes.otpVerification, arguments: phoneNumber);
    } on Failure catch (e) {
      AppNotification.showError(
        title: 'Failed to send OTP',
        message: e.message,
      );
    } catch (e) {
      AppNotification.showError(
        title: 'Error',
        message: 'Something went wrong: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is String && args.isNotEmpty) {
      phoneController.text = args;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
