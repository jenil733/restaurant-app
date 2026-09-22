import 'package:flutter/material.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/utils/helper/texthelper.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/presentation/controller/home_controller.dart';
import 'package:restaurant_app/src/presentation/view/home/widgets/home_header_section.dart';
import 'package:restaurant_app/src/presentation/view/home/widgets/overview_cards.dart';
import 'package:restaurant_app/src/presentation/view/home/widgets/recent_orders_table.dart';
import 'package:restaurant_app/src/presentation/view/home/widgets/store_verification_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final statusBarHeight = MediaQuery.paddingOf(context).top;

    return RefreshIndicator(
      onRefresh: controller.refreshDashboard,
      color: AppColors.primary,
      child: CustomScrollView(
        key: const Key('home-dashboard-scroll'),
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: HomeHeaderSection(statusBarHeight: statusBarHeight),
          ),
          SliverToBoxAdapter(
            child: Obx(() {
              if (controller.isLoadingDashboard.value && !controller.hasLoadedDashboard.value) {
                return const Padding(
                  padding: EdgeInsets.fromLTRB(20, 80, 20, 40),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2.5,
                    ),
                  ),
                );
              }

              if (!controller.isApproved.value) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 68, 20, 16),
                  child: Column(
                    children: [
                      if (controller.isRejected.value)
                        RejectionNoteCard(
                          reason: controller.rejectionReason.value,
                          docName: controller.rejectedDocument.value,
                        ),
                      const StoreVerificationCard(),
                    ],
                  ),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.fromLTRB(20, 48, 20, 16),
                  child: OverviewCards(),
                );
              }
            }),
          ),
          SliverToBoxAdapter(
            child: Obx(() {
              if (!controller.isApproved.value) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Text(
                  'Recent Orders',
                  style: TextHelper.heading2.copyWith(
                    color: AppColors.textprimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }),
          ),
          SliverToBoxAdapter(
            child: Obx(() {
              if (!controller.isApproved.value) return const SizedBox.shrink();
              return const Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: RecentOrdersTable(),
              );
            }),
          ),
        ],
      ),
    );
  }
}
