import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view/orders/order_detail_screen.dart';

class SalesReportController extends GetxController {
  var fromDate = "".obs;
  var toDate = "".obs;

  RxString totalSales = "₹12,348.00".obs;
  RxInt totalOrders = 248.obs;
  RxInt averageOrder = 10.obs;
  RxInt totalCustomers = 33.obs;

  RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[
    {
      "sno": 1,
      "orderId": "#1001",
      "product": "Chicken Biriyani",
      "qty": 2,
      "status": "Pending",
    },
    {
      "sno": 2,
      "orderId": "#1002",
      "product": "Chicken Biriyani",
      "qty": 2,
      "status": "Pending",
    },
    {
      "sno": 3,
      "orderId": "#1003",
      "product": "Chicken Biriyani",
      "qty": 1,
      "status": "Pending",
    },
    {
      "sno": 4,
      "orderId": "#1004",
      "product": "Chicken Biriyani",
      "qty": 3,
      "status": "Pending",
    },
  ].obs;

  Future<void> pickFromDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );

    if (date != null) {
      fromDate.value =
          "${date.day}/${date.month}/${date.year}";
    }
  }

  Future<void> pickToDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );

    if (date != null) {
      toDate.value =
          "${date.day}/${date.month}/${date.year}";
    }
  }

  void onView(int index) {
    final order = orders[index];
    Get.to(
      () => OrderDetailScreen(),
      arguments: order,
    );
  }

  Color statusColor(String status) {
    switch (status) {
      case "Completed":
        return Colors.green;
      case "Cancelled":
        return Colors.red;
      default:
        return const Color(0xffFF8A3D);
    }
  }
}