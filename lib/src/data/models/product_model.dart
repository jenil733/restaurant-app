export 'add_product_model.dart';
export 'update_product_model.dart';
export 'delete_product_model.dart';

class ProductModel {
  final dynamic id;
  final String? title;
  final String? description;
  final dynamic originalPrice;
  final dynamic discountedPrice;
  final String? discountText;
  final bool isVeg;
  final String? categoryName;
  final dynamic categoryId;
  final String? image;
  final dynamic status;

  ProductModel({
    this.id,
    this.title,
    this.description,
    this.originalPrice,
    this.discountedPrice,
    this.discountText,
    this.isVeg = true,
    this.categoryName,
    this.categoryId,
    this.image,
    this.status,
  });

  Map<String, dynamic> toCardMap() {
    return {
      'id': id,
      'title': title ?? '',
      'description': description ?? '',
      'originalPrice': originalPrice?.toString() ?? '',
      'discountedPrice': discountedPrice?.toString() ?? '',
      'discountText': discountText ?? '',
      'isVeg': isVeg,
      'food_type': isVeg ? 'Veg' : 'Non-Veg',
      'categoryName': categoryName ?? '',
      'categoryId': categoryId,
      'image': image,
      'status': status,
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    bool isVegFood = true;
    final foodTypeStr = (json['food_type'] ?? json['foodType'] ?? json['type'])
        ?.toString()
        .toLowerCase()
        .trim();
    final isVegRaw = json['is_veg'] ?? json['isVeg'];

    if (foodTypeStr != null && foodTypeStr.isNotEmpty) {
      if (foodTypeStr.contains('non')) {
        isVegFood = false;
      } else if (foodTypeStr.contains('veg')) {
        isVegFood = true;
      }
    } else if (isVegRaw != null) {
      if (isVegRaw is bool) {
        isVegFood = isVegRaw;
      } else if (isVegRaw is num) {
        isVegFood = isVegRaw == 1;
      } else {
        final s = isVegRaw.toString().toLowerCase().trim();
        if (s == '0' || s == 'false' || s.contains('non')) {
          isVegFood = false;
        } else {
          isVegFood = true;
        }
      }
    }

    String? discountStr;
    if (json['discount'] != null) {
      final val = json['discount'].toString();
      discountStr = val.contains('%') ? val : '$val %';
    } else if (json['discount_percent'] != null) {
      final val = json['discount_percent'].toString();
      discountStr = val.contains('%') ? val : '$val %';
    } else if (json['discountText'] != null) {
      discountStr = json['discountText'].toString();
    }

    return ProductModel(
      id: json['id'],
      title: json['name']?.toString() ?? json['title']?.toString(),
      description: json['description']?.toString() ?? json['desc']?.toString(),
      originalPrice: json['mrp'] ?? json['originalPrice'] ?? json['price']?.toString(),
      discountedPrice: json['sell_price'] ?? json['sale_price'] ?? json['discountedPrice'] ?? json['mrp'] ?? json['price']?.toString(),
      discountText: discountStr,
      isVeg: isVegFood,
      categoryName: json['category_name']?.toString() ?? json['category']?.toString(),
      categoryId: json['category_id'] ?? json['category'],
      image: json['image']?.toString(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (title != null) 'name': title,
      if (description != null) 'desc': description,
      if (originalPrice != null) 'mrp': originalPrice,
      if (discountedPrice != null) 'sell_price': discountedPrice,
      if (discountText != null) 'discount': discountText,
      'is_veg': isVeg,
      'food_type': isVeg ? '0' : '1',
      if (categoryId != null) 'category': categoryId,
      if (image != null) 'image': image,
      if (status != null) 'status': status,
    };
  }
}

class ProductResponseModel {
  final bool success;
  final String message;
  final List<ProductModel> products;
  final int? code;

  ProductResponseModel({
    required this.success,
    required this.message,
    required this.products,
    this.code,
  });

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) {
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

    final List<ProductModel> list = [];
    dynamic rawData = json['data'] ?? json['products'];

    if (rawData is List) {
      for (var item in rawData) {
        if (item is Map<String, dynamic>) {
          list.add(ProductModel.fromJson(item));
        } else if (item is Map) {
          list.add(ProductModel.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    } else if (rawData is Map && rawData['products'] is List) {
      for (var item in (rawData['products'] as List)) {
        if (item is Map<String, dynamic>) {
          list.add(ProductModel.fromJson(item));
        } else if (item is Map) {
          list.add(ProductModel.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }

    return ProductResponseModel(
      success: isSuccess,
      message: json['message']?.toString() ?? '',
      products: list,
      code: json['code'] is int
          ? json['code'] as int
          : int.tryParse(json['code']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': success,
      'message': message,
      'data': products.map((p) => p.toJson()).toList(),
      if (code != null) 'code': code,
    };
  }
}
