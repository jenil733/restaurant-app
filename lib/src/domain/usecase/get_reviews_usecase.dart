import '../../data/models/reviews_model.dart';
import '../repository/reviews_repository.dart';

class GetReviewsUseCase {
  final ReviewsRepository _repository;

  GetReviewsUseCase(this._repository);

  Future<ReviewsResponseModel> call({
    String? startDate,
    String? endDate,
    String? search,
  }) {
    return _repository.getReviews(
      startDate: startDate,
      endDate: endDate,
      search: search,
    );
  }
}
