import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/utils/navigation/app_routes.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static const Duration splashDuration = Duration(seconds: 5);

  late final AnimationController timeline;

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
      if (!isClosed) Get.offAllNamed(AppRoutes.onboarding);
    });
  }

  @override
  void onClose() {
    timeline.dispose();
    super.onClose();
  }
}
