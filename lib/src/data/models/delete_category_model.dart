import 'package:dio/dio.dart';

class DeleteCategoryRequestModel {
  final dynamic categoryId;
  final String? phone;

  DeleteCategoryRequestModel({
    dynamic id,
    dynamic categoryId,
    this.phone,
  }) : categoryId = categoryId ?? id;

  dynamic get id => categoryId;

  Map<String, dynamic> toJson() => {
        if (categoryId != null) 'id': categoryId.toString(),
        if (phone != null) 'phone': phone,
      };

  Future<FormData> toFormData() async => FormData.fromMap(toJson());
}

class DeleteCategoryResponseModel {
  final bool success;
  final String message;
  final int? code;

  DeleteCategoryResponseModel({
    required this.success,
    required this.message,
    this.code,
  });

  factory DeleteCategoryResponseModel.fromJson(Map<String, dynamic> json) {
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

    return DeleteCategoryResponseModel(
      success: isSuccess,
      message: json['message']?.toString() ?? (isSuccess ? 'Category deleted successfully' : ''),
      code: codeVal,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': success,
        'message': message,
        if (code != null) 'code': code,
      };
}
