import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/presentation/controller/feedback_controller.dart';

import 'package:restaurant_app/src/presentation/view/products/widgets/product_dropdown.dart';

class FilterDropdown extends StatelessWidget {
  FilterDropdown({super.key});

  final FeedbackController controller = Get.find<FeedbackController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ProductDropdown(
        title: "Filter",
        hint: "Select filter",
        value: controller.selectedFilter.value,
        items: controller.filterList,
        onChanged: (value) {
          if (value != null && value.isNotEmpty) {
            controller.changeFilter(value);
          }
        },
      ),
    );
  }
}