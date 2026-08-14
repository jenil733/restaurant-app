import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';
import 'package:restaurant_app/src/core/utils/helper/texthelper.dart';
import 'package:restaurant_app/src/presentation/view/home/widgets/promotion_carousel.dart';
import 'package:restaurant_app/src/presentation/widgets/app_embedded_image.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/presentation/controller/home_controller.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({required this.statusBarHeight, super.key});

  final double statusBarHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: statusBarHeight + 220,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned.fill(
            bottom: 70,
            child: AppEmbeddedImage(
              asset: header,
              fit: BoxFit.cover,
              fallback: ColoredBox(color: AppColors.primary),
            ),
          ),
          Positioned(
            top: statusBarHeight + 46,
            left: 20,
            right: 20,
            child: const _HeaderControls(),
          ),
          Positioned(
            top: statusBarHeight + 98,
            left: 20,
            right: 20,
            child: const PromotionCarousel(),
          ),
        ],
      ),
    );
  }
}

class _HeaderControls extends StatelessWidget {
  const _HeaderControls();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Get.find<HomeController>().openDrawer();
          },
          child: const _HeaderIcon(
            asset: sideMenuIcon,
          ),
        ),
        const SizedBox(width: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(color: Color(0x17000000), blurRadius: 8),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
            child: Row(
              children: [
                const CircleAvatar(radius: 8, backgroundColor: AppColors.green),
                const SizedBox(width: 6),
                Text(
                  'Online',
                  style: TextHelper.provalue1
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        const _HeaderIcon(asset: notificationIcon),
      ],
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(7),
        boxShadow: const [
          BoxShadow(
            color: Color(0x17000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SizedBox.square(
        dimension: 42,
        child: Center(
          child: SvgPicture.asset(
            asset,
            width: 23,
            height: 23,
            colorFilter: const ColorFilter.mode(
              AppColors.textprimary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
