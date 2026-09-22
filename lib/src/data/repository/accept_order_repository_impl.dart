import 'package:dio/dio.dart';
import '../../core/const/api_routes.dart';
import '../../core/error/failure.dart';
import '../../core/services/api_services.dart';
import '../../domain/repository/accept_order_repository.dart';
import '../models/accept_order_model.dart';

class AcceptOrderRepositoryImpl implements AcceptOrderRepository {
  final ApiService _apiService;

  AcceptOrderRepositoryImpl(this._apiService);

  @override
  Future<AcceptOrderResponseModel> acceptOrder(dynamic orderId) async {
    try {
      final cleanId = orderId.toString().replaceAll('#', '').trim();
      final url = '${ApiRoutes.acceptOrder}/$cleanId';
      final response = await _apiService.post(url);
      return AcceptOrderResponseModel.fromJson(response);
    } on DioException catch (e) {
      String msg = 'Failed to accept order';
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
