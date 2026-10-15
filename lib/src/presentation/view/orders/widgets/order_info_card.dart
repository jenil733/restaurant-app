import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
                  Text(
                    "Order ID",
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    controller.orderId.value,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${controller.date.value}   ${controller.time.value}",
                    style: GoogleFonts.poppins(
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
                    color: controller.isCompleted
                        ? Colors.green
                        : controller.isCancelled
                            ? Colors.red
                            : controller.isFoodReady
                                ? const Color(0xFF059669)
                                : controller.isAccepted
                                    ? const Color(0xFF2563EB)
                                    : const Color(0xffF37021),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    controller.formattedStatus,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                /// Completed Order
                if (controller.isCompleted) ...[
                  Text(
                    "Delivered on",
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    controller.deliveryDate.value.isNotEmpty
                        ? controller.deliveryDate.value
                        : controller.date.value,
                    style: GoogleFonts.poppins(
                      color: Colors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ]

                /// Cancelled Order
                else if (controller.isCancelled) ...[
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
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.remove_red_eye_outlined,
                            color: Colors.white,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Reason",
                            style: GoogleFonts.poppins(
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

                /// Pending, Accepted, or Food Ready Order
                else ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: controller.isPaid
                          ? Colors.green.shade50
                          : const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "Payment : ${controller.formattedPaymentStatus}",
                      style: GoogleFonts.poppins(
                        color: controller.isPaid
                            ? Colors.green.shade700
                            : const Color(0xFFEA580C),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Method : ${controller.formattedPaymentMethod}",
                    style: GoogleFonts.poppins(
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