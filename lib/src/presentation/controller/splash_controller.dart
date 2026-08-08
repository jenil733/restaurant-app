import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/utils/navigation/app_routes.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> fadeAnimation;
  late final Animation<double> scaleAnimation;
  Timer? _navigationTimer;

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    final curvedAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOutCubic,
    );

    fadeAnimation = curvedAnimation;
    scaleAnimation = Tween<double>(
      begin: 0.88,
      end: 1,
    ).animate(curvedAnimation);

    animationController.forward();
  }

  @override
  void onReady() {
    super.onReady();
    _navigationTimer = Timer(const Duration(seconds: 2), () async {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      if (isLoggedIn) {
        Get.offAllNamed<void>(AppRoutes.home);
      } else {
        Get.offNamed<void>(AppRoutes.onboarding);
      }
    });
  }

  @override
  void onClose() {
    _navigationTimer?.cancel();
    animationController.dispose();
    super.onClose();
  }
}
