import '../../data/models/feedback_model.dart';

abstract class FeedbackRepository {
  Future<FeedbackResponseModel> getFeedbacks({Map<String, dynamic>? queryParams});
}
