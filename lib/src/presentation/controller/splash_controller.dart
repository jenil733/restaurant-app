import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/services/local_storage_services.dart';
import 'package:restaurant_app/src/core/utils/navigation/app_routes.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static const Duration splashDuration = Duration(seconds: 3);

  late final AnimationController timeline;
  final LocalStorageService _storage = LocalStorageService();

  @override
  void onInit() {
    super.onInit();
    timeline = AnimationController(vsync: this, duration: splashDuration);
  }

  @override
  void onReady() {
    super.onReady();
    timeline.forward();
    Future<void>.delayed(splashDuration, () {
      if (isClosed) return;

      final isLoggedIn = _storage.getBool('is_logged_in') ?? false;
      final token = _storage.getString('auth_token');

      if (isLoggedIn || (token != null && token.isNotEmpty)) {
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.offAllNamed(AppRoutes.onboarding);
      }
    });
  }

  @override
  void onClose() {
    timeline.dispose();
    super.onClose();
  }
}
