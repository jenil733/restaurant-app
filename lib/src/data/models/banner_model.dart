class BannerResponseModel {
  final bool success;
  final String? message;
  final List<BannerModel> data;
  final int? code;

  BannerResponseModel({
    required this.success,
    this.message,
    this.data = const [],
    this.code,
  });

  factory BannerResponseModel.fromJson(Map<String, dynamic> json) {
    bool isSuccess = false;
    if (json['success'] is bool) {
      isSuccess = json['success'] as bool;
    } else if (json['status'] is bool) {
      isSuccess = json['status'] as bool;
    } else if (json['status'] == 'success' ||
        json['status'] == 1 ||
        json['status'] == '1' ||
        json['status'] == 200 ||
        json['status'] == '200' ||
        json['code'] == 200) {
      isSuccess = true;
    } else if (json['data'] != null) {
      isSuccess = true;
    }

    List<BannerModel> bannersList = [];
    final dataRaw = json['data'] ?? json['banners'] ?? json['result'];

    if (dataRaw is List) {
      bannersList = dataRaw
          .whereType<Map<String, dynamic>>()
          .map((e) => BannerModel.fromJson(e))
          .toList();
    } else if (dataRaw is Map<String, dynamic>) {
      if (dataRaw['banners'] is List) {
        bannersList = (dataRaw['banners'] as List)
            .whereType<Map<String, dynamic>>()
            .map((e) => BannerModel.fromJson(e))
            .toList();
      } else {
        bannersList = [BannerModel.fromJson(dataRaw)];
      }
    }

    int? codeVal;
    if (json['code'] != null) {
      codeVal = int.tryParse(json['code'].toString());
    }

    return BannerResponseModel(
      success: isSuccess,
      message: json['message']?.toString(),
      data: bannersList,
      code: codeVal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (message != null) 'message': message,
      'data': data.map((e) => e.toJson()).toList(),
      if (code != null) 'code': code,
    };
  }
}

class BannerModel {
  final dynamic id;
  final String? title;
  final String? image;
  final String? link;
  final dynamic status;
  final String? createdAt;
  final String? updatedAt;

  BannerModel({
    this.id,
    this.title,
    this.image,
    this.link,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      title: (json['title'] ?? json['name'] ?? json['heading'])?.toString(),
      image: (json['image'] ??
              json['banner_image'] ??
              json['image_url'] ??
              json['photo'] ??
              json['banner'] ??
              json['file'])
          ?.toString(),
      link: (json['link'] ?? json['url'] ?? json['redirect_url'])?.toString(),
      status: json['status'] ?? json['is_active'],
      createdAt: (json['created_at'] ?? json['date'])?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (image != null) 'image': image,
      if (link != null) 'link': link,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    };
  }
}
