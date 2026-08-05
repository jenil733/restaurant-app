import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';
import 'package:restaurant_app/src/presentation/controller/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: Center(
        child: FadeTransition(
          opacity: controller.fadeAnimation,
          child: ScaleTransition(
            scale: controller.scaleAnimation,
            child: SvgPicture.asset(
              appLogo,
              width: MediaQuery.sizeOf(context).width * 0.58,
              fit: BoxFit.contain,
              semanticsLabel: 'Kayal Food Delivery',
            ),
          ),
        ),
      ),
    );
  }
}
