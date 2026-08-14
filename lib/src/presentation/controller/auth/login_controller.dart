import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/utils/navigation/app_routes.dart';
import 'package:restaurant_app/src/presentation/widgets/app_notification.dart';

class LoginController extends GetxController {
  final TextEditingController phoneController = TextEditingController();

  Future<void> login() async {
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

    Get.toNamed<void>(AppRoutes.otpVerification, arguments: phoneNumber);
  }

  @override
  void onClose() {
    final controller = phoneController;
    Future.delayed(const Duration(milliseconds: 500), () {
      // controller.dispose();
    });
    super.onClose();
  }
}
