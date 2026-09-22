import 'package:dio/dio.dart';
import '../../core/const/api_routes.dart';
import '../../core/error/failure.dart';
import '../../core/services/api_services.dart';
import '../../domain/repository/support_repository.dart';
import '../models/submit_support_model.dart';

class SupportRepositoryImpl implements SupportRepository {
  final ApiService _apiService;

  SupportRepositoryImpl(this._apiService);

  @override
  Future<SubmitSupportResponseModel> submitSupport(SubmitSupportRequestModel request) async {
    try {
      final response = await _apiService.post(
        ApiRoutes.submitSupport,
        data: request.toJson(),
        useFormData: true,
      );
      return SubmitSupportResponseModel.fromJson(response);
    } on DioException catch (e) {
      String msg = 'Failed to submit support request';
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
