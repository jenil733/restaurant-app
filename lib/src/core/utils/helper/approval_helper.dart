import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/presentation/controller/home_controller.dart';
import 'package:restaurant_app/src/presentation/controller/profile_controller.dart';

/// Checks if the restaurant is approved by the admin.
bool isRestaurantApproved() {
  if (Get.isRegistered<HomeController>()) {
    final homeCtrl = Get.find<HomeController>();
    if (homeCtrl.isApproved.value) return true;
  }
  if (Get.isRegistered<ProfileController>()) {
    final p = Get.find<ProfileController>().profile.value;
    if (p != null) {
      final st = (p.status ?? p.businessStatus)?.toString().toLowerCase().trim();
      if (st == 'approved' || st == 'active' || st == '1' || st == 'true') {
        return true;
      }
    }
  }
  return false;
}

/// Displays a friendly dialog informing the restaurant owner that admin approval is needed.
void showApprovalRequiredDialog(BuildContext context, {String action = 'add categories and products'}) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(
        children: [
          Icon(Icons.hourglass_top_rounded, color: Colors.orange, size: 26),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Verification Pending',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: Text(
        'Your restaurant registration is currently being reviewed by the admin. You will be able to $action as soon as your registration is approved.',
        style: TextStyle(fontSize: 13.5, color: Colors.grey.shade700, height: 1.4),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text(
            'OK',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      ],
    ),
  );
}
