import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/utils/helper/texthelper.dart';

class AppFormField extends StatelessWidget {
  const AppFormField({
    required this.label,
    required this.controller,
    super.key,
    this.hintText = 'Enter',
    this.isRequired = false,
    this.keyboardType,
    this.inputFormatters,
    this.prefixText,
    this.maxLines = 1,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final bool isRequired;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? prefixText;
  final int maxLines;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: TextHelper.heading2,
            children: [
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: TextHelper.heading2.copyWith(
                    color: AppColors.red,
                    fontSize: 11,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          validator: validator,
          style: TextHelper.heading2.copyWith(fontSize: 12),
          decoration: InputDecoration(
            hintText: hintText,
            prefixText: prefixText,
            prefixStyle: TextHelper.heading2.copyWith(fontSize: 12),
            hintStyle: TextHelper.heading2.copyWith(
              color: AppColors.textprimary.withValues(alpha: 0.3),
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            enabledBorder: _border(AppColors.primary.withValues(alpha: 0.2)),
            focusedBorder: _border(AppColors.primary),
            errorBorder: _border(AppColors.red),
            focusedErrorBorder: _border(AppColors.red),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: BorderSide(color: color),
    );
  }
}
