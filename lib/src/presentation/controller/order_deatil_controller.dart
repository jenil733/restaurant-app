import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailController extends GetxController {
  RxString orderId = "#1001".obs;
  RxString date = "12 May 2025".obs;
  RxString time = "10:30 AM".obs;

  RxString orderStatus = "Pending".obs;
  RxString paymentStatus = "Paid".obs;
  RxString paymentMethod = "Online".obs;

  RxString customerName = "John Miller".obs;
  RxString phone = "9876543212".obs;
  RxString address ="2972 Westheimer Rd.Santa Ana,\nIllinois 85486".obs;

  RxList<Map<String, dynamic>> items = <Map<String, dynamic>>[
    {
      "sno": 1,
      "name": "Chicken Biriyani",
      "image":
          "https://images.unsplash.com/photo-1631515243349-e0cb75fb8d3a?w=200",
      "qty": 2,
      "amount": 300,
    },
    {
      "sno": 2,
      "name": "Chicken Biriyani",
      "image":
          "https://images.unsplash.com/photo-1631515243349-e0cb75fb8d3a?w=200",
      "qty": 2,
      "amount": 300,
    },
    {
      "sno": 3,
      "name": "Chicken Biriyani",
      "image":
          "https://images.unsplash.com/photo-1631515243349-e0cb75fb8d3a?w=200",
      "qty": 2,
      "amount": 300,
    },
  ].obs;

  RxDouble subtotal = 1200.0.obs;
  RxDouble deliveryCharge = 50.0.obs;
  RxDouble discount = 200.0.obs;


  var deliveryDate = "".obs;
  var cancelReason = "".obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      final order = Get.arguments as Map<String, dynamic>;

      orderId.value = order["orderId"] ?? "";
      orderStatus.value = order["status"] ?? "";

      if (orderStatus.value == "Completed") {
        deliveryDate.value = order["date"] ?? "";
      }

      if (orderStatus.value == "Cancel") {
        cancelReason.value =
            order["reason"] ?? "Customer requested cancellation";
      }
    }
  }

  double get grandTotal =>
      subtotal.value + deliveryCharge.value - discount.value;

  void acceptOrder() {
  Get.snackbar(
    "Success",
    "Order Accepted Successfully",
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.green,
    colorText: Colors.white,
  );
}
   
  void rejectOrder(String reason) {
  print(reason);

  Get.snackbar(
    "Rejected",
    "Order Rejected Successfully",
    backgroundColor: Colors.red,
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
  );
}

  void openMap() {
    Get.snackbar(
      "Map",
      "Open Google Map",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}