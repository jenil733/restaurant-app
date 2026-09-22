import 'orders_model.dart';

class RecentOrdersResponseModel {
  final bool success;
  final String message;
  final List<OrderModel> data;
  final int? code;

  RecentOrdersResponseModel({
    required this.success,
    required this.message,
    required this.data,
    this.code,
  });

  factory RecentOrdersResponseModel.fromJson(Map<String, dynamic> json) {
    bool isSuccess = false;
    final statusVal = json['status'];
    final successVal = json['success'];
    final codeVal = json['code'] is int
        ? json['code'] as int
        : int.tryParse(json['code']?.toString() ?? '');

    if (statusVal is bool) {
      isSuccess = statusVal;
    } else if (statusVal is num) {
      isSuccess = statusVal == 1 || statusVal == 200 || statusVal == 201;
    } else if (statusVal is String) {
      final s = statusVal.toLowerCase().trim();
      isSuccess =
          s == 'success' || s == 'true' || s == '1' || s == '200' || s == 'ok';
    } else if (successVal is bool) {
      isSuccess = successVal;
    } else if (successVal is num) {
      isSuccess = successVal == 1 || successVal == 200 || successVal == 201;
    } else if (successVal is String) {
      final s = successVal.toLowerCase().trim();
      isSuccess = s == 'success' || s == 'true' || s == '1' || s == 'ok';
    } else if (codeVal == 200 || codeVal == 201) {
      isSuccess = true;
    }

    List<OrderModel> orders = [];
    final rawData = json['data'] ?? json['recent_orders'] ?? json['orders'];
    if (rawData is List) {
      orders = rawData
          .whereType<Map>()
          .map((e) => OrderModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      isSuccess = true;
    } else if (rawData is Map) {
      final nestedList =
          rawData['recent_orders'] ?? rawData['orders'] ?? rawData['data'];
      if (nestedList is List) {
        orders = nestedList
            .whereType<Map>()
            .map((e) => OrderModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        isSuccess = true;
      }
    }

    return RecentOrdersResponseModel(
      success: isSuccess,
      message: json['message']?.toString() ?? '',
      data: orders,
      code: codeVal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
      if (code != null) 'code': code,
    };
  }
}
