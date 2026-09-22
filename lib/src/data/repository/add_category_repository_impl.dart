import 'package:dio/dio.dart';
import '../../core/const/api_routes.dart';
import '../../core/error/failure.dart';
import '../../core/services/api_services.dart';
import '../../domain/repository/add_category_repository.dart';
import '../models/add_category_model.dart';

class AddCategoryRepositoryImpl implements AddCategoryRepository {
  final ApiService _apiService;

  AddCategoryRepositoryImpl(this._apiService);

  @override
  Future<AddCategoryResponseModel> addCategory(AddCategoryRequestModel request) async {
    try {
      final formData = await request.toFormData();
      final response = await _apiService.post(
        ApiRoutes.addCategory,
        data: formData,
      );
      return AddCategoryResponseModel.fromJson(response);
    } on DioException catch (e) {
      String message = 'Failed to add category';
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
