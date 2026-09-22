import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';
import 'package:restaurant_app/src/core/utils/helper/texthelper.dart';
import 'package:restaurant_app/src/presentation/view/home/widgets/promotion_carousel.dart';
import 'package:restaurant_app/src/presentation/widgets/app_embedded_image.dart';
import 'package:restaurant_app/src/core/utils/navigation/app_routes.dart';
import 'package:restaurant_app/src/presentation/controller/home_controller.dart';
import 'package:restaurant_app/src/presentation/controller/notification_controller.dart';

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
        _HeaderIcon(
          asset: sideMenuIcon,
          onTap: () {
            if (Get.isRegistered<HomeController>()) {
              Get.find<HomeController>().openDrawer();
            }
          },
        ),
        const SizedBox(width: 10),
        Builder(
          builder: (context) {
            final homeController = Get.isRegistered<HomeController>()
                ? Get.find<HomeController>()
                : null;

            if (homeController == null) {
              return Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x17000000),
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(radius: 5, backgroundColor: AppColors.green),
                    const SizedBox(width: 8),
                    Text(
                      'Online',
                      style: TextHelper.provalue1,
                    ),
                  ],
                ),
              );
            }

            return Obx(() {
              final isOnline = homeController.isOnline.value;
              final isUpdating = homeController.isUpdatingStatus.value;

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isUpdating ? null : homeController.toggleOnlineStatus,
                  borderRadius: BorderRadius.circular(8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 42,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isOnline
                            ? AppColors.green.withValues(alpha: 0.35)
                            : const Color(0xFFE0E0E0),
                        width: 1.2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x17000000),
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isUpdating)
                          const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          )
                        else
                          CircleAvatar(
                            radius: 5,
                            backgroundColor:
                                isOnline ? AppColors.green : const Color(0xFF9E9E9E),
                          ),
                        const SizedBox(width: 8),
                        Text(
                          isOnline ? 'Online' : 'Offline',
                          style: TextHelper.provalue1.copyWith(
                            color: isOnline
                                ? const Color(0xFF252B35)
                                : const Color(0xFF757575),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
          },
        ),
        const Spacer(),
        Obx(() {
          final notifController = Get.isRegistered<NotificationController>()
              ? Get.find<NotificationController>()
              : Get.put(NotificationController());
          final hasUnread = notifController.unreadCount > 0;
          return _HeaderIcon(
            asset: notificationIcon,
            showBadge: hasUnread,
            onTap: () => Get.toNamed(AppRoutes.notification),
          );
        }),
      ],
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    required this.asset,
    this.onTap,
    this.showBadge = false,
  });

  final String asset;
  final VoidCallback? onTap;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(7),
        child: DecoratedBox(
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
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Center(
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
                if (showBadge)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
