import 'package:flutter/material.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/presentation/view/customer/widget/review_card.dart';
import 'package:restaurant_app/src/presentation/view/customer/widget/review_summary_card.dart';
import 'package:restaurant_app/src/presentation/view/customer/widget/search_widget.dart';
import 'package:restaurant_app/src/presentation/view/feedback/widgets/fliter_dropdown.dart';

import '../../controller/feedback_controller.dart';
import '../../widgets/app_bar.dart';


class FeedbackScreen extends StatelessWidget {
  FeedbackScreen({super.key});

  final controller =
      Get.put(FeedbackController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: const CustomAppBar(
        title: "Feedbacks",
      ),

      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              FilterDropdown(),

              const SizedBox(height: 16),

              SearchWidget(
                controller: controller.searchController,
                onChanged: controller.search,
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  Expanded(
                    child: ReviewSummaryCard(
                      title: "Average",
                      value: controller.averageRating.value.toString(),
                      icon: customerReviewIcon,
                      iconColor: Colors.teal,
                      iconBg: const Color(0xffDDF7F5),
                      hasStar: true,
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: ReviewSummaryCard(
                      title: "Feedbacks",
                      value: controller.totalFeedbacks.value.toString(),
                      icon: notificationIcon,
                      iconColor: Colors.deepPurple,
                      iconBg: const Color(0xffEEE8FF),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              ListView.separated(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount: controller.filteredFeedback.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: 16),
                itemBuilder: (_, index) {
                  return ReviewCard(
                    review: controller.filteredFeedback[index],
                    showReplyButton: false,
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

