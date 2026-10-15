import 'package:dio/dio.dart';
import '../../core/const/api_routes.dart';
import '../../core/error/failure.dart';
import '../../core/services/api_services.dart';
import '../../domain/repository/register_repository.dart';
import '../models/register_model.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final ApiService _apiService;

  RegisterRepositoryImpl(this._apiService);

  @override
  Future<RegisterResponseModel> register(RegisterRequestModel request) async {
    try {
      // ignore: avoid_print
      print('🚀 [REGISTER] Preparing FormData: ${request.toJson()}');
      final formData = await request.toFormData();
      final response = await _apiService.post(
        ApiRoutes.register,
        data: formData,
      );
      final model = RegisterResponseModel.fromJson(response);
      if (!model.success) {
        throw ServerFailure(
          message: model.message.isNotEmpty
              ? model.message
              : 'Restaurant registration failed. Please check the entered details.',
        );
      }
      return model;
    } on DioException catch (e) {
      // ignore: avoid_print
      print('🚨 [REGISTER ERROR] Status: ${e.response?.statusCode}, Data: ${e.response?.data}');
      String message = 'Registration failed';
      if (e.response?.data is Map) {
        final data = e.response!.data as Map;
        if (data['errors'] is Map && (data['errors'] as Map).isNotEmpty) {
          final errorMap = data['errors'] as Map;
          final messages = <String>[];
          errorMap.forEach((key, val) {
            if (val is List) {
              messages.addAll(val.map((e) => e.toString()));
            } else if (val != null) {
              messages.add(val.toString());
            }
          });
          if (messages.isNotEmpty) {
            message = messages.join('\n');
          }
        } else if (data['message'] != null && data['message'].toString().trim().isNotEmpty) {
          message = data['message'].toString();
        } else if (data['error'] != null && data['error'].toString().trim().isNotEmpty) {
          message = data['error'].toString();
        }
      } else if (e.message != null && e.message!.isNotEmpty) {
        message = e.message!;
      }
      throw ServerFailure(message: message);
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<RegisterResponseModel> completeRegistration(CompleteRegistrationRequestModel request) async {
    try {
      // ignore: avoid_print
      print('🚀 [COMPLETE REGISTRATION] Preparing FormData: ${request.toJson()}');
      final formData = await request.toFormData();
      final response = await _apiService.post(
        ApiRoutes.completeRegistration,
        data: formData,
      );
      final model = RegisterResponseModel.fromJson(response);
      if (!model.success) {
        throw ServerFailure(
          message: model.message.isNotEmpty
              ? model.message
              : 'Failed to complete registration. Please check the entered details.',
        );
      }
      return model;
    } on DioException catch (e) {
      // ignore: avoid_print
      print('🚨 [COMPLETE REGISTRATION ERROR] Status: ${e.response?.statusCode}, Data: ${e.response?.data}');
      String message = 'Failed to complete registration';
      if (e.response?.data is Map) {
        final data = e.response!.data as Map;
        if (data['errors'] is Map && (data['errors'] as Map).isNotEmpty) {
          final errorMap = data['errors'] as Map;
          final messages = <String>[];
          errorMap.forEach((key, val) {
            if (val is List) {
              messages.addAll(val.map((e) => e.toString()));
            } else if (val != null) {
              messages.add(val.toString());
            }
          });
          if (messages.isNotEmpty) {
            message = messages.join('\n');
          }
        } else if (data['message'] != null && data['message'].toString().trim().isNotEmpty) {
          message = data['message'].toString();
        } else if (data['error'] != null && data['error'].toString().trim().isNotEmpty) {
          message = data['error'].toString();
        }
      } else if (e.message != null && e.message!.isNotEmpty) {
        message = e.message!;
      }
      throw ServerFailure(message: message);
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(message: e.toString());
    }
  }
}
