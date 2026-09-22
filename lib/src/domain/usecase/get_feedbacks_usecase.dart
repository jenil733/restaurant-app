import '../../data/models/feedback_model.dart';
import '../repository/feedback_repository.dart';

class GetFeedbacksUseCase {
  final FeedbackRepository _repository;

  GetFeedbacksUseCase(this._repository);

  Future<FeedbackResponseModel> call({Map<String, dynamic>? queryParams}) {
    return _repository.getFeedbacks(queryParams: queryParams);
  }
}
