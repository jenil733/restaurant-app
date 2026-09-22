import 'package:dio/dio.dart';
import '../../core/const/api_routes.dart';
import '../../core/error/failure.dart';
import '../../core/services/api_services.dart';
import '../../domain/repository/reject_order_repository.dart';
import '../models/reject_order_model.dart';

class RejectOrderRepositoryImpl implements RejectOrderRepository {
  final ApiService _apiService;

  RejectOrderRepositoryImpl(this._apiService);

  @override
  Future<RejectOrderResponseModel> rejectOrder({
    required dynamic orderId,
    required String rejectionReason,
  }) async {
    try {
      final cleanId = orderId.toString().replaceAll('#', '').trim();
      final url = '${ApiRoutes.rejectOrder}/$cleanId';
      final response = await _apiService.post(
        url,
        data: {'rejection_reason': rejectionReason},
        useFormData: true,
      );
      return RejectOrderResponseModel.fromJson(response);
    } on DioException catch (e) {
      String msg = 'Failed to reject order';
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
