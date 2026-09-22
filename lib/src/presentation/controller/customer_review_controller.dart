import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/di/service_locator.dart';
import '../../core/services/api_services.dart';
import '../../data/models/reviews_model.dart';
import '../../data/repository/reply_review_repository_impl.dart';
import '../../data/repository/reviews_repository_impl.dart';
import '../../domain/usecase/get_reviews_usecase.dart';
import '../../domain/usecase/reply_review_usecase.dart';

class CustomerReviewController extends GetxController {
  late final GetReviewsUseCase _getReviewsUseCase;
  late final ReplyReviewUseCase _replyReviewUseCase;

  final TextEditingController searchController = TextEditingController();

  var fromDate = "".obs;
  var toDate = "".obs;
  var search = "".obs;

  var isLoading = false.obs;
  var isSubmittingReply = false.obs;
  var errorMessage = RxnString();

  var averageRating = 0.0.obs;
  var totalFeedbacks = 0.obs;

  RxList<ReviewItemModel> reviews = <ReviewItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _getReviewsUseCase = sl.isRegistered<GetReviewsUseCase>()
        ? sl<GetReviewsUseCase>()
        : GetReviewsUseCase(ReviewsRepositoryImpl(ApiService()));

    _replyReviewUseCase = sl.isRegistered<ReplyReviewUseCase>()
        ? sl<ReplyReviewUseCase>()
        : ReplyReviewUseCase(ReplyReviewRepositoryImpl(ApiService()));

    fetchReviews();
  }

  String _formatDate(DateTime dt) {
    final y = dt.year.toString();
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return "$y-$m-$d";
  }

  Future<void> fetchReviews({bool isRefresh = false}) async {
    if (!isRefresh && reviews.isNotEmpty) {
      // Refresh silently
    } else {
      isLoading.value = true;
    }
    errorMessage.value = null;

    try {
      final response = await _getReviewsUseCase(
        startDate: fromDate.value.isNotEmpty ? fromDate.value : null,
        endDate: toDate.value.isNotEmpty ? toDate.value : null,
        search: search.value.isNotEmpty ? search.value : null,
      );

      if (response.data != null) {
        final data = response.data!;
        reviews.assignAll(data.reviews);
        averageRating.value = data.averageRating;
        totalFeedbacks.value = data.totalFeedbacks;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint("Error fetching reviews: $e");
    } finally {
      isLoading.value = false;
    }
  }

  List<ReviewItemModel> get filteredReviews {
    if (search.value.isEmpty) return reviews;

    final query = search.value.toLowerCase().trim();
    return reviews.where((e) {
      return e.name.toLowerCase().contains(query) ||
          e.review.toLowerCase().contains(query);
    }).toList();
  }

  void changeSearch(String value) {
    search.value = value;
  }

  Future<void> pickFromDate(BuildContext context) async {
    DateTime initial = DateTime.now();
    try {
      if (fromDate.value.isNotEmpty) {
        initial = DateTime.parse(fromDate.value);
      }
    } catch (_) {}

    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (date != null) {
      fromDate.value = _formatDate(date);
      fetchReviews(isRefresh: true);
    }
  }

  Future<void> pickToDate(BuildContext context) async {
    DateTime initial = DateTime.now();
    try {
      if (toDate.value.isNotEmpty) {
        initial = DateTime.parse(toDate.value);
      }
    } catch (_) {}

    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (date != null) {
      toDate.value = _formatDate(date);
      fetchReviews(isRefresh: true);
    }
  }

  void clearDateFilters() {
    fromDate.value = "";
    toDate.value = "";
    fetchReviews(isRefresh: true);
  }

  Future<bool> replyReview(dynamic reviewId, String message) async {
    if (reviewId == null || message.trim().isEmpty) return false;

    isSubmittingReply.value = true;
    try {
      final response = await _replyReviewUseCase(
        reviewId: reviewId,
        message: message.trim(),
      );

      if (response.success) {
        Get.snackbar(
          "Success",
          response.message.isNotEmpty ? response.message : "Reply sent successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
        );
        fetchReviews(isRefresh: true);
        return true;
      } else {
        Get.snackbar(
          "Error",
          response.message.isNotEmpty ? response.message : "Failed to send reply",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isSubmittingReply.value = false;
    }
  }

  void sendReply(int index) {
    if (index >= 0 && index < reviews.length) {
      final review = reviews[index];
      // fallback wrapper
      if (Get.context != null) {
        // can show dialog
      }
    }
  }
}