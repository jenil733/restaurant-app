import '../../data/models/reply_review_model.dart';

abstract class ReplyReviewRepository {
  Future<ReplyReviewResponseModel> replyReview({
    required dynamic reviewId,
    required String message,
  });
}
