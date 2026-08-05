import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/utils/helper/texthelper.dart';

class AppNotification {
  const AppNotification._();

  static void showError({required String title, required String message}) {
    _show(
      title: title,
      message: message,
      color: AppColors.red,
      icon: Icons.error_outline_rounded,
    );
  }

  static void showSuccess({required String title, required String message}) {
    _show(
      title: title,
      message: message,
      color: AppColors.green,
      icon: Icons.check_circle_outline_rounded,
    );
  }

  static void _show({
    required String title,
    required String message,
    required Color color,
    required IconData icon,
  }) {
    final context = Get.context;
    if (context == null || !context.mounted) return;

    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    messenger
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(
        MaterialBanner(
          elevation: 2,
          backgroundColor: AppColors.background,
          leading: Icon(icon, color: color, size: 25),
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextHelper.heading1.copyWith(fontSize: 14)),
              const SizedBox(height: 2),
              Text(message, style: TextHelper.heading2.copyWith(fontSize: 11)),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'Dismiss',
              onPressed: messenger.hideCurrentMaterialBanner,
              icon: Icon(
                Icons.close_rounded,
                size: 18,
                color: AppColors.textprimary.withValues(alpha: 0.55),
              ),
            ),
          ],
        ),
      );

    Future<void>.delayed(const Duration(seconds: 3), () {
      if (messenger.mounted) {
        messenger.hideCurrentMaterialBanner();
      }
    });
  }
}
