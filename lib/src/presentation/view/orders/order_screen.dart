import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/presentation/controller/home_controller.dart';
import 'package:restaurant_app/src/presentation/controller/order_controller.dart';
import 'package:restaurant_app/src/presentation/widgets/app_bar.dart';

/// ---------- Shared colors ----------
class OrderTheme {
  OrderTheme._();

  static const Color orange = Color(0xFFF37021);
  static const Color headerPeach = Color(0xFFFFF2E5);
  static const Color rowPeach = Color(0xFFFFF9F3);
  static const Color background = Color(0xFFFBF3EA);
}

class OrdersScreen extends StatelessWidget {
  OrdersScreen({super.key});

  final OrderController controller = Get.isRegistered<OrderController>()
      ? Get.find<OrderController>()
      : Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: "Orders",
        onBackPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else if (Get.isRegistered<HomeController>()) {
            Get.find<HomeController>().changeTab(0);
          }
        },
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchOrders(isRefresh: true),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTabBar(),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildToolbar(),
                    const SizedBox(height: 12),
                    _buildTable(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------- Tabs (New / Completed / Cancel) ----------
  Widget _buildTabBar() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          controller.tabs.length,
          (index) => Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: index == controller.tabs.length - 1 ? 0 : 10),
              child: GestureDetector(
                onTap: () => controller.changeTab(index),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: controller.selectedTab.value == index
                        ? OrderTheme.orange
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: controller.selectedTab.value == index
                          ? OrderTheme.orange
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        "${controller.tabs[index]} (${controller.tabCounts[index]})",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: controller.selectedTab.value == index
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ---------- Show entries dropdown + Search ----------
  Widget _buildToolbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Show", style: TextStyle(color: Colors.grey)),
            const SizedBox(width: 8),
            Obx(
              () => SizedBox(
                width: 68,
                height: 35,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      isExpanded: true,
                      isDense: true,
                      value: controller.entriesPerPage.value,
                      items: const [10, 25, 50, 100]
                          .map((e) => DropdownMenuItem(value: e, child: Text("$e")))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) controller.changeEntriesPerPage(v);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 130,
              height: 38,
              child: TextField(
                onChanged: controller.onSearchChanged,
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: const TextStyle(fontSize: 13),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// ---------- Table: header row + scrollable data rows ----------
  Widget _buildTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: OrderTheme.headerPeach,
            border: Border(
              top: BorderSide(color: Color(0xFFF0E5D8)),
              bottom: BorderSide(color: Color(0xFFF0E5D8)),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
          child: Obx(() {
            final isNew = controller.selectedTab.value == 0;
            return Row(
              children: isNew
                  ? [
                      const Expanded(flex: 1, child: _HeaderCell("Sno")),
                      _verticalDivider(),
                      const Expanded(flex: 2, child: _HeaderCell("Order ID")),
                      _verticalDivider(),
                      const Expanded(flex: 2, child: _HeaderCell("Product")),
                      _verticalDivider(),
                      const Expanded(flex: 1, child: _HeaderCell("Qty")),
                      _verticalDivider(),
                      const Expanded(flex: 2, child: _HeaderCell("View")),
                      _verticalDivider(),
                      const Expanded(flex: 2, child: _HeaderCell("Status")),
                    ]
                  : [
                      const Expanded(flex: 1, child: _HeaderCell("Sno")),
                      _verticalDivider(),
                      const Expanded(flex: 2, child: _HeaderCell("Date")),
                      _verticalDivider(),
                      const Expanded(flex: 2, child: _HeaderCell("Order ID")),
                      _verticalDivider(),
                      const Expanded(flex: 2, child: _HeaderCell("Product")),
                      _verticalDivider(),
                      const Expanded(flex: 1, child: _HeaderCell("Qty")),
                      _verticalDivider(),
                      const Expanded(flex: 2, child: _HeaderCell("View")),
                    ],
            );
          }),
        ),
        Obx(() {
          if (controller.isLoading.value && controller.orders.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: CircularProgressIndicator(
                  color: OrderTheme.orange,
                ),
              ),
            );
          }

          if (controller.errorMessage.value != null && controller.orders.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      controller.errorMessage.value!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => controller.fetchOrders(isRefresh: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: OrderTheme.orange,
                      ),
                      child: const Text("Retry", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          }

          final list = controller.filteredOrders;

          if (list.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text(
                  "No orders found",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final order = list[index];
              final isNew = controller.selectedTab.value == 0;

              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Color(0xFFF0E5D8))),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 0),
                child: Row(
                  children: isNew
                      ? [
                          Expanded(flex: 1, child: Center(child: Text("${order["sno"]}", style: const TextStyle(fontSize: 13, color: Color(0xFF4A4A4A))))),
                          Expanded(flex: 2, child: Center(child: Text(order["orderId"] ?? "", style: const TextStyle(fontSize: 13, color: Color(0xFF4A4A4A))))),
                          Expanded(flex: 2, child: Center(child: Text(order["product"]?.replaceAll(' ', '\n') ?? "", textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Color(0xFF4A4A4A), height: 1.2)))),
                          Expanded(flex: 1, child: Center(child: Text("${order["qty"]}", style: const TextStyle(fontSize: 13, color: Color(0xFF4A4A4A))))),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: GestureDetector(
                                onTap: () => controller.onView(index),
                                child: const Text(
                                  "View",
                                  style: TextStyle(
                                    color: Color(0xFF22C55E),
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color(0xFF22C55E),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: OrderTheme.orange,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  order["status"] ?? "",
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        ]
                      : [
                          Expanded(flex: 1, child: Center(child: Text("${order["sno"]}", style: const TextStyle(fontSize: 13, color: Color(0xFF4A4A4A))))),
                          Expanded(flex: 2, child: Center(child: Text(order["date"] ?? "", style: const TextStyle(fontSize: 13, color: Color(0xFF4A4A4A))))),
                          Expanded(flex: 2, child: Center(child: Text(order["orderId"] ?? "", style: const TextStyle(fontSize: 13, color: Color(0xFF4A4A4A))))),
                          Expanded(flex: 2, child: Center(child: Text(order["product"]?.replaceAll(' ', '\n') ?? "", textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Color(0xFF4A4A4A), height: 1.2)))),
                          Expanded(flex: 1, child: Center(child: Text("${order["qty"]}", style: const TextStyle(fontSize: 13, color: Color(0xFF4A4A4A))))),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: GestureDetector(
                                onTap: () => controller.onView(index),
                                child: const Text(
                                  "View",
                                  style: TextStyle(
                                    color: Color(0xFF22C55E),
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color(0xFF22C55E),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                ),
              );
            },
          );
        }),
        const SizedBox(height: 16),
        _buildPagination(),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(
      width: 1,
      height: 14,
      color: Colors.grey.shade300,
    );
  }

  /// ---------- Pagination footer ----------
  Widget _buildPagination() {
    return Obx(
      () => Wrap(
        alignment: WrapAlignment.spaceBetween,
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: [
          Text(
            "Showing ${controller.showingFrom} to "
            "${controller.showingTo} of "
            "${controller.totalEntries} entries",
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PageIconButton(
                icon: Icons.first_page,
                onTap: controller.goToFirstPage,
                isDisabled: controller.currentPage.value == 1,
              ),
              _PageIconButton(
                icon: Icons.chevron_left,
                onTap: controller.goToPreviousPage,
                isDisabled: controller.currentPage.value == 1,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: OrderTheme.orange,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "${controller.currentPage.value}",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              _PageIconButton(
                icon: Icons.chevron_right,
                onTap: controller.goToNextPage,
                isDisabled: controller.currentPage.value >= controller.totalPages,
              ),
              _PageIconButton(
                icon: Icons.last_page,
                onTap: controller.goToLastPage,
                isDisabled: controller.currentPage.value >= controller.totalPages,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;

  const _HeaderCell(this.label);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: Color(0xFF4A4A4A),
        ),
      ),
    );
  }
}

class _PageIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDisabled;
  const _PageIconButton({required this.icon, required this.onTap, this.isDisabled = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDisabled ? null : onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 28,
        height: 28,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isDisabled ? Colors.grey.shade100 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 15,
          color: isDisabled
              ? Colors.grey.shade400
              : Colors.black87,
        ),
      ),
    );
  }
}