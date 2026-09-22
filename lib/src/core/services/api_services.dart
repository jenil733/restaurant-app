import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' as g;
import 'package:restaurant_app/src/presentation/widgets/app_notification.dart';
import '../const/api_routes.dart';
import '../utils/navigation/app_routes.dart';
import 'local_storage_services.dart';

class ApiService {
  final Dio _dio;
  final _storage = LocalStorageService();
  bool _isHandlingUnauthorized = false;

  ApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiRoutes.baseURL,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {
            "Accept": "application/json",
            "x-api-key": ApiRoutes.apiKey,
          },
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _storage.getString("auth_token");
          if (token != null &&
              token.trim().isNotEmpty &&
              !token.startsWith("pms_token_")) {
            options.headers["Authorization"] = "Bearer $token";
          }

          _logRequest(options);
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logResponse(response);
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          _logError(e);
          final statusCode = e.response?.statusCode;
          final errorData = e.response?.data;
          final isUnauthenticated = statusCode == 401 ||
              (errorData is Map &&
                  (errorData['message']
                          ?.toString()
                          .toLowerCase()
                          .contains('unauthenticated') ==
                      true));

          if (isUnauthenticated) {
            _handleUnauthorized();
          }
          return handler.next(e);
        },
      ),
    );
  }

  void _logToConsole(String message) {
    // print() writes directly to standard output / debug console without debugPrint throttling
    // ignore: avoid_print
    print(message);
  }

  String _formatPayload(dynamic data) {
    if (data == null) return 'null';
    try {
      if (data is Map || data is List) {
        return const JsonEncoder.withIndent('  ').convert(data);
      }
      if (data is String) {
        try {
          final decoded = jsonDecode(data);
          return const JsonEncoder.withIndent('  ').convert(decoded);
        } catch (_) {
          return data;
        }
      }
      return data.toString();
    } catch (_) {
      return data.toString();
    }
  }

  void _logRequest(RequestOptions options) {
    final sb = StringBuffer();
    sb.writeln('\n🌐 ==================== [API REQUEST] ====================');
    sb.writeln(
      '➡️ URL: [${options.method.toUpperCase()}] ${options.baseUrl}${options.path}',
    );
    if (options.queryParameters.isNotEmpty) {
      sb.writeln('🔍 Query Params: ${_formatPayload(options.queryParameters)}');
    }
    if (options.headers.isNotEmpty) {
      final safeHeaders = Map<String, dynamic>.from(options.headers);
      sb.writeln('📋 Headers: ${_formatPayload(safeHeaders)}');
    }
    if (options.data != null) {
      if (options.data is FormData) {
        final formData = options.data as FormData;
        final fieldsMap = {
          for (var entry in formData.fields) entry.key: entry.value,
        };
        final filesMap = {
          for (var entry in formData.files) entry.key: entry.value.filename,
        };
        sb.writeln(
          '📦 Body (FormData): {fields: $fieldsMap, files: $filesMap}',
        );
      } else {
        sb.writeln('📦 Body: ${_formatPayload(options.data)}');
      }
    }
    sb.write('========================================================');
    _logToConsole(sb.toString());
  }

  void _logResponse(Response response) {
    final sb = StringBuffer();
    sb.writeln('\n✅ ==================== [API RESPONSE] ====================');
    sb.writeln(
      '⬅️ URL: [${response.statusCode}] ${response.requestOptions.method.toUpperCase()} ${response.requestOptions.baseUrl}${response.requestOptions.path}',
    );
    sb.writeln('📄 Data:\n${_formatPayload(response.data)}');
    sb.write('=========================================================');
    _logToConsole(sb.toString());
  }

  void _logError(DioException e) {
    final sb = StringBuffer();
    sb.writeln('\n❌ ==================== [API ERROR] ====================');
    sb.writeln(
      '⬅️ URL: [${e.response?.statusCode ?? 'NO_STATUS'}] ${e.requestOptions.method.toUpperCase()} ${e.requestOptions.baseUrl}${e.requestOptions.path}',
    );
    sb.writeln('⚠️ Error Message: ${e.message}');
    if (e.response?.data != null) {
      sb.writeln('📄 Error Data:\n${_formatPayload(e.response!.data)}');
    }
    sb.write('=======================================================');
    _logToConsole(sb.toString());
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    dynamic data,
    bool useFormData = false,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _handleResponse(
      () => _dio.post(
        endpoint,
        data: useFormData && data is Map
            ? FormData.fromMap(Map<String, dynamic>.from(data))
            : data,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? params,
    Options? options,
  }) async {
    return _handleResponse(
      () => _dio.get(endpoint, queryParameters: params, options: options),
    );
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    dynamic data,
    bool useFormData = false,
    Options? options,
  }) async {
    return _handleResponse(
      () => _dio.put(
        endpoint,
        data: useFormData && data is Map
            ? FormData.fromMap(Map<String, dynamic>.from(data))
            : data,
        options: options,
      ),
    );
  }

  Future<Map<String, dynamic>> patch(
    String endpoint, {
    dynamic data,
    bool useFormData = false,
    Options? options,
  }) async {
    return _handleResponse(
      () => _dio.patch(
        endpoint,
        data: useFormData && data is Map
            ? FormData.fromMap(Map<String, dynamic>.from(data))
            : data,
        options: options,
      ),
    );
  }

  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? data,
    Options? options,
  }) async {
    return _handleResponse(
      () => _dio.delete(endpoint, data: data, options: options),
    );
  }

  Future<Map<String, dynamic>> _handleResponse(
    Future<Response> Function() request,
  ) async {
    try {
      final response = await request();

      if (response.data is Map) {
        return Map<String, dynamic>.from(
          response.data as Map<dynamic, dynamic>,
        );
      }

      return {"data": response.data};
    } on DioException catch (e) {
      _logToConsole("DioException handled: ${e.message}");
      rethrow;
    } catch (e) {
      _logToConsole("Unknown exception: $e");
      throw Exception("Unexpected error occurred");
    }
  }

  void _handleUnauthorized() {
    if (_isHandlingUnauthorized) return;

    _storage.remove("auth_token");
    _storage.saveBool("is_logged_in", false);
    _storage.clear();

    final currentRoute = g.Get.currentRoute;
    if (currentRoute == AppRoutes.login ||
        currentRoute == AppRoutes.splash ||
        currentRoute == AppRoutes.onboarding) {
      return;
    }

    _isHandlingUnauthorized = true;

    try {
      g.Get.offAllNamed(AppRoutes.login);
      Future.delayed(const Duration(milliseconds: 300), () {
        AppNotification.showError(
          title: "Session Expired",
          message: "Restaurant account is unauthenticated. Please log in again.",
        );
      });
    } catch (e) {
      debugPrint("Error redirecting to login on 401: $e");
    } finally {
      Future.delayed(const Duration(seconds: 3), () {
        _isHandlingUnauthorized = false;
      });
    }
  }
}
