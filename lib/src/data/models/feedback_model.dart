class FeedbackItemModel {
  final dynamic id;
  final String name;
  final String? image;
  final double rating;
  final String review;
  final String time;
  final String? reply;

  FeedbackItemModel({
    this.id,
    required this.name,
    this.image,
    this.rating = 5.0,
    required this.review,
    required this.time,
    this.reply,
  });

  factory FeedbackItemModel.fromJson(Map<String, dynamic> json) {
    double parsedRating = 5.0;
    final rawRating = json['rating'] ?? json['stars'] ?? json['rate'];
    if (rawRating is num) {
      parsedRating = rawRating.toDouble();
    } else if (rawRating is String) {
      parsedRating = double.tryParse(rawRating) ?? 5.0;
    }

    return FeedbackItemModel(
      id: json['id'] ?? json['feedback_id'],
      name: json['name']?.toString() ??
          json['customer_name']?.toString() ??
          json['user_name']?.toString() ??
          'Customer',
      image: json['image']?.toString() ??
          json['profile_image']?.toString() ??
          json['avatar']?.toString() ??
          json['photo']?.toString(),
      rating: parsedRating,
      review: json['review']?.toString() ??
          json['comment']?.toString() ??
          json['message']?.toString() ??
          json['feedback']?.toString() ??
          '',
      time: json['time']?.toString() ??
          json['created_at']?.toString() ??
          json['date']?.toString() ??
          '',
      reply: json['reply']?.toString() ?? json['admin_reply']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (image != null) 'image': image,
      'rating': rating,
      'review': review,
      'time': time,
      if (reply != null) 'reply': reply,
    };
  }
}

class FeedbackDataModel {
  final List<FeedbackItemModel> feedbacks;
  final int totalFeedbacks;
  final double averageRating;

  FeedbackDataModel({
    required this.feedbacks,
    required this.totalFeedbacks,
    required this.averageRating,
  });

  factory FeedbackDataModel.fromJson(Map<String, dynamic> json) {
    List<FeedbackItemModel> items = [];
    final rawList = json['feedbacks'] ?? json['data'] ?? json['reviews'] ?? json['feedback_list'];
    if (rawList is List) {
      items = rawList
          .whereType<Map>()
          .map((item) => FeedbackItemModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    int total = items.length;
    final rawTotal = json['total_feedbacks'] ?? json['total'] ?? json['count'];
    if (rawTotal is int) {
      total = rawTotal;
    } else if (rawTotal is num) {
      total = rawTotal.toInt();
    } else if (rawTotal is String) {
      total = int.tryParse(rawTotal) ?? items.length;
    }

    double avg = 5.0;
    if (items.isNotEmpty) {
      final sum = items.fold<double>(0.0, (prev, elem) => prev + elem.rating);
      avg = sum / items.length;
    }
    final rawAvg = json['average_rating'] ?? json['avg_rating'] ?? json['rating'];
    if (rawAvg is num) {
      avg = rawAvg.toDouble();
    } else if (rawAvg is String) {
      avg = double.tryParse(rawAvg) ?? avg;
    }

    return FeedbackDataModel(
      feedbacks: items,
      totalFeedbacks: total,
      averageRating: avg,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feedbacks': feedbacks.map((f) => f.toJson()).toList(),
      'total_feedbacks': totalFeedbacks,
      'average_rating': averageRating,
    };
  }
}

class FeedbackResponseModel {
  final bool success;
  final String message;
  final FeedbackDataModel? data;
  final int? code;

  FeedbackResponseModel({
    required this.success,
    required this.message,
    this.data,
    this.code,
  });

  factory FeedbackResponseModel.fromJson(Map<String, dynamic> json) {
    bool isSuccess = false;
    final statusVal = json['status'];
    final successVal = json['success'];
    final codeVal = json['code'] is int
        ? json['code'] as int
        : int.tryParse(json['code']?.toString() ?? '');

    if (statusVal is bool) {
      isSuccess = statusVal;
    } else if (statusVal is num) {
      isSuccess = statusVal == 1 || statusVal == 200 || statusVal == 201;
    } else if (statusVal is String) {
      final s = statusVal.toLowerCase().trim();
      isSuccess = s == 'success' || s == 'true' || s == '1' || s == '200' || s == 'ok';
    } else if (successVal is bool) {
      isSuccess = successVal;
    } else if (successVal is num) {
      isSuccess = successVal == 1 || successVal == 200 || successVal == 201;
    } else if (successVal is String) {
      final s = successVal.toLowerCase().trim();
      isSuccess = s == 'success' || s == 'true' || s == '1' || s == 'ok';
    } else if (codeVal == 200 || codeVal == 201) {
      isSuccess = true;
    }

    FeedbackDataModel? dataModel;
    final rawData = json['data'];
    if (rawData is Map) {
      dataModel = FeedbackDataModel.fromJson(Map<String, dynamic>.from(rawData));
      isSuccess = true;
    } else if (rawData is List) {
      dataModel = FeedbackDataModel.fromJson({'feedbacks': rawData});
      isSuccess = true;
    } else if (json.containsKey('feedbacks') && json['feedbacks'] is List) {
      dataModel = FeedbackDataModel.fromJson(json);
      isSuccess = true;
    }

    return FeedbackResponseModel(
      success: isSuccess,
      message: json['message']?.toString() ?? '',
      data: dataModel,
      code: codeVal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (data != null) 'data': data!.toJson(),
      if (code != null) 'code': code,
    };
  }
}
