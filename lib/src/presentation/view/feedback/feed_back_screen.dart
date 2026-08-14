import 'package:flutter/material.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/presentation/view/customer/widget/search_widget.dart';
import 'package:restaurant_app/src/presentation/view/feedback/widgets/feedback_card.dart';
import 'package:restaurant_app/src/presentation/view/feedback/widgets/fliter_dropdown.dart';

import '../../controller/feedback_controller.dart';
import '../../widgets/app_bar.dart';

class FeedbackScreen extends StatelessWidget {
  FeedbackScreen({super.key});

  final controller = Get.put(FeedbackController());

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

              /// Summary Card
              Center(
                child: Container(
                  width: 170,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Feedbacks",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff1C2A3A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            controller.totalFeedbacks.value.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff1C2A3A),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: const Color(0xffEEE8FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.feedback_outlined,
                          color: Colors.deepPurple,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Feedback list
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.filteredFeedback.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (_, index) {
                  return FeedbackCard(
                    review: controller.filteredFeedback[index],
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

