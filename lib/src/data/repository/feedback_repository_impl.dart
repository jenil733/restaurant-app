import 'package:dio/dio.dart';
import '../../core/const/api_routes.dart';
import '../../core/error/failure.dart';
import '../../core/services/api_services.dart';
import '../../domain/repository/feedback_repository.dart';
import '../models/feedback_model.dart';

class FeedbackRepositoryImpl implements FeedbackRepository {
  final ApiService _apiService;

  FeedbackRepositoryImpl(this._apiService);

  @override
  Future<FeedbackResponseModel> getFeedbacks({Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _apiService.get(
        ApiRoutes.feedbacks,
        params: queryParams,
      );
      return FeedbackResponseModel.fromJson(response);
    } on DioException catch (e) {
      String message = 'Failed to fetch feedbacks';
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
