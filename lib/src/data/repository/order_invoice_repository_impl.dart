import 'package:dio/dio.dart';
import '../../core/const/api_routes.dart';
import '../../core/error/failure.dart';
import '../../core/services/api_services.dart';
import '../../domain/repository/order_invoice_repository.dart';
import '../models/order_invoice_model.dart';

class OrderInvoiceRepositoryImpl implements OrderInvoiceRepository {
  final ApiService _apiService;

  OrderInvoiceRepositoryImpl(this._apiService);

  @override
  Future<OrderInvoiceResponseModel> getOrderInvoice(dynamic orderId) async {
    try {
      final cleanId = orderId.toString().replaceAll('#', '').trim();
      final url = '${ApiRoutes.orderInvoice}/$cleanId';
      final response = await _apiService.get(url);
      return OrderInvoiceResponseModel.fromJson(response);
    } on DioException catch (e) {
      String msg = 'Failed to fetch order invoice';
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
