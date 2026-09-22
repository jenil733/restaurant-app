import 'package:flutter/material.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.width = 136,
    this.height = 48,
    this.backgroundColor = AppColors.primary,
    this.foregroundColor = AppColors.white,
    this.style,
    this.isLoading = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color foregroundColor;
  final TextStyle? style;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          disabledBackgroundColor: backgroundColor.withValues(alpha: 0.55),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle:
              style ??
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                ),
              )
            : Text(text),
      ),
    );
  }
}
