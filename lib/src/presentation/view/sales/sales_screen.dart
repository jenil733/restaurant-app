import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';
import 'package:restaurant_app/src/presentation/controller/sales_report_controller.dart';
import 'package:restaurant_app/src/presentation/view/sales/widgets/recent_order_table.dart';
import 'package:restaurant_app/src/presentation/view/sales/widgets/report_card.dart';
import 'package:restaurant_app/src/presentation/widgets/app_bar.dart';
import 'package:restaurant_app/src/presentation/widgets/datefield_widget.dart';

class SalesReportScreen extends StatelessWidget {
  SalesReportScreen({super.key});

  final SalesReportController controller = Get.isRegistered<SalesReportController>()
      ? Get.find<SalesReportController>()
      : Get.put(SalesReportController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Sales Reports',
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchSalesReport(isRefresh: true),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Obx(
                () => CommonDateFilter(
                  fromDate: controller.fromDate.value,
                  toDate: controller.toDate.value,
                  onFromTap: () => controller.pickFromDate(context),
                  onToTap: () => controller.pickToDate(context),
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    ReportCard(
                      title: "Total Sales",
                      value: controller.totalSales.value,
                      icon: salesIcon,
                      color: Colors.green,
                    ),
                    ReportCard(
                      title: "Total Orders",
                      value: controller.totalOrders.value.toString(),
                      icon: boxIcon,
                      color: Colors.purple,
                    ),
                    ReportCard(
                      title: "Avg Order",
                      value: controller.averageOrder.value,
                      icon: boxIcon,
                      color: Colors.teal,
                    ),
                    ReportCard(
                      title: "Customers",
                      value: controller.totalCustomers.value.toString(),
                      icon: customerIcon,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Recent Orders",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              RecentOrdersTable(),
            ],
          ),
        ),
      ),
    );
  }
}