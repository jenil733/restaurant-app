class UpdateStatusRequestModel {
  final bool isOnline;

  UpdateStatusRequestModel({required this.isOnline});

  Map<String, dynamic> toJson() {
    return {
      'is_online': isOnline,
    };
  }

  factory UpdateStatusRequestModel.fromJson(Map<String, dynamic> json) {
    bool onlineVal = true;
    if (json['is_online'] is bool) {
      onlineVal = json['is_online'] as bool;
    } else if (json['is_online'] == 1 || json['is_online'] == '1' || json['is_online'] == 'true') {
      onlineVal = true;
    } else if (json['is_online'] == 0 || json['is_online'] == '0' || json['is_online'] == 'false') {
      onlineVal = false;
    }

    return UpdateStatusRequestModel(isOnline: onlineVal);
  }
}

class UpdateStatusResponseModel {
  final bool success;
  final String? message;
  final UpdateStatusDataModel? data;
  final int? code;

  UpdateStatusResponseModel({
    required this.success,
    this.message,
    this.data,
    this.code,
  });

  factory UpdateStatusResponseModel.fromJson(Map<String, dynamic> json) {
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

    UpdateStatusDataModel? dataModel;
    if (json['data'] is Map<String, dynamic>) {
      dataModel = UpdateStatusDataModel.fromJson(
        json['data'] as Map<String, dynamic>,
      );
    } else if (json['data'] is bool) {
      dataModel = UpdateStatusDataModel(isOnline: json['data'] as bool);
    } else if (json.containsKey('is_online')) {
      dataModel = UpdateStatusDataModel.fromJson(json);
    }

    int? codeVal;
    if (json['code'] != null) {
      codeVal = int.tryParse(json['code'].toString());
    }

    return UpdateStatusResponseModel(
      success: isSuccess,
      message: json['message']?.toString(),
      data: dataModel,
      code: codeVal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (message != null) 'message': message,
      if (data != null) 'data': data!.toJson(),
      if (code != null) 'code': code,
    };
  }
}

class UpdateStatusDataModel {
  final bool isOnline;

  UpdateStatusDataModel({required this.isOnline});

  factory UpdateStatusDataModel.fromJson(Map<String, dynamic> json) {
    bool onlineVal = true;
    final raw = json['is_online'] ?? json['online'] ?? json['status'];
    if (raw is bool) {
      onlineVal = raw;
    } else if (raw == 1 || raw == '1' || raw == 'true' || raw == 'online') {
      onlineVal = true;
    } else if (raw == 0 || raw == '0' || raw == 'false' || raw == 'offline') {
      onlineVal = false;
    }

    return UpdateStatusDataModel(isOnline: onlineVal);
  }

  Map<String, dynamic> toJson() {
    return {
      'is_online': isOnline,
    };
  }
}
