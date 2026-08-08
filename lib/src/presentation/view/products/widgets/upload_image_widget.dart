import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';

class UploadImageWidget extends StatelessWidget {
  const UploadImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Pick Image
      },
      child: DottedBorder(
  color: AppColors.border,
  strokeWidth: 1,
  dashPattern: const [8, 6],
  borderType: BorderType.RRect,
  radius: const Radius.circular(10),
  child: Container(
    height: 130,
    width: double.infinity,
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          uploadIcon,
          width: 35,
          height: 35,
        ),
        const SizedBox(height: 10),
        const Text(
          "Click to Upload",
          style: TextStyle(
            color: Color(0xffFF8A3D),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          "( Max file size: 5 MB, Jpg only )",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 11,
          ),
        ),
      ],
    ),
  ),
)
    );
  }
}