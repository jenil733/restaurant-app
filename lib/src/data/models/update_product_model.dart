import 'dart:io';
import 'package:dio/dio.dart';
import 'product_model.dart';

class UpdateProductRequestModel {
  final dynamic productId;
  final String? name;
  final String? desc;
  final String? mrp;
  final String? discount;
  final String? foodType;
  final dynamic category;
  final dynamic status;
  final String? imagePath;
  final String? isPopular;

  UpdateProductRequestModel({
    dynamic id,
    dynamic productId,
    this.name,
    this.desc,
    this.mrp,
    this.discount,
    this.foodType,
    this.category,
    this.status,
    this.imagePath,
    this.isPopular = "1",
  }) : productId = productId ?? id;

  dynamic get id => productId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (productId != null) map['id'] = productId.toString();
    if (name != null) map['name'] = name;
    if (category != null) {
      final catInt = int.tryParse(category.toString());
      final catVal = (catInt ?? category).toString();
      map['category'] = catVal;
    }
    if (foodType != null) {
      final isNonVeg = foodType!.toLowerCase().contains("non") || foodType == "1";
      map['food_type'] = isNonVeg ? '1' : '0';
    }
    if (desc != null && desc!.isNotEmpty) {
      map['desc'] = desc;
    }
    if (mrp != null) map['mrp'] = mrp;
    if (discount != null) map['discount'] = discount;
    if (status != null) map['status'] = status.toString();
    if (isPopular != null) map['is_popular'] = isPopular;
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

class UpdateProductResponseModel {
  final bool success;
  final String message;
  final ProductModel? product;
  final int? code;

  UpdateProductResponseModel({
    required this.success,
    required this.message,
    this.product,
    this.code,
  });

  factory UpdateProductResponseModel.fromJson(Map<String, dynamic> json) {
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

    ProductModel? product;
    if (json['data'] is Map) {
      product = ProductModel.fromJson(Map<String, dynamic>.from(json['data']));
    } else if (json['product'] is Map) {
      product = ProductModel.fromJson(Map<String, dynamic>.from(json['product']));
    }

    if (product != null) {
      isSuccess = true;
    }

    return UpdateProductResponseModel(
      success: isSuccess,
      message: json['message']?.toString() ?? '',
      product: product,
      code: codeVal,
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
