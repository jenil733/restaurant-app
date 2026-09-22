import 'package:flutter/foundation.dart';

class NotificationItemModel {
  final String id;
  final String title;
  final String message;
  final String type; // 'order', 'store', 'review', 'payout', 'system', 'feedback'
  final DateTime createdAt;
  bool isRead;
  final String? route;
  final String? image;
  final String? actionText;
  final Map<String, dynamic>? extraData;

  NotificationItemModel({
    required this.id,
    required this.title,
    required this.message,
    this.type = 'system',
    required this.createdAt,
    this.isRead = false,
    this.route,
    this.image,
    this.actionText,
    this.extraData,
  });

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    final rawDate = json['created_at'] ?? json['createdAt'] ?? json['date'] ?? json['time'];
    if (rawDate is String) {
      parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();
    } else if (rawDate is int) {
      parsedDate = DateTime.fromMillisecondsSinceEpoch(rawDate);
    } else {
      parsedDate = DateTime.now();
    }

    bool parseBool(dynamic val) {
      if (val is bool) return val;
      if (val is int) return val == 1;
      if (val is String) return val.toLowerCase() == 'true' || val == '1';
      return false;
    }

    return NotificationItemModel(
      id: json['id']?.toString() ??
          json['notification_id']?.toString() ??
          'notif_${DateTime.now().millisecondsSinceEpoch}',
      title: json['title']?.toString() ??
          json['heading']?.toString() ??
          'Notification',
      message: json['message']?.toString() ??
          json['body']?.toString() ??
          json['description']?.toString() ??
          '',
      type: (json['type']?.toString() ?? 'system').toLowerCase(),
      createdAt: parsedDate,
      isRead: parseBool(json['is_read'] ?? json['isRead'] ?? json['read']),
      route: json['route']?.toString() ?? json['target_screen']?.toString(),
      image: json['image']?.toString() ?? json['icon']?.toString(),
      actionText: json['action_text']?.toString() ?? json['actionText']?.toString(),
      extraData: json['extra_data'] is Map<String, dynamic>
          ? json['extra_data'] as Map<String, dynamic>
          : (json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead,
      if (route != null) 'route': route,
      if (image != null) 'image': image,
      if (actionText != null) 'action_text': actionText,
      if (extraData != null) 'extra_data': extraData,
    };
  }

  NotificationItemModel copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    DateTime? createdAt,
    bool? isRead,
    String? route,
    String? image,
    String? actionText,
    Map<String, dynamic>? extraData,
  }) {
    return NotificationItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      route: route ?? this.route,
      image: image ?? this.image,
      actionText: actionText ?? this.actionText,
      extraData: extraData ?? this.extraData,
    );
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inSeconds < 45) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final mins = difference.inMinutes;
      return '$mins min${mins > 1 ? 's' : ''} ago';
    } else if (difference.inHours < 24) {
      final hrs = difference.inHours;
      return '$hrs hr${hrs > 1 ? 's' : ''} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      final year = createdAt.year == now.year ? '' : '/${createdAt.year}';
      return '${createdAt.day.toString().padLeft(2, '0')}/${createdAt.month.toString().padLeft(2, '0')}$year';
    }
  }
}

class NotificationResponseModel {
  final bool success;
  final String message;
  final List<NotificationItemModel> notifications;
  final int unreadCount;

  NotificationResponseModel({
    required this.success,
    required this.message,
    required this.notifications,
    this.unreadCount = 0,
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    bool isSuccess = false;
    final statusVal = json['status'];
    final successVal = json['success'];

    if (statusVal is bool) {
      isSuccess = statusVal;
    } else if (statusVal == 'success' || statusVal == 1 || statusVal == 200 || statusVal == '200') {
      isSuccess = true;
    } else if (successVal is bool) {
      isSuccess = successVal;
    } else if (successVal == 1 || successVal == 200) {
      isSuccess = true;
    } else if (json['data'] != null) {
      isSuccess = true;
    }

    List<NotificationItemModel> list = [];
    final rawList = json['notifications'] ?? json['data'] ?? json['items'];
    if (rawList is List) {
      list = rawList
          .whereType<Map>()
          .map((item) => NotificationItemModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    int unread = 0;
    if (json['unread_count'] is int) {
      unread = json['unread_count'] as int;
    } else {
      unread = list.where((n) => !n.isRead).length;
    }

    return NotificationResponseModel(
      success: isSuccess,
      message: json['message']?.toString() ?? '',
      notifications: list,
      unreadCount: unread,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'notifications': notifications.map((n) => n.toJson()).toList(),
      'unread_count': unreadCount,
    };
  }
}
