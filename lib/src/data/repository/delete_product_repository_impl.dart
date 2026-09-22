import 'package:dio/dio.dart';
import '../../core/const/api_routes.dart';
import '../../core/error/failure.dart';
import '../../core/services/api_services.dart';
import '../../domain/repository/delete_product_repository.dart';
import '../models/delete_product_model.dart';

class DeleteProductRepositoryImpl implements DeleteProductRepository {
  final ApiService _apiService;

  DeleteProductRepositoryImpl(this._apiService);

  @override
  Future<DeleteProductResponseModel> deleteProduct(DeleteProductRequestModel request) async {
    try {
      final url = '${ApiRoutes.deleteProduct}/${request.id}';
      final response = await _apiService.post(url);
      return DeleteProductResponseModel.fromJson(response);
    } on DioException catch (e) {
      String message = 'Failed to delete product';
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
