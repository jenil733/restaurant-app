import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/presentation/controller/order_deatil_controller.dart';


class OrderedItemsCard extends StatelessWidget {
  OrderedItemsCard({super.key});

  final OrderDetailController controller = Get.find<OrderDetailController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
  children: [
    Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: const Color(0xffF2E8FF),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Icon(
        Icons.shopping_bag_outlined,
        color: Color(0xff7B61FF),
        size: 18,
      ),
    ),
    const SizedBox(width: 8),
    const Text(
      "Ordered Items",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
  ],
            ),

           const SizedBox(height: 16),

ClipRRect(
  borderRadius: BorderRadius.circular(8),
  child: Column(
    children: [

            Container(
  width: double.infinity,
  decoration: BoxDecoration(
    border: Border.all(color: const Color(0xffE6E6E6)),
    borderRadius: BorderRadius.circular(8),
  ),
  child: Column(
    children: [
      //================ Header =================
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 10,
        ),
        decoration: const BoxDecoration(
          color: Color(0xffFFF5EC),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        child: const Row(
          children: [
            Expanded(flex: 1, child: Center(child: Text("S.No"))),
            Expanded(flex: 5, child: Text("Item")),
            Expanded(flex: 2, child: Center(child: Text("Qty"))),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text("Amount"),
              ),
            ),
          ],
        ),
      ),

      //================ List =================
      ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.items.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          color: Colors.grey.shade300,
        ),
        itemBuilder: (context, index) {
          final item = controller.items[index];

          return Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text("${item["sno"]}"),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          item["image"],
                          width: 42,
                          height: 42,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(item["name"]),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text("${item["qty"]}"),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "₹${item["amount"]}",
                      style: const TextStyle(
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

      //================ Total =================
      Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _priceRow(
                    "Subtotal",
                    "₹${controller.subtotal.value.toStringAsFixed(0)}",
                  ),
                  const SizedBox(height: 8),
                  _priceRow(
                    "Delivery Charge",
                    "₹${controller.deliveryCharge.value.toStringAsFixed(0)}",
                  ),
                  const SizedBox(height: 8),
                  _priceRow(
                    "Discount",
                    "-₹${controller.discount.value.toStringAsFixed(0)}",
                    valueColor: Colors.green,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xffFFF8F4),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: _priceRow(
                "Grand Total",
                "₹${controller.grandTotal.toStringAsFixed(0)}",
                isBold: true,
                valueColor: const Color(0xffF37021),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
)
          ]
      )
      )

          ],
    ),
       )
     ) ;
          

  }

  Widget _priceRow(
    String title,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: isBold ? 18 : 15,
              fontWeight:
                  isBold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 18 : 15,
            fontWeight:
                isBold ? FontWeight.w700 : FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}