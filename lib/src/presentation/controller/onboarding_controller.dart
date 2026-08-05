import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/utils/navigation/app_routes.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  static const int pageCount = 3;

  void onPageChanged(int page) {
    currentPage.value = page;
  }

  Future<void> nextPage() async {
    if (currentPage.value >= pageCount - 1) {
      Get.offAllNamed<void>(AppRoutes.login);
      return;
    }

    await pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  Future<void> previousPage() async {
    if (currentPage.value == 0) {
      return;
    }

    await pageController.previousPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  Future<void> skipToLastPage() async {
    Get.offAllNamed<void>(AppRoutes.login);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
