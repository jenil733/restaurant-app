class DashboardResponseModel {
  final bool success;
  final String? message;
  final DashboardDataModel? data;

  DashboardResponseModel({
    required this.success,
    this.message,
    this.data,
  });

  factory DashboardResponseModel.fromJson(Map<String, dynamic> json) {
    bool isSuccess = false;
    if (json['success'] is bool) {
      isSuccess = json['success'] as bool;
    } else if (json['status'] is bool) {
      isSuccess = json['status'] as bool;
    } else if (json['status'] == 'success' ||
        json['status'] == 1 ||
        json['status'] == '1' ||
        json['status'] == 200 ||
        json['status'] == '200') {
      isSuccess = true;
    } else if (json['data'] != null) {
      isSuccess = true;
    }

    DashboardDataModel? dataModel;
    if (json['data'] is Map<String, dynamic>) {
      dataModel = DashboardDataModel.fromJson(
        json['data'] as Map<String, dynamic>,
      );
    } else if (json['data'] == null &&
        (json.containsKey('orders_count') ||
            json.containsKey('products_count') ||
            json.containsKey('recent_orders') ||
            json.containsKey('total_orders') ||
            json.containsKey('total_products'))) {
      dataModel = DashboardDataModel.fromJson(json);
    }

    return DashboardResponseModel(
      success: isSuccess,
      message: json['message']?.toString(),
      data: dataModel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (message != null) 'message': message,
      if (data != null) 'data': data!.toJson(),
    };
  }
}

class DashboardDataModel {
  final int totalOrders;
  final int totalProducts;
  final int pendingOrders;
  final int completedOrders;
  final double totalEarnings;
  final bool? isApproved;
  final bool? isRejected;
  final String? rejectionReason;
  final String? rejectedDocument;
  final List<String> rejectedDocuments;
  final String? restaurantName;
  final String? restaurantStatus;
  final List<DashboardOrderModel> recentOrders;

  DashboardDataModel({
    this.totalOrders = 0,
    this.totalProducts = 0,
    this.pendingOrders = 0,
    this.completedOrders = 0,
    this.totalEarnings = 0.0,
    this.isApproved,
    this.isRejected,
    this.rejectionReason,
    this.rejectedDocument,
    this.rejectedDocuments = const [],
    this.restaurantName,
    this.restaurantStatus,
    this.recentOrders = const [],
  });

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic val) {
      if (val == null) return 0;
      if (val is int) return val;
      if (val is double) return val.toInt();
      return int.tryParse(val.toString()) ?? 0;
    }

    double parseDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is double) return val;
      if (val is int) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    final totalOrdersVal = parseInt(
      json['orders_count'] ??
          json['total_orders'] ??
          json['orders'] ??
          json['order_count'],
    );

    final totalProductsVal = parseInt(
      json['products_count'] ??
          json['total_products'] ??
          json['products'] ??
          json['product_count'],
    );

    final pendingOrdersVal = parseInt(
      json['pending_orders'] ??
          json['pending_orders_count'] ??
          json['pending'],
    );

    final completedOrdersVal = parseInt(
      json['completed_orders'] ??
          json['completed_orders_count'] ??
          json['completed'],
    );

    final totalEarningsVal = parseDouble(
      json['total_earnings'] ??
          json['earnings'] ??
          json['total_revenue'] ??
          json['revenue'],
    );

    List<DashboardOrderModel> ordersList = [];
    final ordersJson =
        json['recent_orders'] ?? json['orders_list'] ?? json['latest_orders'];
    if (ordersJson is List) {
      ordersList = ordersJson
          .whereType<Map<String, dynamic>>()
          .map((e) => DashboardOrderModel.fromJson(e))
          .toList();
    }

    bool? parseApproved(Map<String, dynamic> json) {
      final val = json['is_approved'] ??
          json['approved'] ??
          json['verification_status'] ??
          json['restaurant_status'] ??
          json['status'] ??
          json['is_active'];
      if (val == null) return null;
      if (val is bool) return val;
      if (val is num) return val == 1 || val == 200;
      if (val is String) {
        final s = val.toLowerCase().trim();
        if (s == 'approved' || s == 'active' || s == 'true' || s == '1' || s == 'enable') return true;
        if (s == 'pending' || s == 'in_progress' || s == '0' || s == 'false' || s == 'rejected' || s == 'inactive') return false;
      }
      return null;
    }

    bool? parseRejected(Map<String, dynamic> json) {
      final hasRejKey = json.containsKey('is_rejected') || json.containsKey('rejected');
      final val = json['is_rejected'] ??
          json['rejected'] ??
          json['verification_status'] ??
          json['status'];
      if (val == null) return null;
      if (val is bool) return val;
      if (val is num) {
        if (hasRejKey) return val == 1 || val == 2;
        return val == 2;
      }
      if (val is String) {
        final s = val.toLowerCase().trim();
        if (s == 'rejected' || s == 'true' || s == '2' || (hasRejKey && s == '1')) return true;
        if (s == 'approved' || s == 'active' || s == 'pending' || s == 'false' || s == '0') return false;
      }
      return null;
    }

    final singleDoc = (json['rejected_document'] ??
            json['rejected_doc'] ??
            json['rejected_document_name'] ??
            json['document_name'] ??
            json['document_type'] ??
            json['doc_type'])
        ?.toString();

    final List<String> rejectedList = [];
    final rawDocs = json['rejected_documents'] ?? json['rejected_docs'] ?? json['rejected_doc_list'];
    if (rawDocs is List) {
      for (var item in rawDocs) {
        if (item != null && item.toString().trim().isNotEmpty) {
          rejectedList.add(item.toString().trim());
        }
      }
    }
    if (singleDoc != null && singleDoc.trim().isNotEmpty) {
      if (singleDoc.contains(',')) {
        for (var p in singleDoc.split(',')) {
          if (p.trim().isNotEmpty && !rejectedList.contains(p.trim())) {
            rejectedList.add(p.trim());
          }
        }
      } else if (!rejectedList.contains(singleDoc.trim())) {
        rejectedList.add(singleDoc.trim());
      }
    }

    return DashboardDataModel(
      totalOrders: totalOrdersVal,
      totalProducts: totalProductsVal,
      pendingOrders: pendingOrdersVal,
      completedOrders: completedOrdersVal,
      totalEarnings: totalEarningsVal,
      isApproved: parseApproved(json),
      isRejected: parseRejected(json),
      rejectionReason: (json['rejection_reason'] ?? json['reject_reason'] ?? json['reason'] ?? json['rejection_note'])?.toString(),
      rejectedDocument: singleDoc,
      rejectedDocuments: rejectedList,
      restaurantName:
          (json['restaurant_name'] ?? json['name'] ?? json['restaurant'])
              ?.toString(),
      restaurantStatus:
          (json['restaurant_status'] ?? json['status'])?.toString(),
      recentOrders: ordersList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_orders': totalOrders,
      'total_products': totalProducts,
      'pending_orders': pendingOrders,
      'completed_orders': completedOrders,
      'total_earnings': totalEarnings,
      if (isApproved != null) 'is_approved': isApproved,
      if (isRejected != null) 'is_rejected': isRejected,
      if (rejectionReason != null) 'rejection_reason': rejectionReason,
      if (restaurantName != null) 'restaurant_name': restaurantName,
      if (restaurantStatus != null) 'restaurant_status': restaurantStatus,
      'recent_orders': recentOrders.map((e) => e.toJson()).toList(),
    };
  }
}

class DashboardOrderModel {
  final dynamic id;
  final String orderId;
  final String productName;
  final int quantity;
  final String status;
  final double totalAmount;
  final String? createdAt;

  DashboardOrderModel({
    this.id,
    required this.orderId,
    required this.productName,
    this.quantity = 1,
    this.status = 'Pending',
    this.totalAmount = 0.0,
    this.createdAt,
  });

  factory DashboardOrderModel.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic val) {
      if (val == null) return 1;
      if (val is int) return val;
      if (val is double) return val.toInt();
      return int.tryParse(val.toString()) ?? 1;
    }

    double parseDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is double) return val;
      if (val is int) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    String parseProductName(dynamic val) {
      if (val == null) return 'Product';
      if (val is String && val.isNotEmpty) return val;
      if (val is List && val.isNotEmpty) {
        final first = val.first;
        if (first is Map && first.containsKey('name')) {
          return first['name'].toString();
        }
        return first.toString();
      }
      return val.toString();
    }

    return DashboardOrderModel(
      id: json['id'],
      orderId: (json['order_id'] ?? json['id'] ?? '#0000').toString(),
      productName: parseProductName(
        json['product_name'] ?? json['product'] ?? json['items'] ?? json['name'],
      ),
      quantity: parseInt(json['qty'] ?? json['quantity'] ?? json['total_items']),
      status: (json['status'] ?? 'Pending').toString(),
      totalAmount: parseDouble(
        json['total_amount'] ?? json['total'] ?? json['amount'] ?? json['price'],
      ),
      createdAt: (json['created_at'] ?? json['date'] ?? json['time'])?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'order_id': orderId,
      'product_name': productName,
      'qty': quantity,
      'status': status,
      'total_amount': totalAmount,
      if (createdAt != null) 'created_at': createdAt,
    };
  }
}
