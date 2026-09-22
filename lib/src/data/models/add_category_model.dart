import 'dart:io';
import 'package:dio/dio.dart';
import 'category_model.dart';

class AddCategoryRequestModel {
  final String name;
  final String? description;
  final String? imagePath;

  AddCategoryRequestModel({
    required this.name,
    this.description,
    this.imagePath,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name,
      'category_name': name,
      'title': name,
    };
    if (description != null && description!.isNotEmpty) {
      map['description'] = description;
      map['desc'] = description;
    }
    return map;
  }

  Future<FormData> toFormData() async {
    final map = <String, dynamic>{
      'name': name,
      'category_name': name,
      'title': name,
    };
    if (description != null && description!.isNotEmpty) {
      map['description'] = description;
      map['desc'] = description;
    }
    if (imagePath != null && imagePath!.isNotEmpty && File(imagePath!).existsSync()) {
      final fileName = imagePath!.split(RegExp(r'[/\\]')).last;
      map['image'] = await MultipartFile.fromFile(
        imagePath!,
        filename: fileName,
      );
      map['category_image'] = await MultipartFile.fromFile(
        imagePath!,
        filename: fileName,
      );
      map['icon'] = await MultipartFile.fromFile(
        imagePath!,
        filename: fileName,
      );
      map['file'] = await MultipartFile.fromFile(
        imagePath!,
        filename: fileName,
      );
    }
    return FormData.fromMap(map);
  }
}

class AddCategoryResponseModel {
  final bool success;
  final String message;
  final CategoryModel? category;
  final int? code;

  AddCategoryResponseModel({
    required this.success,
    required this.message,
    this.category,
    this.code,
  });

  factory AddCategoryResponseModel.fromJson(Map<String, dynamic> json) {
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

    CategoryModel? category;
    if (json['data'] is Map) {
      category = CategoryModel.fromJson(Map<String, dynamic>.from(json['data']));
    } else if (json['category'] is Map) {
      category = CategoryModel.fromJson(Map<String, dynamic>.from(json['category']));
    }

    if (category != null) {
      isSuccess = true;
    }

    return AddCategoryResponseModel(
      success: isSuccess,
      message: json['message']?.toString() ?? (isSuccess ? 'Category added successfully' : ''),
      category: category,
      code: codeVal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': success,
      'message': message,
      if (category != null) 'data': category!.toJson(),
      if (code != null) 'code': code,
    };
  }
}
