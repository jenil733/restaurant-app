import 'package:dio/dio.dart';
import '../../core/const/api_routes.dart';
import '../../core/error/failure.dart';
import '../../core/services/api_services.dart';
import '../../domain/repository/order_repository.dart';
import '../models/orders_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final ApiService _apiService;

  OrderRepositoryImpl(this._apiService);

  @override
  Future<OrdersResponseModel> getOrders({
    String? status,
    int? page,
    int? limit,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null && status.isNotEmpty) queryParams['status'] = status;
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final response = await _apiService.get(
        ApiRoutes.orders,
        params: queryParams.isNotEmpty ? queryParams : null,
      );
      return OrdersResponseModel.fromJson(response);
    } on DioException catch (e) {
      String msg = 'Failed to fetch orders';
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
