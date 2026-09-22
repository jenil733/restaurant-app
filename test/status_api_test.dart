import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/src/core/const/api_routes.dart';
import 'package:restaurant_app/src/core/error/failure.dart';
import 'package:restaurant_app/src/data/models/status_model.dart';
import 'package:restaurant_app/src/domain/repository/status_repository.dart';
import 'package:restaurant_app/src/domain/usecase/get_status_usecase.dart';

import 'package:restaurant_app/src/data/models/update_status_model.dart';

class MockStatusRepository implements StatusRepository {
  bool wasCalled = false;
  Map<String, dynamic>? lastParams;
  bool shouldThrow = false;
  String errorMessage = 'Error fetching status';

  @override
  Future<StatusResponseModel> getStatus({
    Map<String, dynamic>? queryParams,
  }) async {
    wasCalled = true;
    lastParams = queryParams;

    if (shouldThrow) {
      throw ServerFailure(message: errorMessage);
    }

    return StatusResponseModel(
      success: true,
      message: 'Status fetched successfully',
      data: {'status': 'active', 'server': 'online'},
      code: 200,
    );
  }

  @override
  Future<UpdateStatusResponseModel> updateStatus(
    UpdateStatusRequestModel request,
  ) async {
    if (shouldThrow) {
      throw ServerFailure(message: errorMessage);
    }

    return UpdateStatusResponseModel(
      success: true,
      data: UpdateStatusDataModel(isOnline: request.isOnline),
      message: 'Restaurant status updated successfully.',
      code: 200,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Status API Unit Tests', () {
    test('ApiRoutes contains status endpoint and base configuration', () {
      expect(ApiRoutes.status, '/status');
      expect(
        ApiRoutes.baseURL,
        'http://64.227.170.206/kayal.com/public/api/restaurant',
      );
      expect(
        ApiRoutes.apiKey,
        'sdfghjkcvbnfghjkcvbnmdfghjdfvgbncvbn',
      );
    });

    test('StatusResponseModel parses JSON response correctly', () {
      final json = {
        'status': true,
        'message': 'Service is active',
        'data': {'online': true, 'version': '1.0.0'},
        'code': 200,
      };

      final response = StatusResponseModel.fromJson(json);

      expect(response.success, isTrue);
      expect(response.message, 'Service is active');
      expect(response.data, {'online': true, 'version': '1.0.0'});
      expect(response.code, 200);

      final map = response.toJson();
      expect(map['status'], isTrue);
      expect(map['message'], 'Service is active');
    });

    test('StatusResponseModel handles alternative success and error values', () {
      final json = {
        'success': 'true',
        'message': 'OK',
      };

      final response = StatusResponseModel.fromJson(json);
      expect(response.success, isTrue);
      expect(response.message, 'OK');
    });

    test('GetStatusUseCase delegates request to StatusRepository', () async {
      final mockRepo = MockStatusRepository();
      final useCase = GetStatusUseCase(mockRepo);

      final result = await useCase(queryParams: {'type': 'restaurant'});

      expect(mockRepo.wasCalled, isTrue);
      expect(mockRepo.lastParams, {'type': 'restaurant'});
      expect(result.success, isTrue);
      expect(result.message, 'Status fetched successfully');
      expect(result.data['status'], 'active');
    });

    test('GetStatusUseCase handles repository failure', () async {
      final mockRepo = MockStatusRepository()..shouldThrow = true;
      final useCase = GetStatusUseCase(mockRepo);

      expect(
        () => useCase(),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}
