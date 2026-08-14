import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/presentation/controller/sales_report_controller.dart';



class RecentOrdersTable extends StatelessWidget {
  RecentOrdersTable({super.key});

  final controller = Get.find<SalesReportController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange.shade100),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [

          Container(
            color: Colors.orange.shade50,
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 8,
            ),
            child: const Row(
              children: [

                Expanded(child: Text("S.No")),

                Expanded(child: Text("Order ID")),

                Expanded(flex: 2, child: Text("Product")),

                Expanded(child: Text("Qty")),

                Expanded(child: Text("View")),

                Expanded(child: Text("Status")),
              ],
            ),
          ),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.orders.length,
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

                    Expanded(child: Text(item["orderId"])),

                    Expanded(
                      flex: 2,
                      child: Text(item["product"]),
                    ),

                    Expanded(
                      child: Text("${item["qty"]}"),
                    ),

                    Expanded(
                      child: InkWell(
                        onTap: () =>
                            controller.onView(index),
                        child: const Text(
                          "View",
                          style: TextStyle(
                            color: Colors.green,
                            decoration:
                                TextDecoration.underline,
                                decorationColor: Colors.green,
                                fontSize: 15
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: item["status"] == "Pending"
                              ? Colors.orange
                              : item["status"] == "Completed"
                                  ? Colors.green
                                  : Colors.red,
                          borderRadius:
                              BorderRadius.circular(5),
                        ),
                        child: Text(
                          item["status"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
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
  }
}