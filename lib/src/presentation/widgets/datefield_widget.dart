import 'package:flutter/material.dart';

class CommonDateFilter extends StatelessWidget {
  final String fromDate;
  final String toDate;
  final VoidCallback onFromTap;
  final VoidCallback onToTap;

  const CommonDateFilter({
    super.key,
    required this.fromDate,
    required this.toDate,
    required this.onFromTap,
    required this.onToTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _dateField(
            title: "From Date",
            value: fromDate,
            onTap: onFromTap,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _dateField(
            title: "To Date",
            value: toDate,
            onTap: onToTap,
          ),
        ),
      ],
    );
  }

  Widget _dateField({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),

        TextField(
          readOnly: true,
          controller: TextEditingController(text: value),
          decoration: InputDecoration(
            hintText: "DD/MM/YYYY",
            hintStyle: const TextStyle(
      color: Colors.grey,
      fontSize: 16,
    ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            suffixIcon: IconButton(
              onPressed: onTap,
              icon: const Icon(
    Icons.calendar_today_outlined,
    color: Colors.grey,
  ),
            ),
            enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Colors.grey,
      ),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Colors.grey,
      ),
    ),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Colors.grey,
      ),
    ),
          ),
        ),
      ],
    );
  }
}