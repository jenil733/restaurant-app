import 'package:dio/dio.dart';

class UpdateBankDetailsRequestModel {
  final String? accountHolder;
  final String? bankName;
  final String? accountNumber;
  final String? ifsc;
  final String? branch;
  final String? upiId;

  UpdateBankDetailsRequestModel({
    this.accountHolder,
    this.bankName,
    this.accountNumber,
    this.ifsc,
    this.branch,
    this.upiId,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (accountHolder != null) map['account_holder'] = accountHolder;
    if (bankName != null && bankName!.isNotEmpty) map['bank_name'] = bankName;
    if (accountNumber != null && accountNumber!.isNotEmpty) map['account_number'] = accountNumber;
    if (ifsc != null && ifsc!.isNotEmpty) {
      map['ifsc'] = ifsc;
      map['ifsc_code'] = ifsc;
    }
    if (branch != null && branch!.isNotEmpty) {
      map['branch'] = branch;
      map['branch_name'] = branch;
    }
    if (upiId != null) map['upi_id'] = upiId;
    return map;
  }

  Future<FormData> toFormData() async {
    return FormData.fromMap(toJson());
  }
}

class UpdateBankDetailsResponseModel {
  final bool success;
  final String message;
  final int? code;

  UpdateBankDetailsResponseModel({
    required this.success,
    required this.message,
    this.code,
  });

  factory UpdateBankDetailsResponseModel.fromJson(Map<String, dynamic> json) {
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
    } else if (json.containsKey('data') || json.containsKey('bank_details') || json.containsKey('bank')) {
      isSuccess = true;
    } else if (json['message'] != null &&
        !json['message'].toString().toLowerCase().contains('failed') &&
        !json['message'].toString().toLowerCase().contains('error')) {
      isSuccess = true;
    }

    return UpdateBankDetailsResponseModel(
      success: isSuccess,
      message: json['message']?.toString() ?? '',
      code: codeVal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (code != null) 'code': code,
    };
  }
}
