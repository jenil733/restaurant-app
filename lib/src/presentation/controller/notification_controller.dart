import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurant_app/src/data/models/notification_model.dart';
import 'package:restaurant_app/src/presentation/widgets/app_notification.dart';
import 'package:restaurant_app/src/core/utils/navigation/app_routes.dart';

class NotificationController extends GetxController {
  static const String _storageKey = 'restaurant_notifications_v2';

  var notifications = <NotificationItemModel>[].obs;
  var isLoading = false.obs;
  var selectedFilter = 'all'.obs; // 'all', 'unread', 'orders', 'store', 'reviews', 'payouts'

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  // Counts
  int get unreadCount => notifications.where((n) => !n.isRead).length;
  int get allCount => notifications.length;
  int get ordersCount => notifications.where((n) => n.type == 'order').length;
  int get storeCount => notifications.where((n) => n.type == 'store' || n.type == 'system').length;
  int get reviewsCount => notifications.where((n) => n.type == 'review' || n.type == 'feedback').length;
  int get payoutsCount => notifications.where((n) => n.type == 'payout').length;

  List<NotificationItemModel> get filteredNotifications {
    final filter = selectedFilter.value.toLowerCase();
    switch (filter) {
      case 'unread':
        return notifications.where((n) => !n.isRead).toList();
      case 'orders':
        return notifications.where((n) => n.type == 'order').toList();
      case 'store':
        return notifications.where((n) => n.type == 'store' || n.type == 'system').toList();
      case 'reviews':
        return notifications.where((n) => n.type == 'review' || n.type == 'feedback').toList();
      case 'payouts':
        return notifications.where((n) => n.type == 'payout').toList();
      case 'all':
      default:
        return notifications.toList();
    }
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  Future<void> fetchNotifications({bool isRefresh = false}) async {
    if (!isRefresh) {
      isLoading.value = true;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final rawJson = prefs.getString(_storageKey);

      if (rawJson != null && rawJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(rawJson);
        notifications.value = decoded
            .map((item) => NotificationItemModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        // Populate initial demo restaurant notifications if storage is empty
        notifications.value = _getDefaultNotifications();
        await _saveToStorage();
      }
    } catch (e) {
      debugPrint("Error loading notifications: $e");
      if (notifications.isEmpty) {
        notifications.value = _getDefaultNotifications();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(String id) async {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !notifications[index].isRead) {
      notifications[index] = notifications[index].copyWith(isRead: true);
      notifications.refresh();
      await _saveToStorage();
    }
  }

  Future<void> markAllAsRead() async {
    if (unreadCount == 0) return;
    
    notifications.value = notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifications.refresh();
    await _saveToStorage();
    
    AppNotification.showSuccess(
      title: 'Marked as Read',
      message: 'All notifications marked as read.',
    );
  }

  Future<void> deleteNotification(String id) async {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final removed = notifications.removeAt(index);
      notifications.refresh();
      await _saveToStorage();
      AppNotification.showDeleted(
        title: 'Deleted',
        message: "'${removed.title}' removed.",
      );
    }
  }

  Future<void> clearAllNotifications() async {
    if (notifications.isEmpty) return;
    notifications.clear();
    notifications.refresh();
    await _saveToStorage();
    AppNotification.showDeleted(
      title: 'Cleared',
      message: 'All notifications cleared.',
    );
  }

  Future<void> addNotification({
    required String title,
    required String message,
    String type = 'system',
    String? route,
    String? actionText,
    Map<String, dynamic>? extraData,
  }) async {
    final newNotif = NotificationItemModel(
      id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      type: type,
      createdAt: DateTime.now(),
      isRead: false,
      route: route,
      actionText: actionText,
      extraData: extraData,
    );
    notifications.insert(0, newNotif);
    notifications.refresh();
    await _saveToStorage();
  }

  void handleNotificationTap(NotificationItemModel item) {
    if (!item.isRead) {
      markAsRead(item.id);
    }

    if (item.route != null && item.route!.isNotEmpty) {
      final route = item.route!;
      if (route == '/orders' || route == AppRoutes.orders) {
        Get.toNamed(AppRoutes.home);
      } else if (route == '/product' || route == AppRoutes.product) {
        Get.toNamed(AppRoutes.product);
      } else {
        try {
          Get.toNamed(route);
        } catch (_) {
          // Fallback if named route isn't registered
        }
      }
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = notifications.map((n) => n.toJson()).toList();
      await prefs.setString(_storageKey, jsonEncode(list));
    } catch (e) {
      debugPrint("Error saving notifications: $e");
    }
  }

  List<NotificationItemModel> _getDefaultNotifications() {
    final now = DateTime.now();
    return [
      NotificationItemModel(
        id: '1',
        title: 'New Order Received! 🍕',
        message: 'Order #ORD-1042 for ₹540 with 2 items requires immediate preparation.',
        type: 'order',
        createdAt: now.subtract(const Duration(minutes: 6)),
        isRead: false,
        route: AppRoutes.orders,
        actionText: 'View Order',
        extraData: {'order_id': '1042', 'amount': 540},
      ),
      NotificationItemModel(
        id: '2',
        title: 'New 5-Star Customer Review ⭐',
        message: 'Rahul S. rated your "Special Chicken Biryani" with 5 stars: "Flavor was outstanding and delivery on time!"',
        type: 'review',
        createdAt: now.subtract(const Duration(hours: 1, minutes: 20)),
        isRead: false,
        actionText: 'Reply Review',
        extraData: {'rating': 5, 'customer': 'Rahul S.'},
      ),
      NotificationItemModel(
        id: '3',
        title: 'Store Verification Approved ✅',
        message: 'Congratulations! Your restaurant documents and FSSAI license have been approved by admin.',
        type: 'store',
        createdAt: now.subtract(const Duration(hours: 3)),
        isRead: false,
        actionText: 'Check Profile',
      ),
      NotificationItemModel(
        id: '4',
        title: 'Order Picked Up 🛵',
        message: 'Delivery partner has picked up order #ORD-1039 for customer Priya M.',
        type: 'order',
        createdAt: now.subtract(const Duration(hours: 6)),
        isRead: true,
        route: AppRoutes.orders,
      ),
      NotificationItemModel(
        id: '5',
        title: 'Weekly Payout Processed 💰',
        message: 'Payout of ₹18,450 for last week has been transferred to your registered HDFC bank account.',
        type: 'payout',
        createdAt: now.subtract(const Duration(days: 1, hours: 2)),
        isRead: true,
        actionText: 'View Bank Details',
      ),
      NotificationItemModel(
        id: '6',
        title: 'Inventory Low Stock Alert ⚠️',
        message: 'Paneer Butter Masala has only 3 portions remaining. Update your product inventory soon.',
        type: 'system',
        createdAt: now.subtract(const Duration(days: 2)),
        isRead: true,
        route: AppRoutes.product,
        actionText: 'Update Stock',
      ),
      NotificationItemModel(
        id: '7',
        title: 'Customer Feedback Received 💬',
        message: 'A customer submitted feedback regarding packaging quality.',
        type: 'feedback',
        createdAt: now.subtract(const Duration(days: 3)),
        isRead: true,
      ),
    ];
  }
}
