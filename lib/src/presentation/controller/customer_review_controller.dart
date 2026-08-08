import 'package:get/get.dart';

class CustomerReviewController extends GetxController {
  var fromDate = "".obs;
  var toDate = "".obs;

  var search = "".obs;

  var averageRating = 4.8.obs;
  var totalFeedbacks = 248.obs;

  RxList<Map<String, dynamic>> reviews =
      <Map<String, dynamic>>[
    {
      "name": "David Wilson",
      "rating": 4,
      "time": "2 hrs ago",
      "review":
          "Excellent service. The booking process was smooth and simple.",
      "image":
          "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=200",
    },
    {
      "name": "John Miller",
      "rating": 5,
      "time": "5 hrs ago",
      "review":
          "Food quality was amazing. Delivery was on time.",
      "image":
          "https://images.unsplash.com/photo-1552566626-52f8b828add9?w=200",
    },
    {
      "name": "Emma Watson",
      "rating": 3,
      "time": "1 day ago",
      "review":
          "Packaging was good. Taste can be improved.",
      "image":
          "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=200",
    },
  ].obs;

  List<Map<String, dynamic>> get filteredReviews {
    if (search.value.isEmpty) return reviews;

    return reviews.where((e) {
      return e["name"]
          .toString()
          .toLowerCase()
          .contains(search.value.toLowerCase());
    }).toList();
  }

  void changeSearch(String value) {
    search.value = value;
  }

  void pickFromDate() {
    fromDate.value = "12/05/2025";
  }

  void pickToDate() {
    toDate.value = "18/05/2025";
  }

  void sendReply(int index) {
    Get.snackbar(
      "Success",
      "Reply Sent Successfully",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}