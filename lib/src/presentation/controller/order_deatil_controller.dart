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

    if (Get.arguments != null) {
      if (Get.arguments is Map) {
        final order = Map<String, dynamic>.from(Get.arguments as Map);
        _populateFromMap(order);
        rawOrderId = order["id"] ?? order["order_id"] ?? order["orderId"];
      } else {
        rawOrderId = Get.arguments;
      }
    }

    if (rawOrderId != null) {
      fetchOrderDetails(rawOrderId);
    }
  }

  void _populateFromMap(Map<String, dynamic> order) {
    orderId.value = (order["orderId"] ?? order["order_id"] ?? order["id"] ?? "").toString();
    if (!orderId.value.startsWith('#') && orderId.value.isNotEmpty) {
      orderId.value = '#${orderId.value}';
    }

    orderStatus.value = (order["status"] ?? "Pending").toString();

    if (order["date"] != null && order["date"].toString().isNotEmpty) {
      date.value = order["date"].toString();
    }
    if (order["time"] != null && order["time"].toString().isNotEmpty) {
      time.value = order["time"].toString();
    }

    if (order["payment_status"] != null) {
      paymentStatus.value = order["payment_status"].toString();
    }
    if (order["payment_method"] != null) {
      paymentMethod.value = order["payment_method"].toString();
    }

    if (order["customerName"] != null && order["customerName"].toString().isNotEmpty) {
      customerName.value = order["customerName"].toString();
    } else if (order["customer"] is Map && order["customer"]["name"] != null) {
      customerName.value = order["customer"]["name"].toString();
    }

    if (order["phone"] != null && order["phone"].toString().isNotEmpty) {
      phone.value = order["phone"].toString();
    } else if (order["customer"] is Map && order["customer"]["phone"] != null) {
      phone.value = order["customer"]["phone"].toString();
    }

    if (order["address"] != null && order["address"].toString().isNotEmpty) {
      address.value = order["address"].toString();
    } else if (order["customer"] is Map && order["customer"]["address"] != null) {
      address.value = order["customer"]["address"].toString();
    }

    if (order["subtotal"] != null) {
      subtotal.value = (order["subtotal"] is num)
          ? (order["subtotal"] as num).toDouble()
          : double.tryParse(order["subtotal"].toString()) ?? 0.0;
    } else if (order["amount"] != null) {
      subtotal.value = (order["amount"] is num)
          ? (order["amount"] as num).toDouble()
          : double.tryParse(order["amount"].toString()) ?? 0.0;
    }

    if (order["delivery_charge"] != null) {
      deliveryCharge.value = (order["delivery_charge"] is num)
          ? (order["delivery_charge"] as num).toDouble()
          : double.tryParse(order["delivery_charge"].toString()) ?? 0.0;
    }

    if (order["discount"] != null) {
      discount.value = (order["discount"] is num)
          ? (order["discount"] as num).toDouble()
          : double.tryParse(order["discount"].toString()) ?? 0.0;
    }

    if (order["items"] is List && (order["items"] as List).isNotEmpty) {
      final rawItems = order["items"] as List;
      items.assignAll(
        rawItems.whereType<Map>().toList().asMap().entries.map((entry) {
          final idx = entry.key;
          final m = Map<String, dynamic>.from(entry.value);
          return {
            ...m,
            "sno": idx + 1,
            "name": m["name"] ?? m["product_name"] ?? "Item",
            "qty": m["qty"] ?? m["quantity"] ?? 1,
            "amount": m["amount"] ?? m["price"] ?? 0,
            "image": m["image"] ?? m["product_image"],
          };
        }).toList(),
      );
    } else if (order["product"] != null) {
      items.assignAll([
        {
          "sno": 1,
          "name": order["product"].toString(),
          "qty": order["qty"] ?? 1,
          "amount": order["amount"] ?? subtotal.value,
          "image": order["image"],
        }
      ]);
    }

    if (orderStatus.value.toLowerCase() == "completed" ||
        orderStatus.value.toLowerCase() == "delivered") {
      deliveryDate.value = (order["date"] ?? "").toString();
    }

    if (orderStatus.value.toLowerCase() == "cancelled" ||
        orderStatus.value.toLowerCase() == "cancel") {
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

  void openMap() {
    Get.snackbar(
      "Map",
      "Open Google Map",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}