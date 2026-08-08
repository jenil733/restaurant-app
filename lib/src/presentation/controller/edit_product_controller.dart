import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProductController extends GetxController {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final mrpController = TextEditingController();
  final discountController = TextEditingController();
  final sellPriceController = TextEditingController();

  String? selectedCategory;
  String? selectedFoodType;
  String? selectedStatus;

  @override
  void onInit() {
    super.onInit();
    // Simulate fetching existing product data
    nameController.text = "The Spice Pizza";
    descriptionController.text = "Lorem Ipsum is simply dummy text of the printing typesetting industry.";
    mrpController.text = "200";
    discountController.text = "20 %";
    sellPriceController.text = "150";
    
    selectedCategory = "Pizza";
    selectedFoodType = "Veg";
    selectedStatus = "Enable";
  }

  void setCategory(String? value) {
    selectedCategory = value;
    update();
  }

  void setFoodType(String? value) {
    selectedFoodType = value;
    update();
  }

  void setStatus(String? value) {
    selectedStatus = value;
    update();
  }

  void updateProduct() {
    // Implement API call for updating product
    Get.back();
  }

  void deleteProduct() {
    // Implement API call for deleting product
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
