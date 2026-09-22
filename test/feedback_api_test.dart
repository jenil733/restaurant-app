import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/src/core/const/api_routes.dart';
import 'package:restaurant_app/src/core/error/failure.dart';
import 'package:restaurant_app/src/data/models/feedback_model.dart';
import 'package:restaurant_app/src/domain/repository/feedback_repository.dart';
import 'package:restaurant_app/src/domain/usecase/get_feedbacks_usecase.dart';

class MockFeedbackRepository implements FeedbackRepository {
  bool wasCalled = false;
  Map<String, dynamic>? lastParams;
  bool shouldThrow = false;
  String errorMessage = 'Error fetching feedbacks';

  @override
  Future<FeedbackResponseModel> getFeedbacks({Map<String, dynamic>? queryParams}) async {
    wasCalled = true;
    lastParams = queryParams;

    if (shouldThrow) {
      throw ServerFailure(message: errorMessage);
    }

    return FeedbackResponseModel(
      success: true,
      message: 'Request successful',
      data: FeedbackDataModel(
        feedbacks: [
          FeedbackItemModel(
            id: 1,
            name: 'David Wilson',
            rating: 5,
            review: 'Excellent food and super fast delivery!',
            time: '2 hrs ago',
          ),
          FeedbackItemModel(
            id: 2,
            name: 'Sophia',
            rating: 4,
            review: 'Great taste and nice packaging.',
            time: 'Yesterday',
          ),
        ],
        totalFeedbacks: 2,
        averageRating: 4.5,
      ),
      code: 200,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Feedbacks API & Domain Unit Tests', () {
    test('ApiRoutes contains feedbacks endpoint', () {
      expect(ApiRoutes.feedbacks, '/feedbacks');
      expect(
        ApiRoutes.baseURL,
        'http://64.227.170.206/kayal.com/public/api/restaurant',
      );
    });

    test('FeedbackResponseModel parses live server empty feedback response correctly', () {
      final json = {
        "success": true,
        "data": {
          "feedbacks": [],
        },
        "message": "Request successful",
        "code": 200
      };

      final response = FeedbackResponseModel.fromJson(json);

      expect(response.success, isTrue);
      expect(response.message, 'Request successful');
      expect(response.data, isNotNull);
      expect(response.data?.feedbacks, isEmpty);
      expect(response.data?.totalFeedbacks, 0);
    });

    test('FeedbackResponseModel parses populated feedback data correctly', () {
      final json = {
        "success": true,
        "data": {
          "feedbacks": [
            {
              "id": 10,
              "customer_name": "Ajay Kumar",
              "rating": 5,
              "comment": "Authentic and fresh cuisine!",
              "created_at": "1 hour ago",
              "image": "https://example.com/avatar.jpg"
            }
          ],
          "total_feedbacks": 1,
          "average_rating": 5.0
        },
        "message": "Request successful",
        "code": 200
      };

      final response = FeedbackResponseModel.fromJson(json);

      expect(response.success, isTrue);
      expect(response.data?.feedbacks.length, 1);

      final item = response.data!.feedbacks.first;
      expect(item.name, 'Ajay Kumar');
      expect(item.rating, 5.0);
      expect(item.review, 'Authentic and fresh cuisine!');
      expect(item.time, '1 hour ago');
      expect(item.image, 'https://example.com/avatar.jpg');
    });

    test('GetFeedbacksUseCase delegates request to FeedbackRepository', () async {
      final mockRepo = MockFeedbackRepository();
      final useCase = GetFeedbacksUseCase(mockRepo);

      final result = await useCase();

      expect(mockRepo.wasCalled, isTrue);
      expect(result.success, isTrue);
      expect(result.data?.totalFeedbacks, 2);
      expect(result.data?.feedbacks.first.name, 'David Wilson');
    });

    test('GetFeedbacksUseCase handles repository failure', () async {
      final mockRepo = MockFeedbackRepository()..shouldThrow = true;
      final useCase = GetFeedbacksUseCase(mockRepo);

      expect(
        () => useCase(),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}
