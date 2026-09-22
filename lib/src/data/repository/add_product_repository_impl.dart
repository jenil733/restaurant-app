import 'package:dio/dio.dart';
import '../../core/const/api_routes.dart';
import '../../core/error/failure.dart';
import '../../core/services/api_services.dart';
import '../../domain/repository/add_product_repository.dart';
import '../models/add_product_model.dart';

class AddProductRepositoryImpl implements AddProductRepository {
  final ApiService _apiService;

  AddProductRepositoryImpl(this._apiService);

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
      String message = 'Failed to add product';
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
