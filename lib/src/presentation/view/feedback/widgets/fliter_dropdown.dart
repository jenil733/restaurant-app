import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/presentation/controller/feedback_controller.dart';

class FilterDropdown extends StatelessWidget {
  FilterDropdown({super.key});

  final FeedbackController controller = Get.find<FeedbackController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Filter",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xff2F384C),
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => DropdownButtonFormField<String>(
            value: controller.selectedFilter.value,
            icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xff4B5563)),
            decoration: InputDecoration(
              hintText: "Select",
              hintStyle: const TextStyle(color: Color(0xff9CA3AF), fontSize: 14),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color:  Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color:  Colors.grey),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            items: controller.filterList.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 14, color: Color(0xff1F2937)),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                controller.changeFilter(value);
              }
            },
          ),
        ),
      ],
    );
  }
}