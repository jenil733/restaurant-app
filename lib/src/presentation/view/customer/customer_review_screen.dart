import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';
import 'package:restaurant_app/src/presentation/view/customer/widget/review_card.dart';
import 'package:restaurant_app/src/presentation/view/customer/widget/review_summary_card.dart';
import 'package:restaurant_app/src/presentation/view/customer/widget/search_widget.dart';
import 'package:restaurant_app/src/presentation/view/customer/widget/show_replay_dialog.dart';
import 'package:restaurant_app/src/presentation/widgets/app_bar.dart';
import 'package:restaurant_app/src/presentation/widgets/datefield_widget.dart';
import '../../controller/customer_review_controller.dart';

class CustomerReviewScreen extends StatelessWidget {
  CustomerReviewScreen({super.key});

  final CustomerReviewController controller =
      Get.isRegistered<CustomerReviewController>()
          ? Get.find<CustomerReviewController>()
          : Get.put(CustomerReviewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: "Customer Review",
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchReviews(isRefresh: true),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Date Filter
              Obx(
                () => CommonDateFilter(
                  fromDate: controller.fromDate.value,
                  toDate: controller.toDate.value,
                  onFromTap: () => controller.pickFromDate(context),
                  onToTap: () => controller.pickToDate(context),
                ),
              ),

              Obx(() {
                if (controller.fromDate.value.isNotEmpty ||
                    controller.toDate.value.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: controller.clearDateFilters,
                        icon: const Icon(Icons.clear, size: 16),
                        label: const Text("Clear Dates"),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xffFF8A3D),
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),

              const SizedBox(height: 16),

              /// Search
              SearchWidget(
                onChanged: controller.changeSearch,
              ),

              const SizedBox(height: 18),

              /// Summary Cards
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: ReviewSummaryCard(
                        title: "Average",
                        value: controller.averageRating.value.toStringAsFixed(1),
                        icon: customerReviewIcon,
                        iconColor: const Color(0xff00BFA5),
                        iconBg: const Color(0xffDDF7F5),
                        hasStar: true,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: ReviewSummaryCard(
                        title: "Feedbacks",
                        value: controller.totalFeedbacks.value.toString(),
                        icon: notificationIcon,
                        iconColor: const Color(0xff6200EA),
                        iconBg: const Color(0xffEEE8FF),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// Reviews List or Loading/Empty States
              Obx(() {
                if (controller.isLoading.value && controller.reviews.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (controller.errorMessage.value != null &&
                    controller.reviews.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Text(
                            controller.errorMessage.value!,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => controller.fetchReviews(isRefresh: true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffFF8A3D),
                            ),
                            child: const Text(
                              "Retry",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final filteredList = controller.filteredReviews;

                if (filteredList.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Text(
                        "No reviews found",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 18),
                  itemBuilder: (context, index) {
                    final item = filteredList[index];
                    return ReviewCard(
                      review: item,
                      onReply: () => showReplyDialog(
                        context,
                        onSubmit: (message) {
                          controller.replyReview(item.id, message);
                        },
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}