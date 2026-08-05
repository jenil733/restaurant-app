import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';
import 'package:restaurant_app/src/core/utils/helper/texthelper.dart';
import 'package:restaurant_app/src/presentation/controller/auth/verification_success_controller.dart';

class VerificationSuccessScreen extends GetView<VerificationSuccessController> {
  const VerificationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: controller.fadeAnimation,
            child: ScaleTransition(
              scale: controller.scaleAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    verificationSuccessImage,
                    width: 157,
                    height: 145,
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'OTP Verified\nSuccessfully',
                    textAlign: TextAlign.center,
                    style: TextHelper.heading1.copyWith(
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
