import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackController extends GetxController {
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

  RxDouble averageRating = 4.8.obs;
  RxInt totalFeedbacks = 248.obs;

  RxList<Map<String, dynamic>> feedbackList = <Map<String, dynamic>>[
    {
      "name": "David Wilson",
      "image": "assets/images/restaurant.jpg",
      "rating": 4,
      "time": "2 hrs ago",
      "review":
          "Excellent service. The booking process was smooth and simple."
    },
    {
      "name": "John Miller",
      "image": "assets/images/restaurant.jpg",
      "rating": 5,
      "time": "5 hrs ago",
      "review":
          "Very tasty food. Fast delivery and excellent customer support."
    },
    {
      "name": "William",
      "image": "assets/images/restaurant.jpg",
      "rating": 3,
      "time": "Yesterday",
      "review":
          "Food was good but delivery was slightly delayed."
    },
    {
      "name": "Sophia",
      "image": "assets/images/restaurant.jpg",
      "rating": 5,
      "time": "2 days ago",
      "review":
          "Amazing experience. Highly recommended."
    },
  ].obs;

  List<Map<String, dynamic>> get filteredFeedback {
    var list = feedbackList.toList();

    if (selectedFilter.value != "All") {
      final rating = int.parse(selectedFilter.value.split(" ").first);

      list = list
          .where((e) => e["rating"] == rating)
          .toList();
    }

    if (searchController.text.isNotEmpty) {
      list = list.where((e) {
        return e["name"]
            .toString()
            .toLowerCase()
            .contains(searchController.text.toLowerCase());
      }).toList();
    }

    return list;
  }

  void changeFilter(String value) {
    selectedFilter.value = value;
    update();
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