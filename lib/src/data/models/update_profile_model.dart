import 'dart:io';
import 'package:dio/dio.dart';
import 'profile_model.dart';

class UpdateProfileRequestModel {
  final String? restaurantName;
  final String? ownerName;
  final String? email;
  final String? phone;
  final String? address;
  final String? city;
  final String? street;
  final String? pincode;
  final String? startTime;
  final String? endTime;
  final String? foodType;
  final String? imagePath;

  UpdateProfileRequestModel({
    this.restaurantName,
    this.ownerName,
    this.email,
    this.phone,
    this.address,
    this.city,
    this.street,
    this.pincode,
    this.startTime,
    this.endTime,
    this.foodType,
    this.imagePath,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (restaurantName != null && restaurantName!.isNotEmpty) {
      map['restaurant_name'] = restaurantName;
      map['name'] = restaurantName;
    }
    if (ownerName != null && ownerName!.isNotEmpty) {
      map['owner_name'] = ownerName;
    }
    if (email != null && email!.isNotEmpty) {
      map['email'] = email;
    }
    if (phone != null && phone!.isNotEmpty) {
      map['phone'] = phone;
      map['mobile'] = phone;
    }
    if (address != null && address!.isNotEmpty) {
      map['address'] = address;
    }
    if (city != null && city!.isNotEmpty) {
      map['city'] = city;
    }
    if (street != null && street!.isNotEmpty) {
      map['street'] = street;
    }
    if (pincode != null && pincode!.isNotEmpty) {
      map['pincode'] = pincode;
    }
    if (startTime != null && startTime!.isNotEmpty) {
      map['start_time'] = startTime;
    }
    if (endTime != null && endTime!.isNotEmpty) {
      map['end_time'] = endTime;
    }
    if (foodType != null && foodType!.isNotEmpty) {
      map['food_type'] = foodType;
      map['restaurant_type'] = foodType;
    }
    return map;
  }

  Future<FormData> toFormData() async {
    final map = toJson();
    if (imagePath != null && imagePath!.isNotEmpty && File(imagePath!).existsSync()) {
      map['image'] = await MultipartFile.fromFile(
        imagePath!,
        filename: imagePath!.split(Platform.pathSeparator).last,
      );
    }
    return FormData.fromMap(map);
  }
}

class UpdateProfileResponseModel {
  final bool success;
  final String message;
  final ProfileModel? profile;
  final int? code;

  UpdateProfileResponseModel({
    required this.success,
    required this.message,
    this.profile,
    this.code,
  });

  factory UpdateProfileResponseModel.fromJson(Map<String, dynamic> json) {
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

    ProfileModel? profile;
    dynamic rawData = json['data'] ?? json['profile'] ?? json['restaurant'] ?? json['user'];

    if (rawData is Map) {
      profile = ProfileModel.fromJson(Map<String, dynamic>.from(rawData));
    } else if (json.containsKey('restaurant_name') || json.containsKey('name')) {
      profile = ProfileModel.fromJson(json);
    }

    if (profile != null) {
      isSuccess = true;
    }

    return UpdateProfileResponseModel(
      success: isSuccess,
      message: json['message']?.toString() ?? (isSuccess ? 'Profile updated successfully' : ''),
      profile: profile,
      code: codeVal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': success,
      'message': message,
      if (profile != null) 'data': profile!.toJson(),
      if (code != null) 'code': code,
    };
  }
}
