import 'package:flutter/material.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';

class ProductTextField extends StatelessWidget {
  final String title;
  final String hint;
  final int maxLines;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  const ProductTextField({
    super.key,
    required this.title,
    required this.hint,
    this.maxLines = 1,
    this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.addproductBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.addproductBorder,
              ),
            ),
          ),
        ),
      ],
    );
  }
}