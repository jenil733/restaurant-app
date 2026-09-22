import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/src/core/const/api_routes.dart';
import 'package:restaurant_app/src/core/error/failure.dart';
import 'package:restaurant_app/src/data/models/reviews_model.dart';
import 'package:restaurant_app/src/domain/repository/reviews_repository.dart';
import 'package:restaurant_app/src/domain/usecase/get_reviews_usecase.dart';

class MockReviewsRepository implements ReviewsRepository {
  bool wasCalled = false;
  String? lastStartDate;
  String? lastEndDate;
  String? lastSearch;
  bool shouldThrow = false;
  String errorMessage = 'Error fetching reviews';

  @override
  Future<ReviewsResponseModel> getReviews({
    String? startDate,
    String? endDate,
    String? search,
  }) async {
    wasCalled = true;
    lastStartDate = startDate;
    lastEndDate = endDate;
    lastSearch = search;

    if (shouldThrow) {
      throw ServerFailure(message: errorMessage);
    }

    return ReviewsResponseModel(
      success: true,
      message: 'Request successful',
      data: ReviewsDataModel(
        averageRating: 4.8,
        totalFeedbacks: 2,
        reviews: [
          ReviewItemModel(
            id: 1,
            name: 'David Wilson',
            image: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=200',
            rating: 5,
            review: 'Excellent service. The booking process was smooth and simple.',
            time: '2 hrs ago',
            reply: 'Thank you for your review!',
          ),
          ReviewItemModel(
            id: 2,
            name: 'John Miller',
            image: 'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=200',
            rating: 4,
            review: 'Food quality was amazing. Delivery was on time.',
            time: '5 hrs ago',
          ),
        ],
      ),
      code: 200,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Reviews API & Domain Unit Tests', () {
    test('ApiRoutes contains reviews endpoint', () {
      expect(ApiRoutes.reviews, '/reviews');
      expect(
        ApiRoutes.baseURL,
        'http://64.227.170.206/kayal.com/public/api/restaurant',
      );
    });

    test('ReviewsResponseModel parses live server empty reviews response correctly', () {
      final json = {
        "success": true,
        "data": {
          "average_rating": 0,
          "total_feedbacks": 0,
          "reviews": []
        },
        "message": "Request successful",
        "code": 200
      };

      final response = ReviewsResponseModel.fromJson(json);

      expect(response.success, isTrue);
      expect(response.message, 'Request successful');
      expect(response.data, isNotNull);
      expect(response.data?.reviews, isEmpty);
      expect(response.data?.totalFeedbacks, 0);
      expect(response.data?.averageRating, 0.0);
    });

    test('ReviewsResponseModel parses populated review data correctly', () {
      final json = {
        "success": true,
        "data": {
          "average_rating": 4.8,
          "total_feedbacks": 248,
          "reviews": [
            {
              "id": 101,
              "name": "Sarah Connor",
              "rating": 5,
              "time": "10 mins ago",
              "review": "Best biryani in the town!",
              "image": "https://example.com/avatar.jpg",
              "reply": "Thank you Sarah!"
            }
          ]
        },
        "message": "Request successful",
        "code": 200
      };

      final response = ReviewsResponseModel.fromJson(json);

      expect(response.success, isTrue);
      expect(response.data?.totalFeedbacks, 248);
      expect(response.data?.averageRating, 4.8);
      expect(response.data?.reviews.length, 1);

      final item = response.data!.reviews.first;
      expect(item.id, 101);
      expect(item.name, 'Sarah Connor');
      expect(item.rating, 5.0);
      expect(item.review, 'Best biryani in the town!');
      expect(item.time, '10 mins ago');
      expect(item.image, 'https://example.com/avatar.jpg');
      expect(item.reply, 'Thank you Sarah!');
    });

    test('GetReviewsUseCase delegates request with parameters to ReviewsRepository', () async {
      final mockRepo = MockReviewsRepository();
      final useCase = GetReviewsUseCase(mockRepo);

      final result = await useCase(
        startDate: '2026-09-01',
        endDate: '2026-09-20',
        search: 'David',
      );

      expect(mockRepo.wasCalled, isTrue);
      expect(mockRepo.lastStartDate, '2026-09-01');
      expect(mockRepo.lastEndDate, '2026-09-20');
      expect(mockRepo.lastSearch, 'David');

      expect(result.success, isTrue);
      expect(result.data?.totalFeedbacks, 2);
      expect(result.data?.averageRating, 4.8);
      expect(result.data?.reviews.first.name, 'David Wilson');
    });

    test('GetReviewsUseCase handles repository failure', () async {
      final mockRepo = MockReviewsRepository()..shouldThrow = true;
      final useCase = GetReviewsUseCase(mockRepo);

      expect(
        () => useCase(),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}
