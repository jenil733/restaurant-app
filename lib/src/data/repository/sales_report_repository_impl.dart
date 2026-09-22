import 'package:dio/dio.dart';
import '../../core/const/api_routes.dart';
import '../../core/error/failure.dart';
import '../../core/services/api_services.dart';
import '../../domain/repository/sales_report_repository.dart';
import '../models/sales_report_model.dart';

class SalesReportRepositoryImpl implements SalesReportRepository {
  final ApiService _apiService;

  SalesReportRepositoryImpl(this._apiService);

  @override
  Future<SalesReportResponseModel> getSalesReport({
    required String fromDate,
    required String toDate,
  }) async {
    try {
      final response = await _apiService.get(
        ApiRoutes.salesReport,
        params: {
          'from_date': fromDate,
          'to_date': toDate,
        },
      );
      return SalesReportResponseModel.fromJson(response);
    } on DioException catch (e) {
      String message = 'Failed to fetch sales report';
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
