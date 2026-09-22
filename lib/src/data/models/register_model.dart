import 'dart:io';
import 'package:dio/dio.dart';

class RegisterRequestModel {
  final String name;
  final String ownerName;
  final String phone;
  final String email;
  final String street;
  final String address;
  final String pincode;
  final String startTime;
  final String endTime;
  final String licenseNo;
  final String aadhar;
  final String panNo;
  final String? gstin;
  final String accountHolder;
  final String bankName;
  final String accountNumber;
  final String ifscCode;
  final String branchName;
  final String? upiId;
  final String termsConditions;
  final String privacyPolicy;
  final String city;
  final String? restaurantType;

  // File paths for upload
  final String? imagePath;
  final String? fssaiFilePath;
  final String? aadharFilePath;
  final String? panFilePath;
  final String? gstFilePath;

  RegisterRequestModel({
    required this.name,
    required this.ownerName,
    required this.phone,
    required this.email,
    required this.street,
    required this.address,
    required this.pincode,
    required this.startTime,
    required this.endTime,
    required this.licenseNo,
    required this.aadhar,
    required this.panNo,
    this.gstin,
    required this.accountHolder,
    required this.bankName,
    required this.accountNumber,
    required this.ifscCode,
    required this.branchName,
    this.upiId,
    this.termsConditions = 'I agree to the terms',
    this.privacyPolicy = 'I agree to the privacy policy',
    this.city = '',
    this.restaurantType,
    this.imagePath,
    this.fssaiFilePath,
    this.aadharFilePath,
    this.panFilePath,
    this.gstFilePath,
  });

  static String _formatTime(String time) {
    final clean = time.trim();
    if (clean.isEmpty) return '10:00';
    final match = RegExp(r'^(\d{1,2}):(\d{2})\s*(AM|PM)?$', caseSensitive: false).firstMatch(clean);
    if (match != null) {
      int hour = int.parse(match.group(1)!);
      final minute = match.group(2)!;
      final period = match.group(3)?.toUpperCase();
      if (period == 'PM' && hour < 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;
      return '${hour.toString().padLeft(2, '0')}:$minute';
    }
    return clean;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name,
      'owner_name': ownerName,
      'phone': phone,
      'email': email,
      'street': street,
      'address': address,
      'pincode': pincode,
      'start_time': _formatTime(startTime),
      'end_time': _formatTime(endTime),
      'license_no': licenseNo,
      'aadhar': aadhar,
      'pan_no': panNo,
      'account_holder': accountHolder,
      'bank_name': bankName,
      'account_number': accountNumber,
      'ifsc_code': ifscCode,
      'branch_name': branchName,
      'terms_conditions': termsConditions,
      'privacy_policy': privacyPolicy,
      'city': city,
    };

    if (gstin != null && gstin!.trim().isNotEmpty) {
      map['gstin'] = gstin!.trim();
    }
    if (upiId != null && upiId!.trim().isNotEmpty) {
      map['upi_id'] = upiId!.trim();
    }
    if (restaurantType != null && restaurantType!.trim().isNotEmpty) {
      map['restaurant_type'] = restaurantType!.trim();
      map['food_type'] = restaurantType!.trim();
    }

    return map;
  }

  Future<FormData> toFormData() async {
    final fields = toJson();
    final formDataMap = <String, dynamic>{};

    fields.forEach((key, value) {
      formDataMap[key] = value.toString();
    });

    if (imagePath != null && imagePath!.isNotEmpty && File(imagePath!).existsSync()) {
      formDataMap['image'] = await MultipartFile.fromFile(
        imagePath!,
        filename: imagePath!.split(Platform.pathSeparator).last,
      );
    }

    if (fssaiFilePath != null && fssaiFilePath!.isNotEmpty && File(fssaiFilePath!).existsSync()) {
      formDataMap['fssai_file'] = await MultipartFile.fromFile(
        fssaiFilePath!,
        filename: fssaiFilePath!.split(Platform.pathSeparator).last,
      );
    }

    if (aadharFilePath != null && aadharFilePath!.isNotEmpty && File(aadharFilePath!).existsSync()) {
      formDataMap['aadhar_file'] = await MultipartFile.fromFile(
        aadharFilePath!,
        filename: aadharFilePath!.split(Platform.pathSeparator).last,
      );
    }

    if (panFilePath != null && panFilePath!.isNotEmpty && File(panFilePath!).existsSync()) {
      formDataMap['pan_file'] = await MultipartFile.fromFile(
        panFilePath!,
        filename: panFilePath!.split(Platform.pathSeparator).last,
      );
    }

    if (gstFilePath != null && gstFilePath!.isNotEmpty && File(gstFilePath!).existsSync()) {
      formDataMap['gst_file'] = await MultipartFile.fromFile(
        gstFilePath!,
        filename: gstFilePath!.split(Platform.pathSeparator).last,
      );
    }

    return FormData.fromMap(formDataMap);
  }
}

class RegisterResponseModel {
  final bool success;
  final String message;
  final dynamic data;
  final int? code;

  RegisterResponseModel({
    required this.success,
    required this.message,
    this.data,
    this.code,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    bool isSuccess = false;
    if (json['status'] is bool) {
      isSuccess = json['status'] as bool;
    } else if (json['status'] is String) {
      isSuccess = json['status'].toString().toLowerCase() == 'success' ||
          json['status'].toString().toLowerCase() == 'true';
    } else if (json['success'] is bool) {
      isSuccess = json['success'] as bool;
    } else if (json['success'] is String) {
      isSuccess = json['success'].toString().toLowerCase() == 'success' ||
          json['success'].toString().toLowerCase() == 'true';
    } else if (json['code'] == 200 || json['code'] == 201) {
      isSuccess = true;
    }

    return RegisterResponseModel(
      success: isSuccess,
      message: json['message']?.toString() ?? '',
      data: json['data'],
      code: json['code'] is int ? json['code'] as int : int.tryParse(json['code']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': success,
      'message': message,
      if (data != null) 'data': data,
      if (code != null) 'code': code,
    };
  }
}
