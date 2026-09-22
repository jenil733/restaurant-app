import 'package:dio/dio.dart';
import '../../core/const/api_routes.dart';
import '../../core/error/failure.dart';
import '../../core/services/api_services.dart';
import '../../domain/repository/update_status_repository.dart';
import '../models/update_status_model.dart';

class UpdateStatusRepositoryImpl implements UpdateStatusRepository {
  final ApiService _apiService;

  UpdateStatusRepositoryImpl(this._apiService);

  @override
  Future<UpdateStatusResponseModel> updateStatus(UpdateStatusRequestModel request) async {
    try {
      final response = await _apiService.patch(
        ApiRoutes.updateStatus,
        data: request.toJson(),
      );
      return UpdateStatusResponseModel.fromJson(response);
    } on DioException catch (e) {
      String message = 'Failed to update status';
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
