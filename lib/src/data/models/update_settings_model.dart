import 'package:dio/dio.dart';

class UpdateSettingsRequestModel {
  final bool notificationsEnabled;

  UpdateSettingsRequestModel({
    required this.notificationsEnabled,
  });

  Map<String, dynamic> toJson() {
    return {
      'notifications_enabled': notificationsEnabled ? '1' : '0',
    };
  }

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      'notifications_enabled': notificationsEnabled ? '1' : '0',
    });
  }
}

class UpdateSettingsResponseModel {
  final bool success;
  final String message;
  final bool notificationsEnabled;
  final int? code;

  UpdateSettingsResponseModel({
    required this.success,
    required this.message,
    required this.notificationsEnabled,
    this.code,
  });

  factory UpdateSettingsResponseModel.fromJson(Map<String, dynamic> json) {
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

    bool notifEnabled = true;
    dynamic dataVal = json['data'];
    if (dataVal is Map) {
      final rawNotif = dataVal['notifications_enabled'];
      if (rawNotif is bool) {
        notifEnabled = rawNotif;
      } else if (rawNotif is num) {
        notifEnabled = rawNotif == 1;
      } else if (rawNotif is String) {
        final s = rawNotif.toLowerCase().trim();
        notifEnabled = s == '1' || s == 'true' || s == 'on' || s == 'enable';
      }
    } else if (json.containsKey('notifications_enabled')) {
      final rawNotif = json['notifications_enabled'];
      if (rawNotif is bool) {
        notifEnabled = rawNotif;
      } else if (rawNotif is num) {
        notifEnabled = rawNotif == 1;
      } else if (rawNotif is String) {
        final s = rawNotif.toLowerCase().trim();
        notifEnabled = s == '1' || s == 'true' || s == 'on' || s == 'enable';
      }
    }

    return UpdateSettingsResponseModel(
      success: isSuccess,
      message: json['message']?.toString() ?? '',
      notificationsEnabled: notifEnabled,
      code: codeVal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': {
        'notifications_enabled': notificationsEnabled,
      },
      if (code != null) 'code': code,
    };
  }
}
