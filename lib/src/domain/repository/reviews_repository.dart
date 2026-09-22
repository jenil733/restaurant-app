import '../../data/models/reviews_model.dart';

abstract class ReviewsRepository {
  Future<ReviewsResponseModel> getReviews({
    String? startDate,
    String? endDate,
    String? search,
  });
}
