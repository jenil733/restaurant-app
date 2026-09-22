import '../../data/models/reply_review_model.dart';
import '../repository/reply_review_repository.dart';

class ReplyReviewUseCase {
  final ReplyReviewRepository _repository;

  ReplyReviewUseCase(this._repository);

  Future<ReplyReviewResponseModel> call({
    required dynamic reviewId,
    required String message,
  }) {
    return _repository.replyReview(
      reviewId: reviewId,
      message: message,
    );
  }
}
