import 'package:dio/dio.dart';
import '../../core/const/api_routes.dart';
import '../../core/error/failure.dart';
import '../../core/services/api_services.dart';
import '../../domain/repository/recent_orders_repository.dart';
import '../models/recent_orders_model.dart';

class RecentOrdersRepositoryImpl implements RecentOrdersRepository {
  final ApiService _apiService;

  RecentOrdersRepositoryImpl(this._apiService);

  @override
  Future<RecentOrdersResponseModel> getRecentOrders() async {
    try {
      final response = await _apiService.get(ApiRoutes.recentOrders);
      return RecentOrdersResponseModel.fromJson(response);
    } on DioException catch (e) {
      String msg = 'Failed to fetch recent orders';
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
