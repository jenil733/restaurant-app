import 'package:flutter/material.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({required this.onPressed, super.key, this.size = 44});

  final VoidCallback onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Back',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(size * 0.3),
          boxShadow: [
            BoxShadow(
              color: AppColors.sidemenu.withValues(alpha: 0.05),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(size * 0.3),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            key: const Key('app-back-button'),
            onTap: onPressed,
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: size * 0.48,
              color: AppColors.sidemenu,
            ),
          ),
        ),
      ),
    );
  }
}
