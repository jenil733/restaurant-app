import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';
import 'package:restaurant_app/src/core/utils/helper/image_helper.dart';
import 'package:restaurant_app/src/presentation/controller/profile_controller.dart';
import 'package:restaurant_app/src/core/utils/helper/approval_helper.dart';

Widget profileCard(ProfileController controller) {
  return Obx(
    () {
      final imgUrl = ImageHelper.getImageUrl(controller.profileImage.value);

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 90, 20, 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -80,
              left: 0,
              right: 0,
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      width: 82,
                      height: 82,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        color: Colors.grey.shade200,
                      ),
                      child: ClipOval(
                        child: imgUrl != null && imgUrl.isNotEmpty
                            ? (imgUrl.startsWith('assets/')
                                ? Image.asset(
                                    imgUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Image.asset(
                                      userProfile,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Image.network(
                                    imgUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Image.asset(
                                      userProfile,
                                      fit: BoxFit.cover,
                                    ),
                                  ))
                            : Image.asset(
                                userProfile,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  Positioned(
                    bottom: 2,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.pink, width: 1),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Colors.pink,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: -70,
            right: 0,
            child: Builder(
              builder: (context) {
                final statusStr = controller.businessStatus.value.trim();
                final stLower = statusStr.toLowerCase();
                final isAppr = isRestaurantApproved() ||
                    controller.isActive.value ||
                    stLower == 'approved' ||
                    stLower == 'active' ||
                    stLower == '1';
                final isPend = !isAppr && (stLower == 'pending' ||
                    stLower == 'in_progress' ||
                    stLower == '0');
                
                final Color bgColor = isAppr
                    ? const Color(0xffE7F8EC)
                    : isPend
                        ? const Color(0xffFFF4E5)
                        : const Color(0xffFDEAEA);
                final Color textColor = isAppr
                    ? Colors.green
                    : isPend
                        ? Colors.orange.shade800
                        : Colors.red;
                final String displayText = isAppr
                    ? "Approved"
                    : (statusStr.isNotEmpty ? statusStr : (isPend ? "Pending" : "Inactive"));

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 4,
                        backgroundColor: textColor,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        displayText,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(height: 25),
                Text(
                  controller.restaurantName.value.isNotEmpty
                      ? controller.restaurantName.value
                      : (controller.isLoading.value ? "Loading..." : "Restaurant"),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  controller.ownerName.value.isNotEmpty
                      ? "Owner : ${controller.ownerName.value}"
                      : (controller.isLoading.value ? "" : "Owner : N/A"),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 17),
                ),
                if (controller.restaurantId.value.isNotEmpty &&
                    controller.restaurantId.value != 'null') ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xff2E3C97).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xff2E3C97).withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      controller.restaurantId.value.toLowerCase().startsWith("rst") ||
                              controller.restaurantId.value.toLowerCase().startsWith("id:")
                          ? (controller.restaurantId.value.toLowerCase().startsWith("id:")
                              ? controller.restaurantId.value
                              : "ID: ${controller.restaurantId.value}")
                          : (int.tryParse(controller.restaurantId.value) != null
                              ? "ID: RST${controller.restaurantId.value.padLeft(3, '0')}"
                              : "ID: ${controller.restaurantId.value}"),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff2E3C97),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  });
}
