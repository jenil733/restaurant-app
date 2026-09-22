import 'package:dio/dio.dart';
import '../../core/const/api_routes.dart';
import '../../core/error/failure.dart';
import '../../core/services/api_services.dart';
import '../../domain/repository/delete_category_repository.dart';
import '../models/delete_category_model.dart';

class DeleteCategoryRepositoryImpl implements DeleteCategoryRepository {
  final ApiService _apiService;

  DeleteCategoryRepositoryImpl(this._apiService);

  @override
  Future<DeleteCategoryResponseModel> deleteCategory(DeleteCategoryRequestModel request) async {
    try {
      final url = '${ApiRoutes.deleteCategory}/${request.id}';
      final response = await _apiService.post(url);
      return DeleteCategoryResponseModel.fromJson(response);
    } on DioException catch (e) {
      String message = 'Failed to delete category';
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
