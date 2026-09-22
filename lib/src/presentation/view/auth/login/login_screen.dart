import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';
import 'package:restaurant_app/src/core/utils/helper/texthelper.dart';
import 'package:restaurant_app/src/core/utils/navigation/app_routes.dart';
import 'package:restaurant_app/src/presentation/controller/auth/login_controller.dart';
import 'package:restaurant_app/src/presentation/widgets/app_button.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 56, 24, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Login', style: TextHelper.heading3),
                    const SizedBox(height: 32),
                    Center(
                      child: Image.asset(
                        appLogo,
                        width: 121,
                        height: 86,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Center(
                      child: Text('Get Start now', style: TextHelper.login),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Create an account or login to explore\nmore',
                        textAlign: TextAlign.center,
                        style: TextHelper.heading2,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text('Phone Number', style: TextHelper.heading2),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => controller.login(),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      style: TextHelper.heading2,
                      decoration: InputDecoration(
                        hintText: 'Enter phone number',
                        hintStyle: TextHelper.heading2.copyWith(
                          color: AppColors.textprimary.withValues(alpha: 0.35),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        enabledBorder: _inputBorder(
                          AppColors.primary.withValues(alpha: 0.18),
                        ),
                        focusedBorder: _inputBorder(AppColors.primary),
                      ),
                    ),
                    const Spacer(),
                    Obx(
                      () => AppButton(
                        text: 'Login',
                        isLoading: controller.isLoading.value,
                        style: TextHelper.button,
                        width: double.infinity,
                        onPressed: controller.login,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: GestureDetector(
                        key: const Key('sign-up-link'),
                        onTap: () => Get.toNamed<void>(AppRoutes.signIn),
                        child: Text.rich(
                          TextSpan(
                            text: "Don't have an account? ",
                            style: TextHelper.heading2.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign up',
                                style: TextHelper.heading2.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  OutlineInputBorder _inputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color),
    );
  }
}
