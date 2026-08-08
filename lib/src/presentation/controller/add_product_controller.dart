import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductController extends GetxController {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final mrpController = TextEditingController();
  final discountController = TextEditingController();
  final sellPriceController = TextEditingController();

  String? selectedCategory;
  String? selectedFoodType;

  void setCategory(String? value) {
    selectedCategory = value;
    update();
  }

  void setFoodType(String? value) {
    selectedFoodType = value;
    update();
  }

  void submit() {
    // Implement API call for adding product
    Get.back();
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    mrpController.dispose();
    discountController.dispose();
    sellPriceController.dispose();
    super.onClose();
  }
}
