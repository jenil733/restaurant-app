import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/di/service_locator.dart';
import '../../core/services/api_services.dart';
import '../../data/models/orders_model.dart';
import '../../data/repository/order_repository_impl.dart';
import '../../domain/usecase/get_orders_usecase.dart';
import '../view/orders/order_detail_screen.dart';

class OrderController extends GetxController {
  late final GetOrdersUseCase _getOrdersUseCase;

  var selectedTab = 0.obs;
  var searchQuery = ''.obs;
  var entriesPerPage = 10.obs;
  var currentPage = 1.obs;

  var isLoading = false.obs;
  var errorMessage = RxnString();

  /// Tab labels shown in the UI
  final List<String> tabs = ["New", "Completed", "Cancel"];
  
  /// Status parameter mapping for each tab
  final List<String> _tabStatuses = ["pending", "completed", "cancelled"];

  RxList<OrderModel> orders = <OrderModel>[].obs;
  var serverTotal = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _getOrdersUseCase = sl.isRegistered<GetOrdersUseCase>()
        ? sl<GetOrdersUseCase>()
        : GetOrdersUseCase(OrderRepositoryImpl(ApiService()));

    fetchOrders();
  }

  Future<void> fetchOrders({bool isRefresh = false}) async {
    if (!isRefresh && orders.isNotEmpty) {
      // Refresh silently or keep previous data
    } else {
      isLoading.value = true;
    }
    errorMessage.value = null;

    try {
      final currentStatus = _tabStatuses[selectedTab.value];
      final response = await _getOrdersUseCase(
        status: currentStatus,
        page: currentPage.value,
        limit: entriesPerPage.value,
        search: searchQuery.value.trim().isNotEmpty ? searchQuery.value.trim() : null,
      );

      if (response.data != null) {
        orders.assignAll(response.data!.orders);
        serverTotal.value = response.data!.total;
      } else {
        orders.clear();
        serverTotal.value = 0;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint("Error fetching orders: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Count of orders per tab
  List<int> get tabCounts {
    final currentStatus = _tabStatuses[selectedTab.value];
    final matchCount = orders.where((e) => e.status.toLowerCase().trim() == currentStatus).length;
    return List.generate(tabs.length, (i) {
      if (i == selectedTab.value) {
        return serverTotal.value > 0 ? serverTotal.value : matchCount;
      }
      return 0;
    });
  }

  void changeTab(int index) {
    if (selectedTab.value == index) return;
    selectedTab.value = index;
    currentPage.value = 1;
    fetchOrders(isRefresh: true);
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    currentPage.value = 1;
    fetchOrders(isRefresh: true);
  }

  void changeEntriesPerPage(int value) {
    entriesPerPage.value = value;
    currentPage.value = 1;
    fetchOrders(isRefresh: true);
  }

  /// Orders for the active tab + search text
  List<OrderModel> get _tabAndSearchFiltered {
    final status = _tabStatuses[selectedTab.value];
    var list = orders.where((e) {
      final s = e.status.toLowerCase().trim();
      if (status == "pending") {
        return s == "pending" || s == "new";
      } else if (status == "completed") {
        return s == "completed" || s == "delivered";
      } else if (status == "cancelled") {
        return s == "cancelled" || s == "cancel" || s == "rejected";
      }
      return s == status;
    }).toList();

    final q = searchQuery.value.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((e) {
        final orderId = e.orderId.toLowerCase();
        final product = e.productName.toLowerCase();
        return orderId.contains(q) || product.contains(q);
      }).toList();
    }
    return list;
  }

  int get totalEntries => serverTotal.value > 0 ? serverTotal.value : _tabAndSearchFiltered.length;

  int get totalPages {
    final total = totalEntries;
    return total == 0 ? 1 : (total / entriesPerPage.value).ceil();
  }

  int get showingFrom =>
      totalEntries == 0 ? 0 : ((currentPage.value - 1) * entriesPerPage.value) + 1;

  int get showingTo =>
      ((currentPage.value) * entriesPerPage.value).clamp(0, totalEntries);

  /// Final list rendered in the table
  List<Map<String, dynamic>> get filteredOrders {
    final list = _tabAndSearchFiltered.isNotEmpty ? _tabAndSearchFiltered : orders.toList();
    final start = (currentPage.value - 1) * entriesPerPage.value;

    return List.generate(
      list.length,
      (i) {
        final item = list[i];
        return {
          ...item.toJson(),
          "sno": start + i + 1,
          "orderId": item.orderId,
          "product": item.productName,
          "qty": item.quantity.toString(),
          "status": item.status,
          "date": item.date,
          "amount": item.amount,
        };
      },
    );
  }

  void goToFirstPage() {
    if (currentPage.value != 1) {
      currentPage.value = 1;
      fetchOrders(isRefresh: true);
    }
  }

  void goToPreviousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchOrders(isRefresh: true);
    }
  }

  void goToNextPage() {
    if (currentPage.value < totalPages) {
      currentPage.value++;
      fetchOrders(isRefresh: true);
    }
  }

  void goToLastPage() {
    if (currentPage.value != totalPages) {
      currentPage.value = totalPages;
      fetchOrders(isRefresh: true);
    }
  }

  void onView(int index) {
    if (index >= 0 && index < filteredOrders.length) {
      final order = filteredOrders[index];
      Get.to(
        () => OrderDetailScreen(),
        arguments: order,
      );
    }
  }
}