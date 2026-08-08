import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';
import 'package:restaurant_app/src/core/utils/helper/texthelper.dart';
import 'package:restaurant_app/src/presentation/view/products/product_screen.dart';
import 'package:restaurant_app/src/presentation/view/orders/order_screen.dart';
import 'package:restaurant_app/src/presentation/controller/home_controller.dart';

class OverviewCards extends StatelessWidget {
  const OverviewCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _OverviewCard(
            title: 'Orders',
            value: '200',
            icon: boxIcon,
            iconBackground: const Color(0xFFFFF0E7),
            iconColor: AppColors.primary,
            onViewTap: () {
              if (Get.isRegistered<HomeController>()) {
                Get.find<HomeController>().changeTab(1);
              } else {
                Get.to(() => OrdersScreen());
              }
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _OverviewCard(
            title: 'Product',
            value: '200',
            icon: addImageIcon,
            iconBackground: const Color(0xFFE8FBEF),
            iconColor: AppColors.green,
            onViewTap: () {
              Get.to(() => const ProductListScreen());
            },
          ),
        ),
      ],
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.onViewTap,
  });

  final String title;
  final String value;
  final String icon;
  final Color iconBackground;
  final Color iconColor;
  final VoidCallback onViewTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 104,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x13000000),
              blurRadius: 9,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextHelper.heading2.copyWith(
                        color: AppColors.textprimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: TextHelper.heading2.copyWith(
                        color: AppColors.textprimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: iconBackground,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: SvgPicture.asset(
                      icon,
                      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                    ),
                  ),
                  const SizedBox(height: 2),
                  GestureDetector(
  onTap: onViewTap,
  child: const Text(
    'View',
    style: TextStyle(
      color: AppColors.button2,
      fontSize: 10,
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
    ),
  ),
),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
