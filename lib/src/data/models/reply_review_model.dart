class ReplyReviewRequestModel {
  final dynamic reviewId;
  final String message;

  ReplyReviewRequestModel({
    required this.reviewId,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}

class ReplyReviewResponseModel {
  final bool success;
  final String message;
  final dynamic data;
  final int? code;

  ReplyReviewResponseModel({
    required this.success,
    required this.message,
    this.data,
    this.code,
  });

  factory ReplyReviewResponseModel.fromJson(Map<String, dynamic> json) {
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

    return ReplyReviewResponseModel(
      success: isSuccess,
      message: json['message']?.toString() ?? '',
      data: json['data'],
      code: codeVal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (data != null) 'data': data,
      if (code != null) 'code': code,
    };
  }
}
