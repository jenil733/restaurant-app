import 'package:get/get.dart';
import 'package:restaurant_app/src/presentation/view/orders/order_detail_screen.dart';
class OrderController extends GetxController {
  var selectedTab = 0.obs;
  var searchQuery = ''.obs;
  var entriesPerPage = 10.obs;
  var currentPage = 1.obs;

  /// Tab labels shown in the UI (counts are computed, not hard-coded)
  final List<String> tabs = ["New", "Completed", "Cancel"];
  
  /// Status value each tab maps to
  final List<String> _tabStatuses = ["Pending", "Completed", "Cancel"];
  

  
  final orders = <Map<String, dynamic>>[
    // Pending (New)
    {"orderId": "#1001", "product": "Chicken Biriyani", "qty": "2", "status": "Pending"},
    {"orderId": "#1002", "product": "Chicken Biriyani", "qty": "1", "status": "Pending"},
    {"orderId": "#1003", "product": "Chicken Biriyani", "qty": "3", "status": "Pending"},
    {"orderId": "#1004", "product": "Chicken Biriyani", "qty": "2", "status": "Pending"},
    // Completed
    {"orderId": "#1001", "product": "Chicken Biriyani", "qty": "2", "status": "Completed", "date": "12/02/25"},
    {"orderId": "#1002", "product": "Chicken Biriyani", "qty": "1", "status": "Completed", "date": "12/02/25"},
    {"orderId": "#1003", "product": "Chicken Biriyani", "qty": "3", "status": "Completed", "date": "12/02/25"},
    {"orderId": "#1004", "product": "Chicken Biriyani", "qty": "2", "status": "Completed", "date": "12/02/25"},
    {"orderId": "#1005", "product": "Chicken Biriyani", "qty": "2", "status": "Completed", "date": "12/02/25"},
    // Cancel
    {"orderId": "#1001", "product": "Chicken Biriyani", "qty": "2", "status": "Cancel", "date": "12/02/25"},
    {"orderId": "#1002", "product": "Chicken Biriyani", "qty": "1", "status": "Cancel", "date": "12/02/25"},
    {"orderId": "#1003", "product": "Chicken Biriyani", "qty": "3", "status": "Cancel", "date": "12/02/25"},
    {"orderId": "#1004", "product": "Chicken Biriyani", "qty": "2", "status": "Cancel", "date": "12/02/25"},
    {"orderId": "#1005", "product": "Chicken Biriyani", "qty": "2", "status": "Cancel", "date": "12/02/25"},
  ].obs;
  


  /// Count of orders per tab, e.g. [4, 5, 5] -> shown as "New (4)"
  List<int> get tabCounts =>
      _tabStatuses.map((s) => orders.where((e) => e["status"] == s).length).toList();

  void changeTab(int index) {
    selectedTab.value = index;
    currentPage.value = 1;
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    currentPage.value = 1;
  }

  void changeEntriesPerPage(int value) {
    entriesPerPage.value = value;
    currentPage.value = 1;
  }

  /// Orders for the active tab + search text, before pagination is applied
  List<Map<String, dynamic>> get _tabAndSearchFiltered {
    final status = _tabStatuses[selectedTab.value];
    var list = orders.where((e) => e["status"] == status).toList();

    final q = searchQuery.value.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((e) {
        final orderId = (e["orderId"] ?? "").toString().toLowerCase();
        final product = (e["product"] ?? "").toString().toLowerCase();
        return orderId.contains(q) || product.contains(q);
      }).toList();
    }
    return list;
  }

  int get totalEntries => _tabAndSearchFiltered.length;

  int get totalPages =>
      totalEntries == 0 ? 1 : (totalEntries / entriesPerPage.value).ceil();

  int get showingFrom =>
      totalEntries == 0 ? 0 : ((currentPage.value - 1) * entriesPerPage.value) + 1;

  int get showingTo =>
      ((currentPage.value) * entriesPerPage.value).clamp(0, totalEntries);

  /// Final list rendered in the table: tab + search filtered, paginated,
  /// with a running "sno" (serial number) attached to each row.
  List<Map<String, dynamic>> get filteredOrders {
    final list = _tabAndSearchFiltered;
    final start = (currentPage.value - 1) * entriesPerPage.value;
    if (start >= list.length) return [];

    final end = (start + entriesPerPage.value).clamp(0, list.length);
    final page = list.sublist(start, end);

    return List.generate(
      page.length,
      (i) => {
        ...page[i],
        "sno": start + i + 1,
      },
    );
  }

  void goToFirstPage() => currentPage.value = 1;

  void goToPreviousPage() {
    if (currentPage.value > 1) currentPage.value--;
  }

  void goToNextPage() {
    if (currentPage.value < totalPages) currentPage.value++;
  }

  void goToLastPage() => currentPage.value = totalPages;

  void onView(int index) {
  final order = filteredOrders[index];

  Get.to(
    () => OrderDetailScreen(),
    arguments: order,
  );
}

}