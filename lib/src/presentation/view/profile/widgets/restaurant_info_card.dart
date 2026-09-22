import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/presentation/controller/profile_controller.dart';
import 'package:restaurant_app/src/presentation/view/profile/add_profile_screen.dart';

Widget restaurantCard(ProfileController controller) {
  return Obx(
    () => infoCard(
      title: "Restaurant Information",
      icon: Icons.storefront_outlined,
      children: [
        infoRow(
          Icons.storefront_outlined,
          "Restaurant Name",
          controller.restaurantName.value.isNotEmpty ? controller.restaurantName.value : "N/A",
          showArrow: true,
          onTap: () {
            Get.to(() => const ProfileScreen());
          },
        ),
        infoRow(
          Icons.restaurant_menu,
          "Restaurant Type",
          controller.foodType.value.isNotEmpty ? controller.foodType.value : "N/A",
          iconColor: Colors.deepOrange,
          bgColor: Colors.deepOrange.withOpacity(0.1),
        ),
        infoRow(
          Icons.person,
          "Owner Name",
          controller.ownerName.value.isNotEmpty ? controller.ownerName.value : "N/A",
        ),
        infoRow(
          Icons.call,
          "Mobile Number",
          controller.mobile.value.isNotEmpty ? controller.mobile.value : "N/A",
          iconColor: Colors.green,
          bgColor: Colors.green.withOpacity(0.1),
        ),
        infoRow(
          Icons.email_outlined,
          "Email Address",
          controller.email.value.isNotEmpty ? controller.email.value : "N/A",
          iconColor: Colors.blue,
          bgColor: Colors.blue.withOpacity(0.1),
        ),
        infoRow(
          Icons.location_on,
          "Restaurant Address",
          controller.address.value.isNotEmpty
              ? controller.address.value
              : ([
                  if (controller.street.value.isNotEmpty) controller.street.value,
                  if (controller.city.value.isNotEmpty) controller.city.value,
                  if (controller.pincode.value.isNotEmpty) controller.pincode.value,
                ].join(", ").isNotEmpty
                  ? [
                      if (controller.street.value.isNotEmpty) controller.street.value,
                      if (controller.city.value.isNotEmpty) controller.city.value,
                      if (controller.pincode.value.isNotEmpty) controller.pincode.value,
                    ].join(", ")
                  : "N/A"),
          iconColor: Colors.red,
          bgColor: Colors.red.withOpacity(0.1),
        ),
      ],
    ),
  );
}

Widget infoCard({
  required String title,
  required dynamic icon,
  required List<Widget> children,
  Color iconColor = const Color(0xffFF7A21),
}) {
  return Container(
    padding: const EdgeInsets.all(18),
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
      children: [
        Row(
          children: [
            icon is IconData ? Icon(icon, color: iconColor) : icon as Widget,
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    ),
  );
}

Widget infoRow(
  dynamic icon,
  String title,
  String value, {
  Color iconColor = const Color(0xffFF7A21),
  Color bgColor = const Color(0xffFFF4EB),
  bool showArrow = false,
  VoidCallback? onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: icon is IconData
                    ? Icon(
                        icon,
                        color: iconColor,
                        size: 24,
                      )
                    : icon as Widget,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            if (showArrow)
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
          ],
        ),
        const Divider(height: 24),
      ],
    ),
  );
}