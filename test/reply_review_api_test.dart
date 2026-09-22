import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/src/core/const/api_routes.dart';
import 'package:restaurant_app/src/core/error/failure.dart';
import 'package:restaurant_app/src/data/models/reply_review_model.dart';
import 'package:restaurant_app/src/domain/repository/reply_review_repository.dart';
import 'package:restaurant_app/src/domain/usecase/reply_review_usecase.dart';

class MockReplyReviewRepository implements ReplyReviewRepository {
  bool wasCalled = false;
  dynamic lastReviewId;
  String? lastMessage;
  bool shouldThrow = false;
  String errorMessage = 'Error sending reply';

  @override
  Future<ReplyReviewResponseModel> replyReview({
    required dynamic reviewId,
    required String message,
  }) async {
    wasCalled = true;
    lastReviewId = reviewId;
    lastMessage = message;

    if (shouldThrow) {
      throw ServerFailure(message: errorMessage);
    }

    return ReplyReviewResponseModel(
      success: true,
      message: 'Reply submitted successfully',
      code: 200,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Reply Review API & Domain Unit Tests', () {
    test('ApiRoutes contains replyReview endpoint', () {
      expect(ApiRoutes.replyReview, '/reply_review');
      expect(
        ApiRoutes.baseURL,
        'http://64.227.170.206/kayal.com/public/api/restaurant',
      );
    });

    test('ReplyReviewRequestModel converts to json correctly', () {
      final req = ReplyReviewRequestModel(
        reviewId: 1,
        message: 'thanks a lot',
      );

      final json = req.toJson();
      expect(json['message'], 'thanks a lot');
    });

    test('ReplyReviewResponseModel parses successful server response correctly', () {
      final json = {
        "success": true,
        "message": "Reply added successfully",
        "code": 200,
      };

      final response = ReplyReviewResponseModel.fromJson(json);

      expect(response.success, isTrue);
      expect(response.message, 'Reply added successfully');
      expect(response.code, 200);
    });

    test('ReplyReviewUseCase delegates request to ReplyReviewRepository', () async {
      final mockRepo = MockReplyReviewRepository();
      final useCase = ReplyReviewUseCase(mockRepo);

      final result = await useCase(
        reviewId: 1,
        message: 'thanks a lot',
      );

      expect(mockRepo.wasCalled, isTrue);
      expect(mockRepo.lastReviewId, 1);
      expect(mockRepo.lastMessage, 'thanks a lot');
      expect(result.success, isTrue);
      expect(result.message, 'Reply submitted successfully');
    });

    test('ReplyReviewUseCase handles repository failure', () async {
      final mockRepo = MockReplyReviewRepository()..shouldThrow = true;
      final useCase = ReplyReviewUseCase(mockRepo);

      expect(
        () => useCase(reviewId: 1, message: 'thanks a lot'),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}
