import 'package:dio/dio.dart';
import '../../core/const/api_routes.dart';
import '../../core/error/failure.dart';
import '../../core/services/api_services.dart';
import '../../domain/repository/reviews_repository.dart';
import '../models/reviews_model.dart';

class ReviewsRepositoryImpl implements ReviewsRepository {
  final ApiService _apiService;

  ReviewsRepositoryImpl(this._apiService);

  @override
  Future<ReviewsResponseModel> getReviews({
    String? startDate,
    String? endDate,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null && startDate.isNotEmpty) queryParams['start_date'] = startDate;
      if (endDate != null && endDate.isNotEmpty) queryParams['end_date'] = endDate;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final response = await _apiService.get(
        ApiRoutes.reviews,
        params: queryParams.isNotEmpty ? queryParams : null,
      );
      return ReviewsResponseModel.fromJson(response);
    } on DioException catch (e) {
      String message = 'Failed to fetch reviews';
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
