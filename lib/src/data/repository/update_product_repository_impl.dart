import 'package:dio/dio.dart';
import '../../core/const/api_routes.dart';
import '../../core/error/failure.dart';
import '../../core/services/api_services.dart';
import '../../domain/repository/update_product_repository.dart';
import '../models/update_product_model.dart';

class UpdateProductRepositoryImpl implements UpdateProductRepository {
  final ApiService _apiService;

  UpdateProductRepositoryImpl(this._apiService);

  @override
  Future<UpdateProductResponseModel> updateProduct(
    dynamic id,
    UpdateProductRequestModel request,
  ) async {
    try {
      final url = '${ApiRoutes.updateProduct}/$id';
      final formData = await request.toFormData();
      final response = await _apiService.post(
        url,
        data: formData,
      );
      return UpdateProductResponseModel.fromJson(response);
    } on DioException catch (e) {
      String message = 'Failed to update product';
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
