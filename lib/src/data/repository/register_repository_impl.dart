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
      final formData = await request.toFormData();
      final response = await _apiService.post(
        ApiRoutes.register,
        data: formData,
      );
      return RegisterResponseModel.fromJson(response);
    } on DioException catch (e) {
      String message = 'Registration failed';
      if (e.response?.data is Map) {
        final data = e.response!.data as Map;
        if (data['message'] != null) {
          message = data['message'].toString();
        } else if (data['error'] != null) {
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
