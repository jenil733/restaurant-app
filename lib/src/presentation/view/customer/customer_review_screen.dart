import 'package:flutter/material.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/presentation/view/customer/widget/review_card.dart';
import 'package:restaurant_app/src/presentation/view/customer/widget/review_summary_card.dart';
import 'package:restaurant_app/src/presentation/view/customer/widget/search_widget.dart';
import 'package:restaurant_app/src/presentation/view/customer/widget/show_replay_dialog.dart';
import 'package:restaurant_app/src/presentation/widgets/datefield_widget.dart';
import '../../controller/customer_review_controller.dart';
import '../../widgets/app_bar.dart';


class CustomerReviewScreen extends StatelessWidget {
  CustomerReviewScreen({super.key});

  final CustomerReviewController controller =
      Get.put(CustomerReviewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  AppColors.background,

      appBar: const CustomAppBar(
        title: "Customer Review",
      ),

      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Date
              Obx(
  () => CommonDateFilter(
    fromDate: controller.fromDate.value,
    toDate: controller.toDate.value,
    onFromTap: controller.pickFromDate,
    onToTap: controller.pickToDate,
  ),
),

              const SizedBox(height: 16),

              /// Search
              SearchWidget(
                onChanged: controller.changeSearch,
              ),

              const SizedBox(height: 18),

              /// Summary Cards
              Row(
                children: const [
                  Expanded(
                    child: ReviewSummaryCard(
                      title: "Average",
                      value: "4.8",
                      icon: customerReviewIcon,
                      iconColor: Color(0xff00BFA5),
                      iconBg: Color(0xffDDF7F5),
                      hasStar: true,
                    ),
                  ),

                  SizedBox(width: 14),

                  Expanded(
                    child: ReviewSummaryCard(
                      title: "Feedbacks",
                      value: "248",
                      icon: notificationIcon,
                      iconColor: Color(0xff6200EA),
                      iconBg: Color(0xffEEE8FF),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Reviews
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.filteredReviews.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: 18),
                itemBuilder: (context, index) {
                  return ReviewCard(
                    review: controller.filteredReviews[index],
                    onReply: () => showReplyDialog(context),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}