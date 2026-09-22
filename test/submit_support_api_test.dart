import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/src/core/const/api_routes.dart';
import 'package:restaurant_app/src/core/error/failure.dart';
import 'package:restaurant_app/src/data/models/submit_support_model.dart';
import 'package:restaurant_app/src/domain/repository/support_repository.dart';
import 'package:restaurant_app/src/domain/usecase/submit_support_usecase.dart';

class MockSupportRepository implements SupportRepository {
  bool wasCalled = false;
  SubmitSupportRequestModel? lastRequest;
  bool shouldThrow = false;
  String errorMessage = 'Error submitting support';

  @override
  Future<SubmitSupportResponseModel> submitSupport(SubmitSupportRequestModel request) async {
    wasCalled = true;
    lastRequest = request;

    if (shouldThrow) {
      throw ServerFailure(message: errorMessage);
    }

    return SubmitSupportResponseModel(
      success: true,
      message: 'Support request submitted successfully',
      code: 200,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Submit Support API & Domain Unit Tests', () {
    test('ApiRoutes contains submitSupport endpoint', () {
      expect(ApiRoutes.submitSupport, '/submit_support');
      expect(
        ApiRoutes.baseURL,
        'http://64.227.170.206/kayal.com/public/api/restaurant',
      );
    });

    test('SubmitSupportRequestModel converts to json correctly', () {
      final req = SubmitSupportRequestModel(
        title: 'Payment delay',
        description: 'Earnings for yesterday are not reflected in my wallet balance.',
      );

      final json = req.toJson();
      expect(json['title'], 'Payment delay');
      expect(json['description'], 'Earnings for yesterday are not reflected in my wallet balance.');
    });

    test('SubmitSupportResponseModel parses successful server response correctly', () {
      final json = {
        "success": true,
        "message": "Ticket generated successfully",
        "code": 200,
      };

      final response = SubmitSupportResponseModel.fromJson(json);

      expect(response.success, isTrue);
      expect(response.message, 'Ticket generated successfully');
      expect(response.code, 200);
    });

    test('SubmitSupportUseCase delegates request to SupportRepository', () async {
      final mockRepo = MockSupportRepository();
      final useCase = SubmitSupportUseCase(mockRepo);

      final request = SubmitSupportRequestModel(
        title: 'Payment delay',
        description: 'Earnings for yesterday are not reflected in my wallet balance.',
      );

      final result = await useCase(request);

      expect(mockRepo.wasCalled, isTrue);
      expect(mockRepo.lastRequest?.title, 'Payment delay');
      expect(
        mockRepo.lastRequest?.description,
        'Earnings for yesterday are not reflected in my wallet balance.',
      );
      expect(result.success, isTrue);
      expect(result.message, 'Support request submitted successfully');
    });

    test('SubmitSupportUseCase handles repository failure', () async {
      final mockRepo = MockSupportRepository()..shouldThrow = true;
      final useCase = SubmitSupportUseCase(mockRepo);

      final request = SubmitSupportRequestModel(
        title: 'Payment delay',
        description: 'Earnings for yesterday are not reflected in my wallet balance.',
      );

      expect(
        () => useCase(request),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}
