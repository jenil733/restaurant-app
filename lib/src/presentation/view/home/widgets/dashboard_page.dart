import 'package:flutter/material.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/utils/helper/texthelper.dart';
import 'package:restaurant_app/src/presentation/view/home/widgets/home_header_section.dart';
import 'package:restaurant_app/src/presentation/view/home/widgets/overview_cards.dart';
import 'package:restaurant_app/src/presentation/view/home/widgets/recent_orders_table.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.paddingOf(context).top;

    return CustomScrollView(
      key: const Key('home-dashboard-scroll'),
      slivers: [
        SliverToBoxAdapter(
          child: HomeHeaderSection(statusBarHeight: statusBarHeight),
        ),
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(20, 68, 20, 16),
          sliver: SliverToBoxAdapter(child: OverviewCards()),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          sliver: SliverToBoxAdapter(
            child: Text(
              'Recent Orders',
              style: TextHelper.heading2.copyWith(
                color: AppColors.textprimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 24),
          sliver: SliverToBoxAdapter(child: RecentOrdersTable()),
        ),
      ],
    );
  }
}
