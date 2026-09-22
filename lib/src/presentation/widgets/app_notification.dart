import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';

class AppNotification {
  const AppNotification._();

  static void show(String title, String msg, bool error) {
    try {
      if (Get.context == null && Get.key.currentState == null) {
        return;
      }
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
      final bgColor = error ? AppColors.red : AppColors.green;
      Get.showSnackbar(
        GetSnackBar(
          titleText: title.trim().isNotEmpty
              ? Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                )
              : null,
          messageText: Text(
            msg,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          snackPosition: SnackPosition.TOP,
          isDismissible: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          margin: const EdgeInsets.all(15),
          borderRadius: 8,
          borderColor: bgColor,
          duration: const Duration(milliseconds: 2500),
          backgroundColor: bgColor,
          icon: Icon(
            error ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
      );
    } catch (e) {
      debugPrint("AppNotification show error: $e");
    }
  }

  static void showSuccess({required String title, required String message}) {
    show(title, message, false);
  }

  static void showError({required String title, required String message}) {
    show(title, message, true);
  }

  static void showDeleted({required String title, required String message}) {
    try {
      if (Get.context == null && Get.key.currentState == null) {
        return;
      }
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
      Get.showSnackbar(
        GetSnackBar(
          titleText: title.trim().isNotEmpty
              ? Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                )
              : null,
          messageText: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          snackPosition: SnackPosition.TOP,
          isDismissible: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          margin: const EdgeInsets.all(15),
          borderRadius: 8,
          borderColor: AppColors.red,
          duration: const Duration(milliseconds: 2500),
          backgroundColor: AppColors.red,
          icon: const Icon(
            Icons.delete_outline_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
      );
    } catch (e) {
      debugPrint("AppNotification showDeleted error: $e");
    }
  }
}

