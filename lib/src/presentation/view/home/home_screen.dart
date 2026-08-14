import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';
import 'package:restaurant_app/src/presentation/controller/home_controller.dart';
import 'package:restaurant_app/src/presentation/view/home/widgets/dashboard_page.dart';
import 'package:restaurant_app/src/presentation/view/home/widgets/section_page.dart';
import 'package:restaurant_app/src/presentation/view/drawer.dart';
import 'package:restaurant_app/src/presentation/view/orders/order_screen.dart';
import 'package:restaurant_app/src/presentation/view/products/add_product_screen.dart';
import 'package:restaurant_app/src/presentation/view/products/product_screen.dart';
import 'package:restaurant_app/src/presentation/view/profile/profile_screen.dart';
import 'package:restaurant_app/src/presentation/widgets/app_bottom_navigation_bar.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Obx(
        () => PopScope(
          canPop: controller.currentIndex.value == 0,
          onPopInvoked: (didPop) {
            if (didPop) return;
            controller.changeTab(0);
          },
          child: Scaffold(
            key: controller.scaffoldKey,
            drawer: const CustomDrawer(),
            backgroundColor: AppColors.background,
        body: PageView(
          controller: controller.pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const DashboardPage(),
            OrdersScreen(),
            const ProductListScreen(),
  ProfileScreen(),
          ],
        ),
        bottomNavigationBar: Obx(
          () => AppBottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
          ),

        ),
          ),
        ),
      ),
    );
  }
}
