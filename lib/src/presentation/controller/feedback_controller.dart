import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/di/service_locator.dart';
import '../../core/services/api_services.dart';
import '../../data/models/feedback_model.dart';
import '../../data/repository/feedback_repository_impl.dart';
import '../../domain/usecase/get_feedbacks_usecase.dart';

class FeedbackController extends GetxController {
  late final GetFeedbacksUseCase _getFeedbacksUseCase;

  final TextEditingController searchController = TextEditingController();

  RxString selectedFilter = "All".obs;

  final List<String> filterList = [
    "All",
    "5 Star",
    "4 Star",
    "3 Star",
    "2 Star",
    "1 Star",
  ];

  var isLoading = false.obs;
  var errorMessage = RxnString();

  RxDouble averageRating = 5.0.obs;
  RxInt totalFeedbacks = 0.obs;

  RxList<FeedbackItemModel> feedbackList = <FeedbackItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _getFeedbacksUseCase = sl.isRegistered<GetFeedbacksUseCase>()
        ? sl<GetFeedbacksUseCase>()
        : GetFeedbacksUseCase(FeedbackRepositoryImpl(ApiService()));

    fetchFeedbacks();
  }

  Future<void> fetchFeedbacks({bool isRefresh = false}) async {
    if (!isRefresh && feedbackList.isNotEmpty) {
      // Refresh silently
    } else {
      isLoading.value = true;
    }
    errorMessage.value = null;

    try {
      final response = await _getFeedbacksUseCase();
      if (response.data != null) {
        final data = response.data!;
        feedbackList.assignAll(data.feedbacks);
        totalFeedbacks.value = data.totalFeedbacks;
        averageRating.value = data.averageRating;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint("Error fetching feedbacks: $e");
    } finally {
      isLoading.value = false;
    }
  }

  List<FeedbackItemModel> get filteredFeedback {
    var list = feedbackList.toList();

    if (selectedFilter.value != "All") {
      final rating = int.tryParse(selectedFilter.value.split(" ").first) ?? 5;
      list = list.where((e) => e.rating.round() == rating).toList();
    }

    if (searchController.text.isNotEmpty) {
      final query = searchController.text.toLowerCase().trim();
      list = list.where((e) {
        return e.name.toLowerCase().contains(query) ||
            e.review.toLowerCase().contains(query);
      }).toList();
    }

    return list;
  }

  void changeFilter(String value) {
    selectedFilter.value = value;
  }

  void search(String value) {
    update();
  }

  void sendReply(int index) {
    Get.snackbar(
      "Success",
      "Reply Sent Successfully",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}