import 'package:dio/dio.dart';

class RestaurantResendOtpRequestModel {
  final String accountHolder;
  final String bankName;
  final String accountNumber;
  final String ifscCode;
  final String branchName;
  final String upiId;
  final String phone;

  RestaurantResendOtpRequestModel({
    required this.accountHolder,
    required this.bankName,
    required this.accountNumber,
    required this.ifscCode,
    required this.branchName,
    required this.upiId,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
        'account_holder': accountHolder,
        'bank_name': bankName,
        'account_number': accountNumber,
        'ifsc_code': ifscCode,
        'branch_name': branchName,
        'upi_id': upiId,
        'phone': phone,
      };

  FormData toFormData() => FormData.fromMap(toJson());
}

class RestaurantResendOtpResponseModel {
  final bool success;
  final String message;
  final dynamic data;
  final int? code;

  RestaurantResendOtpResponseModel({
    required this.success,
    required this.message,
    this.data,
    this.code,
  });

  factory RestaurantResendOtpResponseModel.fromJson(Map<String, dynamic> json) {
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

    return RestaurantResendOtpResponseModel(
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
