import 'package:flutter/material.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';

class ProductDropdown extends StatefulWidget {
  final String title;
  final String hint;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;

  const ProductDropdown({
    super.key,
    required this.title,
    required this.hint,
    required this.items,
    this.value,
    required this.onChanged,
  });

  @override
  State<ProductDropdown> createState() => _ProductDropdownState();
}

class _ProductDropdownState extends State<ProductDropdown> {
  String? value;

  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.border,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.border,
              ),
            ),
          ),
          hint: Text(widget.hint),
          style: const TextStyle(
              color: Colors.grey,
              fontSize:16
            ),
          icon: const Icon(Icons.keyboard_arrow_down),
          items: widget.items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ),
              )
              .toList(),
          onChanged: (v) {
            setState(() {
              value = v;
            });
            widget.onChanged(v);
          },
        ),
      ],
    );
  }
}