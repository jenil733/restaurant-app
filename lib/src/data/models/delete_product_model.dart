import 'package:dio/dio.dart';

class DeleteProductRequestModel {
  final dynamic productId;
  final String? phone;

  DeleteProductRequestModel({
    dynamic id,
    dynamic productId,
    this.phone,
  }) : productId = productId ?? id;

  dynamic get id => productId;

  Map<String, dynamic> toJson() => {
        if (productId != null) 'id': productId.toString(),
        if (phone != null) 'phone': phone,
      };

  Future<FormData> toFormData() async => FormData.fromMap(toJson());
}

class DeleteProductResponseModel {
  final bool success;
  final String message;
  final int? code;

  DeleteProductResponseModel({
    required this.success,
    required this.message,
    this.code,
  });

  factory DeleteProductResponseModel.fromJson(Map<String, dynamic> json) {
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

    return DeleteProductResponseModel(
      success: isSuccess,
      message: json['message']?.toString() ?? (isSuccess ? 'Product deleted successfully' : ''),
      code: codeVal,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': success,
        'message': message,
        if (code != null) 'code': code,
      };
}
