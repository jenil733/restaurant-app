import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/src/core/const/api_routes.dart';
import 'package:restaurant_app/src/core/error/failure.dart';
import 'package:restaurant_app/src/data/models/accept_order_model.dart';
import 'package:restaurant_app/src/domain/repository/accept_order_repository.dart';
import 'package:restaurant_app/src/domain/usecase/accept_order_usecase.dart';

class MockAcceptOrderRepository implements AcceptOrderRepository {
  bool wasCalled = false;
  dynamic lastOrderId;
  bool shouldThrow = false;
  String errorMessage = 'Error accepting order';

  @override
  Future<AcceptOrderResponseModel> acceptOrder(dynamic orderId) async {
    wasCalled = true;
    lastOrderId = orderId;

    if (shouldThrow) {
      throw ServerFailure(message: errorMessage);
    }

    return AcceptOrderResponseModel(
      success: true,
      message: 'Order accepted successfully',
      code: 200,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Post Accept Order API & Domain Unit Tests', () {
    test('ApiRoutes contains acceptOrder endpoint', () {
      expect(ApiRoutes.acceptOrder, '/accept_order');
      expect(
        ApiRoutes.baseURL,
        'http://64.227.170.206/kayal.com/public/api/restaurant',
      );
    });

    test('AcceptOrderResponseModel parses server response correctly', () {
      final json = {
        "success": true,
        "message": "Order accepted successfully",
        "code": 200
      };

      final response = AcceptOrderResponseModel.fromJson(json);

      expect(response.success, isTrue);
      expect(response.message, 'Order accepted successfully');
      expect(response.code, 200);
    });

    test('AcceptOrderUseCase delegates order ID to AcceptOrderRepository', () async {
      final mockRepo = MockAcceptOrderRepository();
      final useCase = AcceptOrderUseCase(mockRepo);

      final result = await useCase(1);

      expect(mockRepo.wasCalled, isTrue);
      expect(mockRepo.lastOrderId, 1);
      expect(result.success, isTrue);
      expect(result.message, 'Order accepted successfully');
    });

    test('AcceptOrderUseCase handles repository failure', () async {
      final mockRepo = MockAcceptOrderRepository()..shouldThrow = true;
      final useCase = AcceptOrderUseCase(mockRepo);

      expect(
        () => useCase(1),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}
