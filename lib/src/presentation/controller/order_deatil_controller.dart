import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/di/service_locator.dart';
import '../../core/services/api_services.dart';
import '../../data/models/order_invoice_model.dart';
import '../../data/models/orders_model.dart';
import '../../data/repository/accept_order_repository_impl.dart';
import '../../data/repository/food_ready_repository_impl.dart';
import '../../data/repository/order_detail_repository_impl.dart';
import '../../data/repository/order_invoice_repository_impl.dart';
import '../../data/repository/reject_order_repository_impl.dart';
import '../../domain/usecase/accept_order_usecase.dart';
import '../../domain/usecase/food_ready_usecase.dart';
import '../../domain/usecase/get_order_details_usecase.dart';
import '../../domain/usecase/get_order_invoice_usecase.dart';
import '../../domain/usecase/reject_order_usecase.dart';
import 'package:url_launcher/url_launcher.dart';
import 'order_controller.dart';

class OrderDetailController extends GetxController {
  late final GetOrderDetailsUseCase _getOrderDetailsUseCase;
  late final AcceptOrderUseCase _acceptOrderUseCase;
  late final FoodReadyUseCase _foodReadyUseCase;
  late final RejectOrderUseCase _rejectOrderUseCase;
  late final GetOrderInvoiceUseCase _getOrderInvoiceUseCase;

  dynamic rawOrderId;

  var isLoading = false.obs;
  var isAccepting = false.obs;
  var isMarkingFoodReady = false.obs;
  var isRejecting = false.obs;
  var isDownloadingInvoice = false.obs;
  var errorMessage = RxnString();

  Rx<OrderInvoiceDataModel?> invoiceData = Rx<OrderInvoiceDataModel?>(null);

  RxString orderId = "#1001".obs;
  RxString date = "".obs;
  RxString time = "".obs;

  RxString orderStatus = "Pending".obs;
  RxString paymentStatus = "Paid".obs;
  RxString paymentMethod = "Online".obs;

  RxString customerName = "Customer".obs;
  RxString phone = "".obs;
  RxString address = "".obs;

  RxList<Map<String, dynamic>> items = <Map<String, dynamic>>[].obs;

  RxDouble subtotal = 0.0.obs;
  RxDouble deliveryCharge = 0.0.obs;
  RxDouble discount = 0.0.obs;

  var deliveryDate = "".obs;
  var cancelReason = "".obs;

  bool get isPending {
    final s = orderStatus.value.toLowerCase().trim();
    return s == "pending" || s == "new" || s == "order_pending";
  }

  bool get isAccepted {
    final s = orderStatus.value.toLowerCase().trim();
    return s == "accepted" ||
        s == "order_accepted" ||
        s == "preparing" ||
        s == "in_preparation" ||
        s == "in-progress" ||
        s == "in progress" ||
        s == "processing" ||
        s == "confirmed" ||
        s.contains("accept");
  }

  bool get isFoodReady {
    final s = orderStatus.value.toLowerCase().trim();
    return s == "food ready" ||
        s == "food_ready" ||
        s == "order_ready" ||
        s == "ready" ||
        s == "ready_for_pickup";
  }

  bool get isCompleted {
    final s = orderStatus.value.toLowerCase().trim();
    return s == "completed" ||
        s == "delivered" ||
        s == "order_delivered" ||
        s == "order_completed";
  }

  bool get isCancelled {
    final s = orderStatus.value.toLowerCase().trim();
    return s == "cancelled" ||
        s == "cancel" ||
        s == "rejected" ||
        s == "reject" ||
        s == "order_rejected" ||
        s == "order_cancelled";
  }

  String get formattedStatus {
    final s = orderStatus.value.trim();
    if (isFoodReady) return "Food Ready";
    if (isAccepted) return "Accepted";
    if (isPending) return "Pending";
    if (isCompleted) return "Completed";
    if (isCancelled) return "Cancelled";
    if (s.isEmpty) return "Pending";
    return s[0].toUpperCase() + s.substring(1).replaceAll('_', ' ');
  }

  String get formattedPaymentMethod {
    final method = paymentMethod.value.trim();
    final lower = method.toLowerCase();
    if (lower == 'cash_on_delivery' || lower == 'cod' || lower == 'cash on delivery') {
      return 'Cash on Delivery';
    } else if (lower == 'online') {
      return 'Online';
    } else if (lower == 'card' || lower == 'credit_card' || lower == 'debit_card') {
      return 'Card';
    } else if (lower == 'upi') {
      return 'UPI';
    } else if (lower == 'net_banking' || lower == 'netbanking') {
      return 'Net Banking';
    } else if (lower == 'wallet') {
      return 'Wallet';
    }
    if (lower.isEmpty) return 'Online';
    return method.replaceAll('_', ' ').split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  String get formattedPaymentStatus {
    final s = paymentStatus.value.trim();
    final lower = s.toLowerCase();
    if (lower == 'paid' || lower == '1' || lower == 'true' || lower == 'success') {
      return 'Paid';
    } else if (lower == 'unpaid' || lower == '0' || lower == 'false' || lower == 'pending') {
      return 'Unpaid';
    }
    if (s.isEmpty) return 'Unpaid';
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  bool get isPaid {
    final lower = paymentStatus.value.toLowerCase().trim();
    return lower == 'paid' || lower == '1' || lower == 'true' || lower == 'success';
  }

  @override
  void onInit() {
    super.onInit();
    _getOrderDetailsUseCase = sl.isRegistered<GetOrderDetailsUseCase>()
        ? sl<GetOrderDetailsUseCase>()
        : GetOrderDetailsUseCase(OrderDetailRepositoryImpl(ApiService()));

    _acceptOrderUseCase = sl.isRegistered<AcceptOrderUseCase>()
        ? sl<AcceptOrderUseCase>()
        : AcceptOrderUseCase(AcceptOrderRepositoryImpl(ApiService()));

    _foodReadyUseCase = sl.isRegistered<FoodReadyUseCase>()
        ? sl<FoodReadyUseCase>()
        : FoodReadyUseCase(FoodReadyRepositoryImpl(ApiService()));

    _rejectOrderUseCase = sl.isRegistered<RejectOrderUseCase>()
        ? sl<RejectOrderUseCase>()
        : RejectOrderUseCase(RejectOrderRepositoryImpl(ApiService()));

    _getOrderInvoiceUseCase = sl.isRegistered<GetOrderInvoiceUseCase>()
        ? sl<GetOrderInvoiceUseCase>()
        : GetOrderInvoiceUseCase(OrderInvoiceRepositoryImpl(ApiService()));

    loadOrder(Get.arguments);
  }

  void loadOrder(dynamic args) {
    if (args != null) {
      if (args is Map) {
        final order = Map<String, dynamic>.from(args as Map);
        _populateFromMap(order);
        final orderInfo = order["order_info"] is Map
            ? Map<String, dynamic>.from(order["order_info"])
            : <String, dynamic>{};
        rawOrderId = orderInfo["id"] ??
            orderInfo["order_id"] ??
            order["id"] ??
            order["order_id"] ??
            order["orderId"];
      } else {
        rawOrderId = args;
      }
    }

    if (rawOrderId != null) {
      fetchOrderDetails(rawOrderId);
    }
  }

  void _populateFromMap(Map<String, dynamic> order) {
    final orderInfo = order["order_info"] is Map
        ? Map<String, dynamic>.from(order["order_info"])
        : <String, dynamic>{};
    final custInfo = order["customer_info"] is Map
        ? Map<String, dynamic>.from(order["customer_info"])
        : (order["customer"] is Map
            ? Map<String, dynamic>.from(order["customer"])
            : <String, dynamic>{});
    final totalsMap = order["totals"] is Map
        ? Map<String, dynamic>.from(order["totals"])
        : <String, dynamic>{};

    final rawId = orderInfo["order_id"] ??
        order["orderId"] ??
        order["order_id"] ??
        orderInfo["id"] ??
        order["id"] ??
        "";
    orderId.value = rawId.toString();
    if (!orderId.value.startsWith('#') && orderId.value.isNotEmpty) {
      orderId.value = '#${orderId.value}';
    }

    final rawStatus = orderInfo["status"] ?? order["status"] ?? "Pending";
    orderStatus.value = rawStatus.toString();

    final rawCreatedDate = orderInfo["created_at"] ??
        order["date"] ??
        order["created_at"] ??
        order["order_date"] ??
        "";
    String parsedDate = rawCreatedDate.toString();
    String parsedTime = (orderInfo["time"] ?? order["time"] ?? "").toString();
    if (parsedTime.isEmpty && parsedDate.contains(',')) {
      final parts = parsedDate.split(',');
      if (parts.length >= 2) {
        parsedDate = parts[0].trim();
        parsedTime = parts.sublist(1).join(',').trim();
      }
    }
    date.value = parsedDate;
    time.value = parsedTime;

    final rawPaymentMethod = orderInfo["payment_type"] ??
        orderInfo["payment_method"] ??
        orderInfo["payment_mode"] ??
        order["payment_type"] ??
        order["payment_method"] ??
        order["payment_mode"] ??
        "Online";
    paymentMethod.value = rawPaymentMethod.toString();

    final rawPaymentStatus = orderInfo["payment_status"] ??
        order["payment_status"];
    final isPaidVal = orderInfo["is_paid"] ?? order["is_paid"];
    if (rawPaymentStatus != null && rawPaymentStatus.toString().trim().isNotEmpty) {
      paymentStatus.value = rawPaymentStatus.toString().trim();
    } else if (isPaidVal != null) {
      paymentStatus.value = (isPaidVal == 1 || isPaidVal == true || isPaidVal == '1' || isPaidVal.toString().toLowerCase() == 'paid') ? 'Paid' : 'Unpaid';
    } else {
      final pm = paymentMethod.value.toLowerCase().trim();
      if (pm.contains('cash') || pm.contains('cod')) {
        paymentStatus.value = 'Unpaid';
      } else if (pm.contains('online') || pm.contains('card') || pm.contains('upi') || pm.contains('netbanking') || pm.contains('wallet')) {
        paymentStatus.value = 'Paid';
      } else {
        paymentStatus.value = 'Unpaid';
      }
    }

    if (order["customerName"] != null && order["customerName"].toString().isNotEmpty) {
      customerName.value = order["customerName"].toString();
    } else if (custInfo["name"] != null && custInfo["name"].toString().isNotEmpty) {
      customerName.value = custInfo["name"].toString();
    } else if (order["customer_name"] != null && order["customer_name"].toString().isNotEmpty) {
      customerName.value = order["customer_name"].toString();
    }

    if (order["phone"] != null && order["phone"].toString().isNotEmpty) {
      phone.value = order["phone"].toString();
    } else if (custInfo["phone"] != null && custInfo["phone"].toString().isNotEmpty) {
      phone.value = custInfo["phone"].toString();
    } else if (custInfo["phone_number"] != null && custInfo["phone_number"].toString().isNotEmpty) {
      phone.value = custInfo["phone_number"].toString();
    }

    if (order["address"] != null && order["address"].toString().isNotEmpty) {
      address.value = order["address"].toString();
    } else if (custInfo.isNotEmpty) {
      String addr = custInfo["address"]?.toString() ??
          custInfo["delivery_address"]?.toString() ??
          custInfo["location"]?.toString() ??
          "";
      final landmark = custInfo["landmark"]?.toString()?.trim();
      if (landmark != null && landmark.isNotEmpty && !addr.contains(landmark)) {
        addr += (addr.isNotEmpty ? ', ' : '') + landmark;
      }
      final pincode = custInfo["pincode"]?.toString()?.trim();
      if (pincode != null && pincode.isNotEmpty && !addr.contains(pincode)) {
        addr += (addr.isNotEmpty ? ' - ' : '') + pincode;
      }
      address.value = addr;
    }

    num parseNum(dynamic val, [num fallback = 0]) {
      if (val is num) return val;
      if (val is String) {
        final cleaned = val.replaceAll('₹', '').replaceAll(',', '').trim();
        return num.tryParse(cleaned) ?? fallback;
      }
      return fallback;
    }

    final rawSubtotal = totalsMap["sub_total"] ??
        order["subtotal"] ??
        order["sub_total"] ??
        totalsMap["grand_total"] ??
        order["amount"] ??
        order["total_amount"];
    if (rawSubtotal != null) {
      subtotal.value = parseNum(rawSubtotal).toDouble();
    }

    final rawDelivery = totalsMap["delivery_charge"] ??
        order["delivery_charge"] ??
        order["delivery_fee"];
    if (rawDelivery != null) {
      deliveryCharge.value = parseNum(rawDelivery).toDouble();
    }

    final rawDiscount = totalsMap["discount"] ??
        totalsMap["offer"] ??
        order["discount"] ??
        order["discount_amount"];
    if (rawDiscount != null) {
      discount.value = parseNum(rawDiscount).toDouble();
    }

    final rawItems = order["items"] ?? order["products"] ?? order["order_items"];
    if (rawItems is List && rawItems.isNotEmpty) {
      items.assignAll(
        rawItems.whereType<Map>().toList().asMap().entries.map((entry) {
          final idx = entry.key;
          final m = Map<String, dynamic>.from(entry.value);
          final parsedQty = m["qty"] ?? m["quantity"] ?? 1;
          final parsedAmt = m["total_price"] ?? m["amount"] ?? m["price"] ?? m["sell_price"] ?? 0;
          return {
            ...m,
            "sno": idx + 1,
            "name": m["name"] ?? m["product_name"] ?? "Item",
            "qty": parsedQty is num ? parsedQty.toInt() : (int.tryParse(parsedQty.toString()) ?? 1),
            "amount": parseNum(parsedAmt),
            "image": m["image"] ?? m["product_image"],
          };
        }).toList(),
      );
    } else if (order["product"] != null || order["product_name"] != null) {
      items.assignAll([
        {
          "sno": 1,
          "name": (order["product"] ?? order["product_name"]).toString(),
          "qty": order["qty"] ?? 1,
          "amount": order["amount"] ?? subtotal.value,
          "image": order["image"],
        }
      ]);
    }

    final sLower = orderStatus.value.toLowerCase().trim();
    if (sLower == "completed" || sLower == "delivered" || sLower == "order_delivered" || sLower == "order_completed") {
      deliveryDate.value = (order["date"] ?? date.value).toString();
    }

    if (sLower == "cancelled" || sLower == "cancel" || sLower == "rejected" || sLower == "order_rejected" || sLower == "order_cancelled") {
      cancelReason.value = (order["reason"] ??
          order["cancel_reason"] ??
          "Customer requested cancellation").toString();
    }
  }

  void _populateFromOrderModel(OrderModel order) {
    _populateFromMap(order.toJson());
  }

  Future<void> fetchOrderDetails(dynamic id, {bool isRefresh = false}) async {
    if (id == null) return;
    if (items.isEmpty && !isRefresh) {
      isLoading.value = true;
    }
    errorMessage.value = null;

    try {
      final cleanId = id.toString().replaceAll('#', '').trim();
      final response = await _getOrderDetailsUseCase(cleanId);

      if (response.data != null) {
        if (response.data!.id != null) {
          rawOrderId = response.data!.id;
        }
        _populateFromOrderModel(response.data!);
      }
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint("Error fetching order details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  double get grandTotal =>
      subtotal.value + deliveryCharge.value - discount.value;

  Future<void> acceptOrder() async {
    if (rawOrderId == null && orderId.value.isEmpty) return;

    isAccepting.value = true;
    try {
      final targetId = rawOrderId ?? orderId.value;
      final response = await _acceptOrderUseCase(targetId);

      if (response.success) {
        orderStatus.value = "Accepted";
        Get.snackbar(
          "Success",
          response.message.isNotEmpty
              ? response.message
              : "Order Accepted Successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        if (Get.isRegistered<OrderController>()) {
          Get.find<OrderController>().fetchOrders(isRefresh: true);
        }

        if (rawOrderId != null) {
          fetchOrderDetails(rawOrderId, isRefresh: true);
        }
      } else {
        Get.snackbar(
          "Error",
          response.message.isNotEmpty
              ? response.message
              : "Failed to accept order",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isAccepting.value = false;
    }
  }

  Future<void> markFoodReady() async {
    if (rawOrderId == null && orderId.value.isEmpty) return;

    isMarkingFoodReady.value = true;
    try {
      final targetId = rawOrderId ?? orderId.value;
      final response = await _foodReadyUseCase(targetId);

      if (response.success) {
        orderStatus.value = "Food Ready";
        Get.snackbar(
          "Success",
          response.message.isNotEmpty
              ? response.message
              : "Food marked as ready successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        if (Get.isRegistered<OrderController>()) {
          Get.find<OrderController>().fetchOrders(isRefresh: true);
        }

        if (rawOrderId != null) {
          fetchOrderDetails(rawOrderId, isRefresh: true);
        }
      } else {
        Get.snackbar(
          "Error",
          response.message.isNotEmpty
              ? response.message
              : "Failed to mark food as ready",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isMarkingFoodReady.value = false;
    }
  }

  Future<void> rejectOrder(String reason) async {
    if (rawOrderId == null && orderId.value.isEmpty) return;

    isRejecting.value = true;
    try {
      final targetId = rawOrderId ?? orderId.value;
      final response = await _rejectOrderUseCase(
        orderId: targetId,
        rejectionReason: reason,
      );

      if (response.success) {
        orderStatus.value = "Cancelled";
        cancelReason.value = reason;
        Get.snackbar(
          "Success",
          response.message.isNotEmpty
              ? response.message
              : "Order Rejected Successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        if (Get.isRegistered<OrderController>()) {
          Get.find<OrderController>().fetchOrders(isRefresh: true);
        }

        if (rawOrderId != null) {
          fetchOrderDetails(rawOrderId, isRefresh: true);
        }
      } else {
        Get.snackbar(
          "Error",
          response.message.isNotEmpty
              ? response.message
              : "Failed to reject order",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isRejecting.value = false;
    }
  }

  Future<void> downloadInvoice() async {
    if (rawOrderId == null && orderId.value.isEmpty) return;

    isDownloadingInvoice.value = true;
    try {
      final targetId = rawOrderId ?? orderId.value;
      final response = await _getOrderInvoiceUseCase(targetId);

      if (response.success) {
        invoiceData.value = response.data;
        final invNo = response.data?.invoiceNo.isNotEmpty == true
            ? response.data!.invoiceNo
            : targetId.toString().replaceAll('#', '');
        Get.snackbar(
          "Success",
          response.message.isNotEmpty
              ? response.message
              : "Invoice #$invNo downloaded successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          response.message.isNotEmpty
              ? response.message
              : "Failed to download invoice",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isDownloadingInvoice.value = false;
    }
  }

  Future<void> makeCall([String? customPhone]) async {
    final rawNumber = (customPhone ?? phone.value).trim();
    if (rawNumber.isEmpty) {
      Get.snackbar(
        "Call",
        "Phone number not available for this customer",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final cleanedNumber = rawNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final uri = Uri(scheme: 'tel', path: cleanedNumber);

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        await launchUrl(uri);
      }
    } catch (e) {
      debugPrint("Error launching call: $e");
      Get.snackbar(
        "Call",
        "Please re-run the app build to enable native phone dialer",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade800,
        colorText: Colors.white,
      );
    }
  }

  Future<void> openMap([String? customAddress]) async {
    final targetAddress = (customAddress ?? address.value).trim();
    if (targetAddress.isEmpty) {
      Get.snackbar(
        "Map",
        "Address not available for this order",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final query = Uri.encodeComponent(targetAddress);
    final googleMapsUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");

    try {
      final launched = await launchUrl(
        googleMapsUrl,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        await launchUrl(googleMapsUrl);
      }
    } catch (e) {
      debugPrint("Error opening map: $e");
      Get.snackbar(
        "Map",
        "Unable to open map for $targetAddress",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}