import 'package:dio/dio.dart';
import '../../core/const/api_routes.dart';
import '../../core/error/failure.dart';
import '../../core/services/api_services.dart';
import '../../domain/repository/reply_review_repository.dart';
import '../models/reply_review_model.dart';

class ReplyReviewRepositoryImpl implements ReplyReviewRepository {
  final ApiService _apiService;

  ReplyReviewRepositoryImpl(this._apiService);

  @override
  Future<ReplyReviewResponseModel> replyReview({
    required dynamic reviewId,
    required String message,
  }) async {
    try {
      final url = '${ApiRoutes.replyReview}/$reviewId';
      final response = await _apiService.post(
        url,
        data: {'message': message},
        useFormData: true,
      );
      return ReplyReviewResponseModel.fromJson(response);
    } on DioException catch (e) {
      String msg = 'Failed to submit review reply';
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
