import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/src/core/const/api_routes.dart';
import 'package:restaurant_app/src/core/error/failure.dart';
import 'package:restaurant_app/src/data/models/logout_model.dart';
import 'package:restaurant_app/src/domain/repository/auth_repository.dart';
import 'package:restaurant_app/src/domain/usecase/logout_usecase.dart';

class MockAuthRepository implements AuthRepository {
  bool wasCalled = false;
  bool shouldThrow = false;
  String errorMessage = 'Logout failed';

  @override
  Future<LogoutResponseModel> logout() async {
    wasCalled = true;

    if (shouldThrow) {
      throw ServerFailure(message: errorMessage);
    }

    return LogoutResponseModel(
      success: true,
      message: 'Successfully logged out',
      data: {},
      code: 200,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Restaurant Logout API Unit Tests', () {
    test('ApiRoutes contains logout endpoint and base configuration', () {
      expect(ApiRoutes.logout, '/logout');
      expect(
        ApiRoutes.baseURL,
        'http://64.227.170.206/kayal.com/public/api/restaurant',
      );
      expect(
        ApiRoutes.apiKey,
        'sdfghjkcvbnfghjkcvbnmdfghjdfvgbncvbn',
      );
    });

    test('LogoutResponseModel parses JSON response correctly', () {
      final json = {
        'status': true,
        'message': 'Successfully logged out',
        'data': {},
        'code': 200,
      };

      final response = LogoutResponseModel.fromJson(json);

      expect(response.success, isTrue);
      expect(response.message, 'Successfully logged out');
      expect(response.code, 200);

      final map = response.toJson();
      expect(map['status'], isTrue);
      expect(map['message'], 'Successfully logged out');
    });

    test('LogoutResponseModel handles string boolean and error values', () {
      final json = {
        'status': 'false',
        'message': 'Unauthenticated',
        'code': 401,
      };

      final response = LogoutResponseModel.fromJson(json);
      expect(response.success, isFalse);
      expect(response.message, 'Unauthenticated');
      expect(response.code, 401);
    });

    test('LogoutUseCase delegates request to AuthRepository', () async {
      final mockRepo = MockAuthRepository();
      final useCase = LogoutUseCase(mockRepo);

      final result = await useCase();

      expect(mockRepo.wasCalled, isTrue);
      expect(result.success, isTrue);
      expect(result.message, 'Successfully logged out');
    });

    test('LogoutUseCase propagates repository failures', () async {
      final mockRepo = MockAuthRepository()..shouldThrow = true;
      final useCase = LogoutUseCase(mockRepo);

      expect(
        () => useCase(),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}
