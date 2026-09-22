import 'package:dio/dio.dart';
import '../../core/const/api_routes.dart';
import '../../core/error/failure.dart';
import '../../core/services/api_services.dart';
import '../../domain/repository/order_detail_repository.dart';
import '../models/order_detail_model.dart';

class OrderDetailRepositoryImpl implements OrderDetailRepository {
  final ApiService _apiService;

  OrderDetailRepositoryImpl(this._apiService);

  @override
  Future<OrderDetailResponseModel> getOrderDetails(dynamic orderId) async {
    try {
      final url = '${ApiRoutes.orderDetails}/$orderId';
      final response = await _apiService.get(url);
      return OrderDetailResponseModel.fromJson(response);
    } on DioException catch (e) {
      String msg = 'Failed to fetch order details';
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
