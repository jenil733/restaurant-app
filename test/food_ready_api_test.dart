import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/src/core/const/api_routes.dart';
import 'package:restaurant_app/src/core/error/failure.dart';
import 'package:restaurant_app/src/data/models/food_ready_model.dart';
import 'package:restaurant_app/src/domain/repository/food_ready_repository.dart';
import 'package:restaurant_app/src/domain/usecase/food_ready_usecase.dart';

class MockFoodReadyRepository implements FoodReadyRepository {
  bool wasCalled = false;
  dynamic lastOrderId;
  bool shouldThrow = false;
  String errorMessage = 'Error updating food ready status';

  @override
  Future<FoodReadyResponseModel> markFoodReady(dynamic orderId) async {
    wasCalled = true;
    lastOrderId = orderId;

    if (shouldThrow) {
      throw ServerFailure(message: errorMessage);
    }

    return FoodReadyResponseModel(
      success: true,
      message: 'Food marked as ready successfully',
      code: 200,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Post Status Food Ready API & Domain Unit Tests', () {
    test('ApiRoutes contains foodReady endpoint', () {
      expect(ApiRoutes.foodReady, '/food_ready');
      expect(
        ApiRoutes.baseURL,
        'http://64.227.170.206/kayal.com/public/api/restaurant',
      );
    });

    test('FoodReadyResponseModel parses server response correctly', () {
      final json = {
        "success": true,
        "message": "Food marked as ready successfully",
        "code": 200
      };

      final response = FoodReadyResponseModel.fromJson(json);

      expect(response.success, isTrue);
      expect(response.message, 'Food marked as ready successfully');
      expect(response.code, 200);
    });

    test('FoodReadyResponseModel parses alternative status format', () {
      final json = {
        "status": "success",
        "message": "Status updated",
        "data": {"order_id": 1, "status": "food_ready"}
      };

      final response = FoodReadyResponseModel.fromJson(json);

      expect(response.success, isTrue);
      expect(response.message, 'Status updated');
      expect(response.data, isNotNull);
    });

    test('FoodReadyUseCase delegates order ID to FoodReadyRepository', () async {
      final mockRepo = MockFoodReadyRepository();
      final useCase = FoodReadyUseCase(mockRepo);

      final result = await useCase(1);

      expect(mockRepo.wasCalled, isTrue);
      expect(mockRepo.lastOrderId, 1);
      expect(result.success, isTrue);
      expect(result.message, 'Food marked as ready successfully');
    });

    test('FoodReadyUseCase handles repository failure', () async {
      final mockRepo = MockFoodReadyRepository()..shouldThrow = true;
      final useCase = FoodReadyUseCase(mockRepo);

      expect(
        () => useCase(1),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}
