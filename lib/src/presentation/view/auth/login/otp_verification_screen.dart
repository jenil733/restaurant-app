import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';
import 'package:restaurant_app/src/core/utils/helper/texthelper.dart';
import 'package:restaurant_app/src/presentation/controller/auth/otp_controller.dart';
import 'package:restaurant_app/src/presentation/widgets/app_button.dart';

class OtpVerificationScreen extends GetView<OtpController> {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 76, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('OTP Verification', style: TextHelper.heading3),
              const SizedBox(height: 14),
              Center(
                child: Text(
                  'Enter the code from the sms we sent',
                  style: TextHelper.heading2.copyWith(
                    color: AppColors.textprimary.withValues(alpha: 0.55),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      controller.formattedPhoneNumber,
                      style: TextHelper.heading2.copyWith(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      key: const Key('edit-phone-button'),
                      onTap: controller.editPhoneNumber,
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: SvgPicture.asset(pen, width: 20, height: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 34),
              Center(child: _OtpInput(controller: controller)),
              const SizedBox(height: 12),
              const SizedBox(height: 30),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      controller.countdown,
                      style: TextHelper.heading2.copyWith(
                        color: AppColors.red,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.red,
                      ),
                    ),
                    TextButton(
                      onPressed: controller.canResend
                          ? controller.resendOtp
                          : null,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 32),
                        foregroundColor: AppColors.green,
                        disabledForegroundColor: AppColors.green.withValues(
                          alpha: 0.55,
                        ),
                      ),
                      child: Text(
                        'Resend OTP',
                        style: TextHelper.heading2.copyWith(
                          color: controller.canResend
                              ? AppColors.green
                              : AppColors.green.withValues(alpha: 0.55),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                          decorationColor: controller.canResend
                              ? AppColors.green
                              : AppColors.green.withValues(alpha: 0.55),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              AppButton(
                text: 'Continue',
                width: double.infinity,
                onPressed: controller.verifyOtp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpInput extends StatelessWidget {
  const _OtpInput({required this.controller});

  final OtpController controller;

  @override
  Widget build(BuildContext context) {
    const inputWidth = 240.0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) {
        final boxWidth = inputWidth / OtpController.otpLength;
        final index = (details.localPosition.dx / boxWidth).floor().clamp(
          0,
          OtpController.otpLength - 1,
        );
        controller.selectDigit(index);
      },
      child: SizedBox(
        width: inputWidth,
        height: 48,
        child: Stack(
          children: [
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(OtpController.otpLength, (index) {
                  final digit = index < controller.otp.value.length
                      ? controller.otp.value[index]
                      : '';
                  final hasValue = digit.isNotEmpty;
                  final isActive =
                      controller.otpFocusNode.hasFocus &&
                      controller.activeDigit.value == index;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: hasValue
                          ? AppColors.primary
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isActive || hasValue
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: 0.18),
                        width: isActive ? 1.5 : 1,
                      ),
                    ),
                    child: Text(
                      digit,
                      style: TextHelper.heading1.copyWith(
                        color: hasValue
                            ? AppColors.white
                            : AppColors.textprimary,
                        fontSize: 15,
                      ),
                    ),
                  );
                }),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              width: 1,
              height: 1,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.01,
                  child: TextField(
                    controller: controller.otpController,
                    focusNode: controller.otpFocusNode,
                    onChanged: controller.onOtpChanged,
                    onSubmitted: (_) => controller.verifyOtp(),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    enableSuggestions: false,
                    autocorrect: false,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(OtpController.otpLength),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
