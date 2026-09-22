class SalesReportOrderModel {
  final dynamic id;
  final String orderId;
  final String productName;
  final int quantity;
  final String status;
  final dynamic amount;
  final String? createdAt;

  SalesReportOrderModel({
    this.id,
    required this.orderId,
    required this.productName,
    required this.quantity,
    required this.status,
    this.amount,
    this.createdAt,
  });

  factory SalesReportOrderModel.fromJson(Map<String, dynamic> json) {
    int qty = 1;
    final rawQty = json['quantity'] ?? json['qty'] ?? json['total_quantity'] ?? json['items_count'];
    if (rawQty is int) {
      qty = rawQty;
    } else if (rawQty is num) {
      qty = rawQty.toInt();
    } else if (rawQty is String) {
      qty = int.tryParse(rawQty) ?? 1;
    }

    return SalesReportOrderModel(
      id: json['id'] ?? json['order_id'],
      orderId: json['order_id']?.toString() ??
          json['order_number']?.toString() ??
          json['id']?.toString() ??
          '',
      productName: json['product_name']?.toString() ??
          json['product']?.toString() ??
          json['name']?.toString() ??
          json['title']?.toString() ??
          'Item',
      quantity: qty,
      status: json['status']?.toString() ?? 'Pending',
      amount: json['amount'] ?? json['total'] ?? json['total_amount'] ?? json['price'],
      createdAt: json['created_at']?.toString() ?? json['date']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'order_id': orderId,
      'product_name': productName,
      'quantity': quantity,
      'status': status,
      if (amount != null) 'amount': amount,
      if (createdAt != null) 'created_at': createdAt,
    };
  }
}

class SalesReportDataModel {
  final num totalSales;
  final int totalOrders;
  final num avgOrder;
  final int customers;
  final List<SalesReportOrderModel> recentOrders;

  SalesReportDataModel({
    required this.totalSales,
    required this.totalOrders,
    required this.avgOrder,
    required this.customers,
    required this.recentOrders,
  });

  factory SalesReportDataModel.fromJson(Map<String, dynamic> json) {
    num parseNum(dynamic val, [num fallback = 0]) {
      if (val is num) return val;
      if (val is String) {
        final cleaned = val.replaceAll('₹', '').replaceAll(',', '').trim();
        return num.tryParse(cleaned) ?? fallback;
      }
      return fallback;
    }

    int parseInt(dynamic val, [int fallback = 0]) {
      if (val is int) return val;
      if (val is num) return val.toInt();
      if (val is String) {
        final cleaned = val.replaceAll(',', '').trim();
        return int.tryParse(cleaned) ?? fallback;
      }
      return fallback;
    }

    List<SalesReportOrderModel> orders = [];
    final rawOrders = json['recent_orders'] ?? json['orders'] ?? json['order_list'];
    if (rawOrders is List) {
      orders = rawOrders
          .whereType<Map>()
          .map((item) => SalesReportOrderModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    return SalesReportDataModel(
      totalSales: parseNum(json['total_sales'] ?? json['sales']),
      totalOrders: parseInt(json['total_orders'] ?? json['orders_count']),
      avgOrder: parseNum(json['avg_order'] ?? json['average_order']),
      customers: parseInt(json['customers'] ?? json['total_customers'] ?? json['customers_count']),
      recentOrders: orders,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_sales': totalSales,
      'total_orders': totalOrders,
      'avg_order': avgOrder,
      'customers': customers,
      'recent_orders': recentOrders.map((o) => o.toJson()).toList(),
    };
  }
}

class SalesReportResponseModel {
  final bool success;
  final String message;
  final SalesReportDataModel? data;
  final int? code;

  SalesReportResponseModel({
    required this.success,
    required this.message,
    this.data,
    this.code,
  });

  factory SalesReportResponseModel.fromJson(Map<String, dynamic> json) {
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
      isSuccess = s == 'success' || s == 'true' || s == '1' || s == '200' || s == 'ok';
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

    SalesReportDataModel? dataModel;
    final rawData = json['data'];
    if (rawData is Map) {
      dataModel = SalesReportDataModel.fromJson(Map<String, dynamic>.from(rawData));
      isSuccess = true;
    }

    return SalesReportResponseModel(
      success: isSuccess,
      message: json['message']?.toString() ?? '',
      data: dataModel,
      code: codeVal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (data != null) 'data': data!.toJson(),
      if (code != null) 'code': code,
    };
  }
}
