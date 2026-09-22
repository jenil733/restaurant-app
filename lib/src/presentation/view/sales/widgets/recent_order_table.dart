import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/presentation/controller/sales_report_controller.dart';

class RecentOrdersTable extends StatelessWidget {
  RecentOrdersTable({super.key});

  final controller = Get.find<SalesReportController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Container(
          padding: const EdgeInsets.all(32),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.orange.shade100),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Column(
            children: [
              CircularProgressIndicator(color: Colors.orange),
              SizedBox(height: 12),
              Text(
                "Loading sales report...",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        );
      }

      if (controller.orders.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.orange.shade100),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 48,
                color: Colors.orange.shade300,
              ),
              const SizedBox(height: 10),
              const Text(
                "No recent orders in this date range",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.orange.shade100),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 8,
              ),
              child: const Row(
                children: [
                  Expanded(child: Text("S.No", style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(child: Text("Order ID", style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(flex: 2, child: Text("Product", style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(child: Text("Qty", style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(child: Text("View", style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(child: Text("Status", style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.orders.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: Colors.grey.shade200,
              ),
              itemBuilder: (_, index) {
                final item = controller.orders[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text("${index + 1}")),
                      Expanded(
                        child: Text(
                          item.orderId.isNotEmpty ? item.orderId : "#${index + 1}",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          item.productName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        child: Text("${item.quantity}"),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => controller.onView(index),
                          child: const Text(
                            "View",
                            style: TextStyle(
                              color: Colors.green,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.green,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 4,
                          ),
                          decoration: BoxDecoration(
                            color: controller.statusColor(item.status),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            item.status,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}