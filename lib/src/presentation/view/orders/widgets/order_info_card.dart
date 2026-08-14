import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';
import 'package:restaurant_app/src/presentation/controller/order_deatil_controller.dart';
import 'package:restaurant_app/src/presentation/view/orders/widgets/reason_dialog.dart';


class OrderInfoCard extends StatelessWidget {
  OrderInfoCard({super.key});

  final OrderDetailController controller = Get.find<OrderDetailController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
       padding: const EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 12,
  ),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: const Color(0xffFFF3EA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
  boxIcon,
  width: 8,
  height: 8,
  color: AppColors.primary,
),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Order ID",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    controller.orderId.value,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${controller.date.value}   ${controller.time.value}",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            Column(
  crossAxisAlignment: CrossAxisAlignment.end,
  children: [
    /// Status Badge
    Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: controller.orderStatus.value == "Completed"
            ? Colors.green
            : controller.orderStatus.value == "Cancelled"
                ? Colors.red
                : const Color(0xffF37021),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        controller.orderStatus.value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    const SizedBox(height: 5),

    /// Completed Order
    if (controller.orderStatus.value == "Completed") ...[
      const Text(
        "Delivered on",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 10,
        ),
      ),
      Text(
        controller.deliveryDate.value, // Example: 12/03/2025
        style: const TextStyle(
          color: Colors.green,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    ]

    /// Cancelled Order
    else if (controller.orderStatus.value == "Cancelled" ||
        controller.orderStatus.value == "Cancel") ...[
      const SizedBox(height: 6),

  InkWell(
     onTap: () {
    ReasonDialog.show(
      controller.cancelReason.value,
    );
  },
    child: Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 58, 134, 248),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.remove_red_eye_outlined,
            color: Colors.white,
            size: 12,
          ),
          SizedBox(width: 4),
          Text(
            "Reason",
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  ),
]

    /// Pending Order
    else ...[
      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 3,
        ),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          "Payment : ${controller.paymentStatus.value}",
          style: TextStyle(
            color: Colors.green.shade700,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      const SizedBox(height: 4),

      Text(
        "Method : ${controller.paymentMethod.value}",
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 10,
        ),
      ),
    ],
  ],
),
          ],
        ),
      ),
    );
  }
}