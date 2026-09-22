import 'package:dio/dio.dart';

class SendOtpRequestModel {
  final String phone;

  SendOtpRequestModel({required this.phone});

  Map<String, dynamic> toJson() => {'phone': phone};

  FormData toFormData() => FormData.fromMap(toJson());
}

class SendOtpResponseModel {
  final bool success;
  final String message;
  final dynamic data;
  final int? code;

  SendOtpResponseModel({
    required this.success,
    required this.message,
    this.data,
    this.code,
  });

  factory SendOtpResponseModel.fromJson(Map<String, dynamic> json) {
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

    return SendOtpResponseModel(
      success: isSuccess,
      message: json['message']?.toString() ?? '',
      data: json['data'],
      code: json['code'] is int ? json['code'] as int : int.tryParse(json['code']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': success,
        'message': message,
        if (data != null) 'data': data,
        if (code != null) 'code': code,
      };
}
