import 'package:dio/dio.dart';
import '../../core/const/api_routes.dart';
import '../../core/error/failure.dart';
import '../../core/services/api_services.dart';
import '../../domain/repository/category_repository.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final ApiService _apiService;

  CategoryRepositoryImpl(this._apiService);

  @override
  Future<CategoryResponseModel> getCategories({Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _apiService.get(
        ApiRoutes.categories,
        params: queryParams,
      );
      return CategoryResponseModel.fromJson(response);
    } on DioException catch (e) {
      String message = 'Failed to fetch categories';
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
