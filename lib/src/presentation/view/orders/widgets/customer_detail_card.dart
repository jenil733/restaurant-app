import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/src/presentation/controller/order_deatil_controller.dart';

class CustomerDetailCard extends StatelessWidget {
  CustomerDetailCard({super.key});

  final OrderDetailController controller = Get.find<OrderDetailController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
            // Blue user icon avatar
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: const Color(0xffEAF4FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.person_outline,
                color: Color(0xFF2F80ED),
                size: 26,
              ),
            ),

            const SizedBox(width: 12),

            // Middle customer info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Customer Detail",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    controller.customerName.value.isNotEmpty
                        ? controller.customerName.value
                        : "Customer",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Phone row (tap to call)
                  InkWell(
                    onTap: controller.makeCall,
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.phone,
                            size: 14,
                            color: Color(0xffF37021),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              controller.phone.value.isNotEmpty
                                  ? controller.phone.value
                                  : "No phone",
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF94A3B8),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Address row (tap to open map)
                  InkWell(
                    onTap: controller.openMap,
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 1),
                            child: Icon(
                              Icons.location_on,
                              size: 14,
                              color: Color(0xffF37021),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              controller.address.value.isNotEmpty
                                  ? controller.address.value
                                  : "No address",
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF94A3B8),
                                fontSize: 11,
                                height: 1.25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Right "View on Map" button
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: SizedBox(
                height: 32,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffF37021),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: controller.openMap,
                  icon: const Icon(
                    Icons.location_on_outlined,
                    color: Colors.white,
                    size: 14,
                  ),
                  label: Text(
                    "View on Map",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}