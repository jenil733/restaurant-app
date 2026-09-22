import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/di/service_locator.dart';
import '../../core/services/api_services.dart';
import '../../data/models/sales_report_model.dart';
import '../../data/repository/sales_report_repository_impl.dart';
import '../../domain/usecase/get_sales_report_usecase.dart';
import '../view/orders/order_detail_screen.dart';

class SalesReportController extends GetxController {
  late final GetSalesReportUseCase _getSalesReportUseCase;

  var fromDate = "".obs;
  var toDate = "".obs;

  var isLoading = false.obs;
  var errorMessage = RxnString();

  RxString totalSales = "₹0.00".obs;
  RxInt totalOrders = 0.obs;
  RxString averageOrder = "0".obs;
  RxInt totalCustomers = 0.obs;

  RxList<SalesReportOrderModel> orders = <SalesReportOrderModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _getSalesReportUseCase = sl.isRegistered<GetSalesReportUseCase>()
        ? sl<GetSalesReportUseCase>()
        : GetSalesReportUseCase(SalesReportRepositoryImpl(ApiService()));

    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    fromDate.value = _formatDate(firstDay);
    toDate.value = _formatDate(now);

    fetchSalesReport();
  }

  String _formatDate(DateTime dt) {
    final y = dt.year.toString();
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return "$y-$m-$d";
  }

  Future<void> fetchSalesReport({bool isRefresh = false}) async {
    if (fromDate.value.isEmpty || toDate.value.isEmpty) return;

    if (!isRefresh && orders.isNotEmpty) {
      // Refresh silently
    } else {
      isLoading.value = true;
    }
    errorMessage.value = null;

    try {
      final response = await _getSalesReportUseCase(
        fromDate: fromDate.value,
        toDate: toDate.value,
      );

      if (response.data != null) {
        final data = response.data!;
        final salesNum = data.totalSales;
        totalSales.value = "₹${salesNum.toStringAsFixed(2)}";
        totalOrders.value = data.totalOrders;
        averageOrder.value = data.avgOrder is int
            ? data.avgOrder.toString()
            : data.avgOrder.toStringAsFixed(1);
        totalCustomers.value = data.customers;
        orders.assignAll(data.recentOrders);
      }
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint("Error fetching sales report: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickFromDate(BuildContext context) async {
    DateTime initial = DateTime.now();
    try {
      if (fromDate.value.isNotEmpty) {
        initial = DateTime.parse(fromDate.value);
      }
    } catch (_) {}

    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (date != null) {
      fromDate.value = _formatDate(date);
      fetchSalesReport(isRefresh: true);
    }
  }

  Future<void> pickToDate(BuildContext context) async {
    DateTime initial = DateTime.now();
    try {
      if (toDate.value.isNotEmpty) {
        initial = DateTime.parse(toDate.value);
      }
    } catch (_) {}

    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (date != null) {
      toDate.value = _formatDate(date);
      fetchSalesReport(isRefresh: true);
    }
  }

  void onView(int index) {
    if (index >= 0 && index < orders.length) {
      final order = orders[index];
      Get.to(
        () => OrderDetailScreen(),
        arguments: order.toJson(),
      );
    }
  }

  Color statusColor(String status) {
    switch (status.toLowerCase().trim()) {
      case "completed":
      case "delivered":
      case "success":
        return Colors.green;
      case "cancelled":
      case "failed":
      case "rejected":
        return Colors.red;
      default:
        return const Color(0xffFF8A3D);
    }
  }
}