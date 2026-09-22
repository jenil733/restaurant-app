import 'package:dio/dio.dart';
import '../../core/const/api_routes.dart';
import '../../core/error/failure.dart';
import '../../core/services/api_services.dart';
import '../../domain/repository/profile_repository.dart';
import '../models/profile_model.dart';
import '../models/update_profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ApiService _apiService;

  ProfileRepositoryImpl(this._apiService);

  @override
  Future<ProfileResponseModel> getProfile({Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _apiService.get(
        ApiRoutes.profile,
        params: queryParams,
      );
      return ProfileResponseModel.fromJson(response);
    } on DioException catch (e) {
      String message = 'Failed to fetch profile';
      if (e.response?.data is Map) {
        final data = e.response!.data as Map;
        if (data['message'] != null) {
          message = data['message'].toString();
        }
      }
      throw ServerFailure(message: message);
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<UpdateProfileResponseModel> updateProfile(UpdateProfileRequestModel request) async {
    try {
      final formData = await request.toFormData();
      final response = await _apiService.post(
        ApiRoutes.updateProfile,
        data: formData,
      );
      return UpdateProfileResponseModel.fromJson(response);
    } on DioException catch (e) {
      String message = 'Failed to update profile';
      if (e.response?.data is Map) {
        final data = e.response!.data as Map;
        if (data['message'] != null) {
          message = data['message'].toString();
        }
      }
      throw ServerFailure(message: message);
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(message: e.toString());
    }
  }
}
