import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';
import 'package:restaurant_app/src/presentation/controller/notification_controller.dart';
import 'package:restaurant_app/src/presentation/widgets/app_bar.dart';
import 'widgets/notification_card.dart';
import 'widgets/notification_filter_tabs.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<NotificationController>()
        ? Get.find<NotificationController>()
        : Get.put(NotificationController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: "Notifications",
        actions: [
          Obx(() {
            if (controller.notifications.isEmpty) return const SizedBox.shrink();

            return PopupMenuButton<String>(
              icon: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.more_vert_rounded,
                  color: Color(0xFF3A4A7A),
                  size: 20,
                ),
              ),
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) {
                if (value == 'mark_all_read') {
                  controller.markAllAsRead();
                } else if (value == 'clear_all') {
                  _showClearAllDialog(context, controller);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'mark_all_read',
                  enabled: controller.unreadCount > 0,
                  child: Row(
                    children: [
                      Icon(
                        Icons.done_all_rounded,
                        size: 18,
                        color: controller.unreadCount > 0
                            ? AppColors.primary
                            : Colors.grey,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Mark all as read',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: controller.unreadCount > 0
                              ? const Color(0xFF1F2937)
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'clear_all',
                  child: Row(
                    children: [
                      const Icon(
                        Icons.delete_sweep_outlined,
                        size: 18,
                        color: AppColors.red,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Clear all notifications',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
          const SizedBox(width: 12),
        ],
      ),
      body: Obx(() {
        final currentFilter = controller.selectedFilter.value;
        final items = controller.filteredNotifications;

        final tabs = [
          FilterTabItem(
            key: 'all',
            label: 'All',
            count: controller.allCount,
            icon: Icons.all_inbox_rounded,
          ),
          FilterTabItem(
            key: 'unread',
            label: 'Unread',
            count: controller.unreadCount,
            icon: Icons.mark_email_unread_rounded,
          ),
          FilterTabItem(
            key: 'orders',
            label: 'Orders',
            count: controller.ordersCount,
            icon: Icons.receipt_long_rounded,
          ),
          FilterTabItem(
            key: 'store',
            label: 'Store',
            count: controller.storeCount,
            icon: Icons.storefront_rounded,
          ),
          FilterTabItem(
            key: 'reviews',
            label: 'Reviews',
            count: controller.reviewsCount,
            icon: Icons.star_outline_rounded,
          ),
          FilterTabItem(
            key: 'payouts',
            label: 'Payouts',
            count: controller.payoutsCount,
            icon: Icons.account_balance_wallet_outlined,
          ),
        ];

        return Column(
          children: [
            const SizedBox(height: 12),

            // Horizontal Filter Tabs
            NotificationFilterTabs(
              selectedFilter: currentFilter,
              tabs: tabs,
              onFilterChanged: controller.setFilter,
            ),

            const SizedBox(height: 12),

            // Status Bar (Unread alert + Mark all quick button)
            if (controller.unreadCount > 0 && currentFilter != 'payouts')
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFFF3EB),
                      const Color(0xFFFFF8F3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "You have ${controller.unreadCount} unread notification${controller.unreadCount > 1 ? 's' : ''}",
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF9A3412),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => controller.markAllAsRead(),
                      borderRadius: BorderRadius.circular(6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        child: Text(
                          "Mark all read",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Notification List or Empty State
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                backgroundColor: Colors.white,
                onRefresh: () => controller.fetchNotifications(isRefresh: true),
                child: controller.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    : items.isEmpty
                        ? _buildEmptyState(context, controller, currentFilter)
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                            physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                            itemCount: items.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return NotificationCard(
                                item: item,
                                onTap: () => controller.handleNotificationTap(item),
                                onDelete: () => controller.deleteNotification(item.id),
                                onActionTap: () => controller.handleNotificationTap(item),
                              );
                            },
                          ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    NotificationController controller,
    String currentFilter,
  ) {
    final isFiltered = currentFilter != 'all';

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - 40,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Illustration
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Image.asset(
                          notificationImg,
                          width: 65,
                          height: 65,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.notifications_off_outlined,
                            size: 54,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title
                    Text(
                      isFiltered
                          ? "No ${currentFilter.capitalizeFirst} Notifications"
                          : "No Notifications Yet",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      isFiltered
                          ? "You don't have any notifications under '$currentFilter'. Switch to All to see all alerts."
                          : "You're all caught up! New order updates, customer reviews, and announcements will appear here.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6B7280),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    if (isFiltered)
                      ElevatedButton.icon(
                        onPressed: () => controller.setFilter('all'),
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: Text(
                          "Show All Notifications",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showClearAllDialog(
    BuildContext context,
    NotificationController controller,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.red.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_sweep_rounded,
                color: AppColors.red,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "Clear All?",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
              ),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to delete all notifications? This action cannot be undone.",
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF4B5563),
            height: 1.4,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "Cancel",
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.clearAllNotifications();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Clear All",
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
