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
    final rawPrice = json['sell_price'] ??
        json['total_price'] ??
        json['price'] ??
        json['amount'] ??
        json['rate'] ??
        json['unit_price'] ??
        json['mrp'];
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
    String addr = json['address']?.toString() ??
        json['delivery_address']?.toString() ??
        json['location']?.toString() ??
        '';
    final landmark = json['landmark']?.toString()?.trim();
    if (landmark != null && landmark.isNotEmpty && !addr.contains(landmark)) {
      addr += (addr.isNotEmpty ? ', ' : '') + landmark;
    }
    final pincode = json['pincode']?.toString()?.trim();
    if (pincode != null && pincode.isNotEmpty && !addr.contains(pincode)) {
      addr += (addr.isNotEmpty ? ' - ' : '') + pincode;
    }

    return CustomerInfoModel(
      name: json['name']?.toString() ??
          json['customer_name']?.toString() ??
          json['user_name']?.toString() ??
          'Customer',
      phone: json['phone']?.toString() ??
          json['phone_number']?.toString() ??
          json['mobile']?.toString() ??
          '',
      address: addr,
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

    final orderInfo = json['order_info'] is Map
        ? Map<String, dynamic>.from(json['order_info'])
        : <String, dynamic>{};
    final custInfo = json['customer_info'] is Map
        ? Map<String, dynamic>.from(json['customer_info'])
        : (json['customer'] is Map
            ? Map<String, dynamic>.from(json['customer'])
            : <String, dynamic>{});
    final totalsMap = json['totals'] is Map
        ? Map<String, dynamic>.from(json['totals'])
        : <String, dynamic>{};

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
    if (custInfo.isNotEmpty) {
      cust = CustomerInfoModel.fromJson(custInfo);
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

    final rawAmount = totalsMap['grand_total'] ??
        json['total_amount'] ??
        json['amount'] ??
        json['total'] ??
        json['price'] ??
        json['grand_total'];

    final rawSubtotal = totalsMap['sub_total'] ??
        json['subtotal'] ??
        json['sub_total'] ??
        rawAmount;

    final rawDiscount = totalsMap['discount'] ??
        totalsMap['offer'] ??
        json['discount'] ??
        json['discount_amount'] ??
        0;

    final rawDelivery = totalsMap['delivery_charge'] ??
        json['delivery_charge'] ??
        json['delivery_fee'] ??
        0;

    final idVal = orderInfo['id'] ?? json['id'] ?? json['order_id'];
    final rawOrderIdStr = orderInfo['order_id'] ??
        json['order_id'] ??
        json['order_number'] ??
        (idVal != null ? '#$idVal' : '#1001');

    final rawStatus = orderInfo['status'] ?? json['status'] ?? 'Pending';
    final rawPaymentMethod = orderInfo['payment_type'] ??
        orderInfo['payment_method'] ??
        orderInfo['payment_mode'] ??
        json['payment_method'] ??
        json['payment_type'] ??
        json['payment_mode'] ??
        'Online';

    String resolvedPaymentStatus = 'Unpaid';
    final rawPaymentStatus = orderInfo['payment_status'] ?? json['payment_status'];
    final isPaidVal = orderInfo['is_paid'] ?? json['is_paid'];

    if (rawPaymentStatus != null && rawPaymentStatus.toString().trim().isNotEmpty) {
      resolvedPaymentStatus = rawPaymentStatus.toString().trim();
    } else if (isPaidVal != null) {
      resolvedPaymentStatus = (isPaidVal == 1 || isPaidVal == true || isPaidVal == '1' || isPaidVal.toString().toLowerCase() == 'paid') ? 'Paid' : 'Unpaid';
    } else {
      final pm = rawPaymentMethod.toString().toLowerCase().trim();
      if (pm.contains('cash') || pm.contains('cod')) {
        resolvedPaymentStatus = 'Unpaid';
      } else if (pm.contains('online') || pm.contains('card') || pm.contains('upi') || pm.contains('netbanking') || pm.contains('wallet')) {
        resolvedPaymentStatus = 'Paid';
      } else {
        resolvedPaymentStatus = 'Unpaid';
      }
    }

    final rawCreatedDate = orderInfo['created_at'] ??
        json['date'] ??
        json['created_at'] ??
        json['order_date'] ??
        '';

    String parsedDate = rawCreatedDate.toString();
    String parsedTime = (orderInfo['time'] ?? json['time'] ?? '').toString();

    if (parsedTime.isEmpty && parsedDate.contains(',')) {
      final parts = parsedDate.split(',');
      if (parts.length >= 2) {
        parsedDate = parts[0].trim();
        parsedTime = parts.sublist(1).join(',').trim();
      }
    }

    return OrderModel(
      id: idVal,
      orderId: rawOrderIdStr.toString(),
      productName: mainProduct,
      quantity: totalQty,
      status: rawStatus.toString(),
      amount: parseNum(rawAmount),
      subtotal: parseNum(rawSubtotal),
      deliveryCharge: parseNum(rawDelivery),
      discount: parseNum(rawDiscount),
      paymentStatus: resolvedPaymentStatus,
      paymentMethod: rawPaymentMethod.toString(),
      date: parsedDate,
      time: parsedTime,
      customer: cust,
      items: itemsList,
      cancelReason: json['cancel_reason']?.toString() ??
          json['cancellation_reason']?.toString() ??
          json['reason']?.toString() ??
          orderInfo['cancel_reason']?.toString() ??
          orderInfo['reason']?.toString(),
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
      'payment_type': paymentMethod,
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
