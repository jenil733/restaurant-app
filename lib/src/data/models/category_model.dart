export 'add_category_model.dart';
export 'delete_category_model.dart';

class CategoryModel {
  final dynamic id;
  final String? name;
  final String? description;
  final String? image;
  final dynamic status;

  CategoryModel({
    this.id,
    this.name,
    this.description,
    this.image,
    this.status,
  });

  static String? _extractImage(Map<String, dynamic> json) {
    final keys = [
      'image',
      'image_url',
      'category_image',
      'category_img',
      'category_photo',
      'photo',
      'icon',
      'thumbnail',
      'thumb',
      'img',
      'file',
      'path',
      'picture',
      'media',
    ];
    for (final key in keys) {
      final val = json[key];
      if (val != null) {
        if (val is String) {
          final s = val.trim();
          if (s.isNotEmpty && s.toLowerCase() != 'null') {
            return s;
          }
        } else if (val is Map) {
          final u = val['url']?.toString().trim() ?? val['path']?.toString().trim();
          if (u != null && u.isNotEmpty && u.toLowerCase() != 'null') {
            return u;
          }
        }
      }
    }
    return null;
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name']?.toString() ??
          json['category_name']?.toString() ??
          json['title']?.toString(),
      description: json['description']?.toString() ?? json['desc']?.toString(),
      image: _extractImage(json),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (image != null) 'image': image,
      if (status != null) 'status': status,
    };
  }
}

class CategoryResponseModel {
  final bool success;
  final String message;
  final List<CategoryModel> categories;
  final int? code;

  CategoryResponseModel({
    required this.success,
    required this.message,
    required this.categories,
    this.code,
  });

  factory CategoryResponseModel.fromJson(Map<String, dynamic> json) {
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
    } else if (codeVal == 200 || json['message']?.toString().toLowerCase() == 'ok') {
      isSuccess = true;
    }

    final List<CategoryModel> list = [];
    dynamic rawData = json['data'] ?? json['categories'] ?? json['result'];

    if (rawData is List) {
      for (var item in rawData) {
        if (item is Map<String, dynamic>) {
          list.add(CategoryModel.fromJson(item));
        } else if (item is Map) {
          list.add(CategoryModel.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    } else if (rawData is Map && rawData['categories'] is List) {
      for (var item in (rawData['categories'] as List)) {
        if (item is Map<String, dynamic>) {
          list.add(CategoryModel.fromJson(item));
        } else if (item is Map) {
          list.add(CategoryModel.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    } else if (rawData is Map && rawData['data'] is List) {
      for (var item in (rawData['data'] as List)) {
        if (item is Map<String, dynamic>) {
          list.add(CategoryModel.fromJson(item));
        } else if (item is Map) {
          list.add(CategoryModel.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }

    if (list.isNotEmpty) {
      isSuccess = true;
    }

    return CategoryResponseModel(
      success: isSuccess,
      message: json['message']?.toString() ?? '',
      categories: list,
      code: codeVal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': success,
      'message': message,
      'data': categories.map((c) => c.toJson()).toList(),
      if (code != null) 'code': code,
    };
  }
}
