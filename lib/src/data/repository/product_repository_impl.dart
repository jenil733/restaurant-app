import 'package:dio/dio.dart';
import '../../core/const/api_routes.dart';
import '../../core/error/failure.dart';
import '../../core/services/api_services.dart';
import '../../domain/repository/product_repository.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ApiService _apiService;

  ProductRepositoryImpl(this._apiService);

  String _extractErrorMessage(DioException e, String fallback) {
    if (e.response?.data is Map) {
      final data = e.response!.data as Map;
      if (data['errors'] is Map && (data['errors'] as Map).isNotEmpty) {
        final errorMap = data['errors'] as Map;
        final firstError = errorMap.values.first;
        if (firstError is List && firstError.isNotEmpty) {
          return firstError.first.toString();
        } else if (firstError is String) {
          return firstError;
        }
      }
      if (data['message'] != null && data['message'].toString().trim().isNotEmpty) {
        return data['message'].toString();
      }
    }
    return fallback;
  }

  @override
  Future<ProductResponseModel> getProducts({Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _apiService.get(
        ApiRoutes.products,
        params: queryParams,
      );
      return ProductResponseModel.fromJson(response);
    } on DioException catch (e) {
      throw ServerFailure(message: _extractErrorMessage(e, 'Failed to fetch products'));
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<AddProductResponseModel> addProduct(AddProductRequestModel request) async {
    try {
      final formData = await request.toFormData();
      final response = await _apiService.post(
        ApiRoutes.addProduct,
        data: formData,
      );
      return AddProductResponseModel.fromJson(response);
    } on DioException catch (e) {
      throw ServerFailure(message: _extractErrorMessage(e, 'Failed to add product'));
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<UpdateProductResponseModel> updateProduct(
    dynamic id,
    UpdateProductRequestModel request,
  ) async {
    try {
      final formData = await request.toFormData();
      final url = '${ApiRoutes.updateProduct}/$id';
      final response = await _apiService.post(
        url,
        data: formData,
      );
      return UpdateProductResponseModel.fromJson(response);
    } on DioException catch (e) {
      throw ServerFailure(message: _extractErrorMessage(e, 'Failed to update product'));
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<DeleteProductResponseModel> deleteProduct(DeleteProductRequestModel request) async {
    try {
      final url = '${ApiRoutes.deleteProduct}/${request.id}';
      final response = await _apiService.post(url);
      return DeleteProductResponseModel.fromJson(response);
    } on DioException catch (e) {
      throw ServerFailure(message: _extractErrorMessage(e, 'Failed to delete product'));
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(message: e.toString());
    }
  }
}
