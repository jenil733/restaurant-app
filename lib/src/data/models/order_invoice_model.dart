import 'orders_model.dart';

class InvoiceItemModel {
  final dynamic id;
  final String name;
  final int quantity;
  final num price;
  final num total;

  InvoiceItemModel({
    this.id,
    required this.name,
    this.quantity = 1,
    this.price = 0,
    this.total = 0,
  });

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic val) {
      if (val is int) return val;
      if (val is num) return val.toInt();
      if (val is String) return int.tryParse(val) ?? 1;
      return 1;
    }

    num parseNum(dynamic val) {
      if (val is num) return val;
      if (val is String) {
        final cleaned = val.replaceAll('₹', '').replaceAll(',', '').trim();
        return num.tryParse(cleaned) ?? 0;
      }
      return 0;
    }

    final qty = parseInt(json['quantity'] ?? json['qty'] ?? json['count']);
    final pr = parseNum(
      json['price'] ?? json['amount'] ?? json['rate'] ?? json['unit_price'],
    );
    final tot = parseNum(json['total'] ?? json['total_price'] ?? (qty * pr));

    return InvoiceItemModel(
      id: json['id'] ?? json['item_id'] ?? json['product_id'],
      name: (json['name'] ??
              json['product_name'] ??
              json['item_name'] ??
              'Item')
          .toString(),
      quantity: qty,
      price: pr,
      total: tot,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'total': total,
    };
  }
}

class OrderInvoiceDataModel {
  final dynamic id;
  final String invoiceNo;
  final String orderId;
  final String date;
  final String time;
  final String? invoiceUrl;
  final String? pdfUrl;
  final String? downloadUrl;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String restaurantName;
  final String restaurantAddress;
  final String restaurantPhone;
  final String? gstNo;
  final List<InvoiceItemModel> items;
  final num subtotal;
  final num tax;
  final num deliveryCharge;
  final num discount;
  final num grandTotal;
  final String paymentStatus;
  final String paymentMethod;
  final String orderStatus;

  OrderInvoiceDataModel({
    this.id,
    required this.invoiceNo,
    required this.orderId,
    this.date = '',
    this.time = '',
    this.invoiceUrl,
    this.pdfUrl,
    this.downloadUrl,
    this.customerName = '',
    this.customerPhone = '',
    this.customerAddress = '',
    this.restaurantName = '',
    this.restaurantAddress = '',
    this.restaurantPhone = '',
    this.gstNo,
    this.items = const [],
    this.subtotal = 0,
    this.tax = 0,
    this.deliveryCharge = 0,
    this.discount = 0,
    this.grandTotal = 0,
    this.paymentStatus = 'Paid',
    this.paymentMethod = 'Online',
    this.orderStatus = 'Completed',
  });

  factory OrderInvoiceDataModel.fromJson(Map<String, dynamic> json) {
    num parseNum(dynamic val, [num fallback = 0]) {
      if (val is num) return val;
      if (val is String) {
        final cleaned = val.replaceAll('₹', '').replaceAll(',', '').trim();
        return num.tryParse(cleaned) ?? fallback;
      }
      return fallback;
    }

    List<InvoiceItemModel> itemsList = [];
    final rawItems = json['items'] ?? json['products'] ?? json['order_items'];
    if (rawItems is List) {
      itemsList = rawItems
          .whereType<Map>()
          .map((e) => InvoiceItemModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    String custName = json['customer_name']?.toString() ?? '';
    String custPhone = json['customer_phone']?.toString() ??
        json['phone']?.toString() ??
        '';
    String custAddr = json['customer_address']?.toString() ??
        json['delivery_address']?.toString() ??
        json['address']?.toString() ??
        '';

    if (json['customer'] is Map) {
      final cust = json['customer'] as Map;
      if (custName.isEmpty) custName = cust['name']?.toString() ?? '';
      if (custPhone.isEmpty) custPhone = cust['phone']?.toString() ?? '';
      if (custAddr.isEmpty) custAddr = cust['address']?.toString() ?? '';
    }

    String restName = json['restaurant_name']?.toString() ?? '';
    String restPhone = json['restaurant_phone']?.toString() ?? '';
    String restAddr = json['restaurant_address']?.toString() ?? '';

    if (json['restaurant'] is Map) {
      final rest = json['restaurant'] as Map;
      if (restName.isEmpty) restName = rest['name']?.toString() ?? '';
      if (restPhone.isEmpty) restPhone = rest['phone']?.toString() ?? '';
      if (restAddr.isEmpty) restAddr = rest['address']?.toString() ?? '';
    }

    final rawGrandTotal = json['grand_total'] ??
        json['total_amount'] ??
        json['total'] ??
        json['amount'];

    final rawSubtotal = json['subtotal'] ?? json['sub_total'] ?? rawGrandTotal;

    return OrderInvoiceDataModel(
      id: json['id'] ?? json['invoice_id'],
      invoiceNo: (json['invoice_no'] ??
              json['invoice_number'] ??
              json['invoice_id'] ??
              json['id'] ??
              '')
          .toString(),
      orderId: (json['order_id'] ?? json['order_number'] ?? json['id'] ?? '')
          .toString(),
      date: (json['date'] ??
              json['invoice_date'] ??
              json['created_at'] ??
              json['order_date'] ??
              '')
          .toString(),
      time: (json['time'] ?? '').toString(),
      invoiceUrl: (json['invoice_url'] ??
              json['pdf_url'] ??
              json['download_url'] ??
              json['url'] ??
              json['file_url'])
          ?.toString(),
      pdfUrl: json['pdf_url']?.toString(),
      downloadUrl: (json['download_url'] ?? json['invoice_url'])?.toString(),
      customerName: custName,
      customerPhone: custPhone,
      customerAddress: custAddr,
      restaurantName: restName,
      restaurantAddress: restAddr,
      restaurantPhone: restPhone,
      gstNo: json['gst_no']?.toString() ?? json['gstin']?.toString(),
      items: itemsList,
      subtotal: parseNum(rawSubtotal),
      tax: parseNum(json['tax'] ?? json['tax_amount'] ?? json['gst']),
      deliveryCharge: parseNum(json['delivery_charge'] ?? json['delivery_fee']),
      discount: parseNum(json['discount'] ?? json['discount_amount']),
      grandTotal: parseNum(rawGrandTotal),
      paymentStatus: (json['payment_status'] ?? 'Paid').toString(),
      paymentMethod: (json['payment_method'] ?? 'Online').toString(),
      orderStatus: (json['order_status'] ?? json['status'] ?? 'Completed')
          .toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'invoice_no': invoiceNo,
      'order_id': orderId,
      'date': date,
      'time': time,
      if (invoiceUrl != null) 'invoice_url': invoiceUrl,
      if (pdfUrl != null) 'pdf_url': pdfUrl,
      if (downloadUrl != null) 'download_url': downloadUrl,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'customer_address': customerAddress,
      'restaurant_name': restaurantName,
      'restaurant_address': restaurantAddress,
      'restaurant_phone': restaurantPhone,
      if (gstNo != null) 'gst_no': gstNo,
      'items': items.map((e) => e.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'delivery_charge': deliveryCharge,
      'discount': discount,
      'grand_total': grandTotal,
      'payment_status': paymentStatus,
      'payment_method': paymentMethod,
      'order_status': orderStatus,
    };
  }
}

class OrderInvoiceResponseModel {
  final bool success;
  final String message;
  final OrderInvoiceDataModel? data;
  final int? code;

  OrderInvoiceResponseModel({
    required this.success,
    required this.message,
    this.data,
    this.code,
  });

  factory OrderInvoiceResponseModel.fromJson(Map<String, dynamic> json) {
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

    OrderInvoiceDataModel? dataModel;
    final rawData = json['data'] ?? json['invoice'] ?? json['order'];
    if (rawData is Map) {
      dataModel =
          OrderInvoiceDataModel.fromJson(Map<String, dynamic>.from(rawData));
      isSuccess = true;
    } else if (rawData is String && rawData.isNotEmpty) {
      // Sometimes the API directly returns a pdf URL string
      dataModel = OrderInvoiceDataModel(
        invoiceNo: '',
        orderId: '',
        invoiceUrl: rawData,
        downloadUrl: rawData,
      );
      isSuccess = true;
    } else if (json['invoice_url'] != null || json['pdf_url'] != null) {
      dataModel = OrderInvoiceDataModel.fromJson(json);
      isSuccess = true;
    }

    return OrderInvoiceResponseModel(
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
