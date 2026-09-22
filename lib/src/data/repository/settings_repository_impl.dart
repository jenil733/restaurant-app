import 'package:dio/dio.dart';
import '../../core/const/api_routes.dart';
import '../../core/error/failure.dart';
import '../../core/services/api_services.dart';
import '../../domain/repository/settings_repository.dart';
import '../models/update_settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final ApiService _apiService;

  SettingsRepositoryImpl(this._apiService);

  @override
  Future<UpdateSettingsResponseModel> updateSettings(UpdateSettingsRequestModel request) async {
    try {
      final formData = await request.toFormData();
      final response = await _apiService.post(
        ApiRoutes.updateSettings,
        data: formData,
      );
      return UpdateSettingsResponseModel.fromJson(response);
    } on DioException catch (e) {
      String message = 'Failed to update settings';
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
