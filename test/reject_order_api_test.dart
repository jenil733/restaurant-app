import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/src/core/const/api_routes.dart';
import 'package:restaurant_app/src/core/error/failure.dart';
import 'package:restaurant_app/src/data/models/reject_order_model.dart';
import 'package:restaurant_app/src/domain/repository/reject_order_repository.dart';
import 'package:restaurant_app/src/domain/usecase/reject_order_usecase.dart';

class MockRejectOrderRepository implements RejectOrderRepository {
  bool wasCalled = false;
  dynamic lastOrderId;
  String? lastReason;
  bool shouldThrow = false;
  String errorMessage = 'Error rejecting order';

  @override
  Future<RejectOrderResponseModel> rejectOrder({
    required dynamic orderId,
    required String rejectionReason,
  }) async {
    wasCalled = true;
    lastOrderId = orderId;
    lastReason = rejectionReason;

    if (shouldThrow) {
      throw ServerFailure(message: errorMessage);
    }

    return RejectOrderResponseModel(
      success: true,
      message: 'Order rejected successfully',
      code: 200,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Post Reject Order API & Domain Unit Tests', () {
    test('ApiRoutes contains rejectOrder endpoint', () {
      expect(ApiRoutes.rejectOrder, '/reject_order');
      expect(
        ApiRoutes.baseURL,
        'http://64.227.170.206/kayal.com/public/api/restaurant',
      );
    });

    test('RejectOrderResponseModel parses server response correctly', () {
      final json = {
        "success": true,
        "message": "Order rejected successfully",
        "code": 200
      };

      final response = RejectOrderResponseModel.fromJson(json);

      expect(response.success, isTrue);
      expect(response.message, 'Order rejected successfully');
      expect(response.code, 200);
    });

    test('RejectOrderResponseModel parses alternative status format', () {
      final json = {
        "status": "success",
        "message": "Order rejected",
        "data": {"order_id": 2, "rejection_reason": "Out of stock"}
      };

      final response = RejectOrderResponseModel.fromJson(json);

      expect(response.success, isTrue);
      expect(response.message, 'Order rejected');
      expect(response.data, isNotNull);
    });

    test('RejectOrderUseCase delegates order ID and reason to RejectOrderRepository', () async {
      final mockRepo = MockRejectOrderRepository();
      final useCase = RejectOrderUseCase(mockRepo);

      final result = await useCase(
        orderId: 2,
        rejectionReason: 'Kitchen closed',
      );

      expect(mockRepo.wasCalled, isTrue);
      expect(mockRepo.lastOrderId, 2);
      expect(mockRepo.lastReason, 'Kitchen closed');
      expect(result.success, isTrue);
      expect(result.message, 'Order rejected successfully');
    });

    test('RejectOrderUseCase handles repository failure', () async {
      final mockRepo = MockRejectOrderRepository()..shouldThrow = true;
      final useCase = RejectOrderUseCase(mockRepo);

      expect(
        () => useCase(orderId: 2, rejectionReason: 'Kitchen closed'),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}
