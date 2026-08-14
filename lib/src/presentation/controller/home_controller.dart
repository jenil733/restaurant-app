import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;
  final pageController = PageController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // Verification state (to simulate the flow)
  final isApproved = true.obs;
  final isRejected = true.obs;
  final rejectionReason = 'The Uploaded Document Is Incorrect.'.obs;

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  Future<void> changeTab(int index) async {
    if (index < 0 || index > 3 || index == currentIndex.value) {
      return;
    }

    currentIndex.value = index;
    if (!pageController.hasClients) {
      return;
    }

    await pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
