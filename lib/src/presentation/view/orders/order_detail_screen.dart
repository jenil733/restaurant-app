import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/presentation/controller/order_deatil_controller.dart';
import 'package:restaurant_app/src/presentation/view/orders/widgets/accept_order_dialog.dart';
import 'package:restaurant_app/src/presentation/view/orders/widgets/reject_order_dialog.dart';
import '../../widgets/app_bar.dart';
import 'widgets/customer_detail_card.dart';
import 'widgets/order_info_card.dart';
import 'widgets/ordered_items_card.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late final OrderDetailController controller;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<OrderDetailController>()) {
      controller = Get.find<OrderDetailController>();
      controller.loadOrder(Get.arguments);
    } else {
      controller = Get.put(OrderDetailController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: const CustomAppBar(
        title: "Order Details",
      ),

      body: RefreshIndicator(
        onRefresh: () => controller.fetchOrderDetails(controller.rawOrderId, isRefresh: true),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xffF37021),
              ),
            );
          }

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                OrderInfoCard(),

                const SizedBox(height: 16),

                CustomerDetailCard(),

                const SizedBox(height: 16),

                OrderedItemsCard(),

                //================ "If Food Ready Notify Delivery Partner" Button ================
                if (!controller.isCompleted && !controller.isCancelled) ...[
                  const SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: 230,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: controller.isMarkingFoodReady.value
                            ? null
                            : () => controller.markFoodReady(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.isFoodReady
                              ? const Color(0xFF00B4D8)
                              : const Color(0xFF22C55E),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 12,
                          ),
                        ),
                        child: controller.isMarkingFoodReady.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "If Food Ready",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      height: 1.2,
                                    ),
                                  ),
                                  Text(
                                    "Notify Delivery Partner",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 25),
              ],
            ),
          );
        }),
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: 28,
          ),
          child: Obx(() {
            if (!controller.isCompleted && !controller.isCancelled) {
              return Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: (controller.isRejecting.value ||
                                controller.isAccepting.value)
                            ? null
                            : () {
                                RejectOrderDialog.show(
                                  onSubmit: (reason) {
                                    controller.rejectOrder(reason);
                                  },
                                );
                              },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          side: const BorderSide(
                            color: Color(0xFFFF4D4F),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: controller.isRejecting.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFFFF4D4F),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.cancel_outlined,
                                    color: Color(0xFFFF4D4F),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      "Reject Order",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFFFF4D4F),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: (controller.isAccepting.value ||
                                controller.isRejecting.value)
                            ? null
                            : () {
                                AcceptOrderDialog.show(
                                  onAccept: controller.acceptOrder,
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffF37021),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: controller.isAccepting.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      "Accept Order",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return _buildDownloadInvoiceButton();
          }),
        ),
      ),
    );
  }

  Widget _buildDownloadInvoiceButton() {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: controller.isDownloadingInvoice.value
            ? null
            : () => controller.downloadInvoice(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 0,
          side: const BorderSide(
            color: Color(0xffF37021),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        icon: controller.isDownloadingInvoice.value
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              )
            : const Icon(
                Icons.download,
                color: AppColors.primary,
              ),
        label: Text(
          controller.isDownloadingInvoice.value
              ? "Downloading..."
              : "Download Invoice",
          style: GoogleFonts.poppins(
            color: AppColors.primary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}