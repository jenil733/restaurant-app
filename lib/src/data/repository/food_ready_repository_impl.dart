import 'package:dio/dio.dart';
import '../../core/const/api_routes.dart';
import '../../core/error/failure.dart';
import '../../core/services/api_services.dart';
import '../../domain/repository/food_ready_repository.dart';
import '../models/food_ready_model.dart';

class FoodReadyRepositoryImpl implements FoodReadyRepository {
  final ApiService _apiService;

  FoodReadyRepositoryImpl(this._apiService);

  @override
  Future<FoodReadyResponseModel> markFoodReady(dynamic orderId) async {
    try {
      final cleanId = orderId.toString().replaceAll('#', '').trim();
      final url = '${ApiRoutes.foodReady}/$cleanId';
      final response = await _apiService.post(url);
      return FoodReadyResponseModel.fromJson(response);
    } on DioException catch (e) {
      String msg = 'Failed to update food ready status';
      if (e.response?.data is Map) {
        final data = e.response!.data as Map;
        if (data['message'] != null) {
          msg = data['message'].toString();
        }
      }
      throw ServerFailure(message: msg);
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(message: e.toString());
    }
  }
}
