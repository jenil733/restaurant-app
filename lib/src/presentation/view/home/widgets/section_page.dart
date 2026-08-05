import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/utils/helper/texthelper.dart';

class SectionPage extends StatelessWidget {
  const SectionPage({required this.title, required this.icon, super.key});

  final String title;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              icon,
              width: 56,
              height: 56,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextHelper.heading2.copyWith(color: AppColors.textprimary),
            ),
          ],
        ),
      ),
    );
  }
}
