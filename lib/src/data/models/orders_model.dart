class OrderItemDetailModel {
  final dynamic id;
  final String name;
  final int quantity;
  final num price;
  final String? image;

  OrderItemDetailModel({
    this.id,
    required this.name,
    this.quantity = 1,
    this.price = 0,
    this.image,
  });

  factory OrderItemDetailModel.fromJson(Map<String, dynamic> json) {
    int qty = 1;
    final rawQty = json['quantity'] ?? json['qty'] ?? json['count'];
    if (rawQty is int) {
      qty = rawQty;
    } else if (rawQty is num) {
      qty = rawQty.toInt();
    } else if (rawQty is String) {
      qty = int.tryParse(rawQty) ?? 1;
    }

    num parsedPrice = 0;
    final rawPrice = json['price'] ?? json['amount'] ?? json['rate'] ?? json['unit_price'];
    if (rawPrice is num) {
      parsedPrice = rawPrice;
    } else if (rawPrice is String) {
      final cleaned = rawPrice.replaceAll('₹', '').replaceAll(',', '').trim();
      parsedPrice = num.tryParse(cleaned) ?? 0;
    }

    return OrderItemDetailModel(
      id: json['id'] ?? json['product_id'] ?? json['item_id'],
      name: json['name']?.toString() ??
          json['product_name']?.toString() ??
          json['title']?.toString() ??
          'Item',
      quantity: qty,
      price: parsedPrice,
      image: json['image']?.toString() ??
          json['product_image']?.toString() ??
          json['photo']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      if (image != null) 'image': image,
    };
  }
}

class CustomerInfoModel {
  final String name;
  final String phone;
  final String address;
  final String? email;

  CustomerInfoModel({
    required this.name,
    required this.phone,
    required this.address,
    this.email,
  });

  factory CustomerInfoModel.fromJson(Map<String, dynamic> json) {
    return CustomerInfoModel(
      name: json['name']?.toString() ??
          json['customer_name']?.toString() ??
          json['user_name']?.toString() ??
          'Customer',
      phone: json['phone']?.toString() ??
          json['phone_number']?.toString() ??
          json['mobile']?.toString() ??
          '',
      address: json['address']?.toString() ??
          json['delivery_address']?.toString() ??
          json['location']?.toString() ??
          '',
      email: json['email']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
      if (email != null) 'email': email,
    };
  }
}

class OrderModel {
  final dynamic id;
  final String orderId;
  final String productName;
  final int quantity;
  final String status;
  final num amount;
  final num subtotal;
  final num deliveryCharge;
  final num discount;
  final String paymentStatus;
  final String paymentMethod;
  final String date;
  final String time;
  final CustomerInfoModel? customer;
  final List<OrderItemDetailModel> items;
  final String? cancelReason;

  OrderModel({
    this.id,
    required this.orderId,
    required this.productName,
    this.quantity = 1,
    required this.status,
    this.amount = 0,
    this.subtotal = 0,
    this.deliveryCharge = 0,
    this.discount = 0,
    this.paymentStatus = 'Paid',
    this.paymentMethod = 'Online',
    this.date = '',
    this.time = '',
    this.customer,
    this.items = const [],
    this.cancelReason,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    num parseNum(dynamic val, [num fallback = 0]) {
      if (val is num) return val;
      if (val is String) {
        final cleaned = val.replaceAll('₹', '').replaceAll(',', '').trim();
        return num.tryParse(cleaned) ?? fallback;
      }
      return fallback;
    }

    int parseInt(dynamic val, [int fallback = 1]) {
      if (val is int) return val;
      if (val is num) return val.toInt();
      if (val is String) {
        final cleaned = val.replaceAll(',', '').trim();
        return int.tryParse(cleaned) ?? fallback;
      }
      return fallback;
    }

    // Parse items list
    List<OrderItemDetailModel> itemsList = [];
    final rawItems = json['items'] ?? json['products'] ?? json['order_items'];
    if (rawItems is List) {
      itemsList = rawItems
          .whereType<Map>()
          .map((e) => OrderItemDetailModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    // Customer
    CustomerInfoModel? cust;
    if (json['customer'] is Map) {
      cust = CustomerInfoModel.fromJson(Map<String, dynamic>.from(json['customer']));
    } else if (json['customer_name'] != null ||
        json['phone'] != null ||
        json['delivery_address'] != null) {
      cust = CustomerInfoModel.fromJson(json);
    }

    String mainProduct = json['product_name']?.toString() ??
        json['product']?.toString() ??
        json['name']?.toString() ??
        '';

    if (mainProduct.isEmpty && itemsList.isNotEmpty) {
      mainProduct = itemsList.map((e) => e.name).join(', ');
    }
    if (mainProduct.isEmpty) mainProduct = 'Food Order';

    int totalQty = parseInt(
      json['quantity'] ?? json['qty'] ?? json['total_quantity'] ?? json['items_count'],
      itemsList.isNotEmpty
          ? itemsList.fold<int>(0, (prev, elem) => prev + elem.quantity)
          : 1,
    );

    final rawAmount = json['total_amount'] ??
        json['amount'] ??
        json['total'] ??
        json['price'] ??
        json['grand_total'];

    final rawSubtotal = json['subtotal'] ?? json['sub_total'] ?? rawAmount;

    return OrderModel(
      id: json['id'] ?? json['order_id'],
      orderId: json['order_id']?.toString() ??
          json['order_number']?.toString() ??
          (json['id'] != null ? '#${json['id']}' : '#1001'),
      productName: mainProduct,
      quantity: totalQty,
      status: json['status']?.toString() ?? 'Pending',
      amount: parseNum(rawAmount),
      subtotal: parseNum(rawSubtotal),
      deliveryCharge: parseNum(json['delivery_charge'] ?? json['delivery_fee']),
      discount: parseNum(json['discount'] ?? json['discount_amount']),
      paymentStatus: json['payment_status']?.toString() ??
          (json['is_paid'] == 1 || json['is_paid'] == true ? 'Paid' : 'Unpaid'),
      paymentMethod: json['payment_method']?.toString() ??
          json['payment_type']?.toString() ??
          'Online',
      date: json['date']?.toString() ??
          json['created_at']?.toString() ??
          json['order_date']?.toString() ??
          '',
      time: json['time']?.toString() ?? '',
      customer: cust,
      items: itemsList,
      cancelReason: json['cancel_reason']?.toString() ??
          json['cancellation_reason']?.toString() ??
          json['reason']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'order_id': orderId,
      'orderId': orderId,
      'product_name': productName,
      'product': productName,
      'quantity': quantity,
      'qty': quantity.toString(),
      'status': status,
      'amount': amount,
      'subtotal': subtotal,
      'delivery_charge': deliveryCharge,
      'discount': discount,
      'payment_status': paymentStatus,
      'payment_method': paymentMethod,
      'date': date,
      'time': time,
      if (customer != null) 'customer': customer!.toJson(),
      'customerName': customer?.name ?? '',
      'phone': customer?.phone ?? '',
      'address': customer?.address ?? '',
      'items': items.map((i) => i.toJson()).toList(),
      if (cancelReason != null) 'reason': cancelReason,
    };
  }
}

class OrdersDataModel {
  final List<OrderModel> orders;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;

  OrdersDataModel({
    required this.orders,
    this.total = 0,
    this.currentPage = 1,
    this.lastPage = 1,
    this.perPage = 10,
  });

  factory OrdersDataModel.fromJson(Map<String, dynamic> json) {
    List<OrderModel> items = [];
    final rawOrders = json['orders'] ?? json['data'] ?? json['order_list'];
    if (rawOrders is List) {
      items = rawOrders
          .whereType<Map>()
          .map((item) => OrderModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    int parseNumInt(dynamic val, [int fallback = 0]) {
      if (val is int) return val;
      if (val is num) return val.toInt();
      if (val is String) return int.tryParse(val) ?? fallback;
      return fallback;
    }

    return OrdersDataModel(
      orders: items,
      total: parseNumInt(json['total'] ?? json['total_orders'], items.length),
      currentPage: parseNumInt(json['current_page'] ?? json['page'], 1),
      lastPage: parseNumInt(json['last_page'] ?? json['total_pages'], 1),
      perPage: parseNumInt(json['per_page'] ?? json['limit'], 10),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orders': orders.map((o) => o.toJson()).toList(),
      'total': total,
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
    };
  }
}

class OrdersResponseModel {
  final bool success;
  final String message;
  final OrdersDataModel? data;
  final int? code;

  OrdersResponseModel({
    required this.success,
    required this.message,
    this.data,
    this.code,
  });

  factory OrdersResponseModel.fromJson(Map<String, dynamic> json) {
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

    OrdersDataModel? dataModel;
    final rawData = json['data'];
    if (rawData is Map) {
      dataModel = OrdersDataModel.fromJson(Map<String, dynamic>.from(rawData));
      isSuccess = true;
    } else if (rawData is List) {
      dataModel = OrdersDataModel.fromJson({'orders': rawData});
      isSuccess = true;
    }

    return OrdersResponseModel(
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
