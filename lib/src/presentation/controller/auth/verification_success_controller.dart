import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/utils/navigation/app_routes.dart';

class VerificationSuccessController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> fadeAnimation;
  late final Animation<double> scaleAnimation;
  Timer? _homeTimer;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    final curvedAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOutBack,
    );

    fadeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    );
    scaleAnimation = Tween<double>(
      begin: 0.75,
      end: 1,
    ).animate(curvedAnimation);

    animationController.forward();
    _homeTimer = Timer(const Duration(seconds: 1), () {
      Get.offAllNamed<void>(AppRoutes.home);
    });
  }

  @override
  void onClose() {
    _homeTimer?.cancel();
    animationController.dispose();
    super.onClose();
  }
}
