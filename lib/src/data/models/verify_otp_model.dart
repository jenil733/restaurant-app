import 'package:dio/dio.dart';

class VerifyOtpRequestModel {
  final String phone;
  final String otp;

  VerifyOtpRequestModel({
    required this.phone,
    required this.otp,
  });

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'otp': otp,
      };

  FormData toFormData() => FormData.fromMap(toJson());
}

class VerifyOtpResponseModel {
  final bool success;
  final String message;
  final String? token;
  final dynamic data;
  final int? code;

  VerifyOtpResponseModel({
    required this.success,
    required this.message,
    this.token,
    this.data,
    this.code,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    bool isSuccess = false;
    if (json['status'] is bool) {
      isSuccess = json['status'] as bool;
    } else if (json['status'] is String) {
      isSuccess = json['status'].toString().toLowerCase() == 'success' ||
          json['status'].toString().toLowerCase() == 'true';
    } else if (json['success'] is bool) {
      isSuccess = json['success'] as bool;
    } else if (json['code'] == 200) {
      isSuccess = true;
    }

    String? token;
    if (json['data'] is Map && json['data']['token'] != null) {
      token = json['data']['token'].toString();
    } else if (json['token'] != null) {
      token = json['token'].toString();
    }

    return VerifyOtpResponseModel(
      success: isSuccess,
      message: json['message']?.toString() ?? '',
      token: token,
      data: json['data'],
      code: json['code'] is int ? json['code'] as int : int.tryParse(json['code']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': success,
        'message': message,
        if (token != null) 'token': token,
        if (data != null) 'data': data,
        if (code != null) 'code': code,
      };
}
