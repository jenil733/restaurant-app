import 'dart:io';
import 'package:dio/dio.dart';
import 'product_model.dart';

class AddProductRequestModel {
  final String name;
  final String? desc;
  final String mrp;
  final String discount;
  final String foodType;
  final dynamic category;
  final String? imagePath;
  final String? isPopular;

  AddProductRequestModel({
    required this.name,
    this.desc,
    required this.mrp,
    required this.discount,
    required this.foodType,
    required this.category,
    this.imagePath,
    this.isPopular = "1",
  });

  Map<String, dynamic> toJson() {
    final isNonVeg = foodType.toLowerCase().contains("non") || foodType == "1";
    final catInt = int.tryParse(category?.toString() ?? '');
    final catVal = catInt != null ? catInt.toString() : (category?.toString() ?? '1');
    return {
      'name': name,
      'category': catVal,
      'food_type': isNonVeg ? '1' : '0',
      if (desc != null && desc!.isNotEmpty) 'desc': desc,
      'mrp': mrp,
      'discount': discount,
      if (isPopular != null) 'is_popular': isPopular,
    };
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

class AddProductResponseModel {
  final bool success;
  final String message;
  final ProductModel? product;
  final int? code;

  AddProductResponseModel({
    required this.success,
    required this.message,
    this.product,
    this.code,
  });

  factory AddProductResponseModel.fromJson(Map<String, dynamic> json) {
    bool isSuccess = false;
    if (json['status'] is bool) {
      isSuccess = json['status'] as bool;
    } else if (json['status'] is String) {
      isSuccess = json['status'].toString().toLowerCase() == 'success' ||
          json['status'].toString().toLowerCase() == 'true';
    } else if (json['success'] is bool) {
      isSuccess = json['success'] as bool;
    } else if (json['code'] == 200 || json['code'] == 201) {
      isSuccess = true;
    }

    ProductModel? product;
    if (json['data'] is Map) {
      product = ProductModel.fromJson(Map<String, dynamic>.from(json['data']));
    } else if (json['product'] is Map) {
      product = ProductModel.fromJson(Map<String, dynamic>.from(json['product']));
    }

    return AddProductResponseModel(
      success: isSuccess,
      message: json['message']?.toString() ?? '',
      product: product,
      code: json['code'] is int
          ? json['code'] as int
          : int.tryParse(json['code']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': success,
      'message': message,
      if (product != null) 'data': product!.toJson(),
      if (code != null) 'code': code,
    };
  }
}
