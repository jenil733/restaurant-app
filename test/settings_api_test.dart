import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/src/core/const/api_routes.dart';
import 'package:restaurant_app/src/core/error/failure.dart';
import 'package:restaurant_app/src/data/models/update_settings_model.dart';
import 'package:restaurant_app/src/domain/repository/settings_repository.dart';
import 'package:restaurant_app/src/domain/usecase/update_settings_usecase.dart';

class MockSettingsRepository implements SettingsRepository {
  bool wasCalled = false;
  UpdateSettingsRequestModel? lastRequest;
  bool shouldThrow = false;
  String errorMessage = 'Error updating settings';

  @override
  Future<UpdateSettingsResponseModel> updateSettings(UpdateSettingsRequestModel request) async {
    wasCalled = true;
    lastRequest = request;

    if (shouldThrow) {
      throw ServerFailure(message: errorMessage);
    }

    return UpdateSettingsResponseModel(
      success: true,
      message: 'Settings saved',
      notificationsEnabled: request.notificationsEnabled,
      code: 200,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Update Settings API & Domain Unit Tests', () {
    test('ApiRoutes contains updateSettings endpoint', () {
      expect(ApiRoutes.updateSettings, '/update_settings');
      expect(
        ApiRoutes.baseURL,
        'http://64.227.170.206/kayal.com/public/api/restaurant',
      );
    });

    test('UpdateSettingsRequestModel creates valid JSON and FormData for enabled', () async {
      final request = UpdateSettingsRequestModel(notificationsEnabled: true);
      final json = request.toJson();
      expect(json['notifications_enabled'], '1');

      final formData = await request.toFormData();
      expect(
        formData.fields.any((f) => f.key == 'notifications_enabled' && f.value == '1'),
        isTrue,
      );
    });

    test('UpdateSettingsRequestModel creates valid JSON and FormData for disabled', () async {
      final request = UpdateSettingsRequestModel(notificationsEnabled: false);
      final json = request.toJson();
      expect(json['notifications_enabled'], '0');

      final formData = await request.toFormData();
      expect(
        formData.fields.any((f) => f.key == 'notifications_enabled' && f.value == '0'),
        isTrue,
      );
    });

    test('UpdateSettingsResponseModel parses server response correctly', () {
      final json = {
        "success": true,
        "data": {
          "notifications_enabled": true,
        },
        "message": "Settings saved",
        "code": 200,
      };

      final response = UpdateSettingsResponseModel.fromJson(json);
      expect(response.success, isTrue);
      expect(response.message, 'Settings saved');
      expect(response.notificationsEnabled, isTrue);
      expect(response.code, 200);
    });

    test('UpdateSettingsResponseModel parses boolean false and string status', () {
      final json = {
        "status": 200,
        "data": {
          "notifications_enabled": false,
        },
        "message": "Settings updated",
      };

      final response = UpdateSettingsResponseModel.fromJson(json);
      expect(response.success, isTrue);
      expect(response.notificationsEnabled, isFalse);
    });

    test('UpdateSettingsUseCase delegates request to SettingsRepository', () async {
      final mockRepo = MockSettingsRepository();
      final useCase = UpdateSettingsUseCase(mockRepo);

      final request = UpdateSettingsRequestModel(notificationsEnabled: true);
      final result = await useCase(request);

      expect(mockRepo.wasCalled, isTrue);
      expect(mockRepo.lastRequest?.notificationsEnabled, isTrue);
      expect(result.success, isTrue);
      expect(result.notificationsEnabled, isTrue);
      expect(result.message, 'Settings saved');
    });

    test('UpdateSettingsUseCase handles repository failure', () async {
      final mockRepo = MockSettingsRepository()..shouldThrow = true;
      final useCase = UpdateSettingsUseCase(mockRepo);

      expect(
        () => useCase(UpdateSettingsRequestModel(notificationsEnabled: false)),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}
