import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/src/core/const/api_routes.dart';
import 'package:restaurant_app/src/data/models/status_model.dart';
import 'package:restaurant_app/src/data/models/update_status_model.dart';
import 'package:restaurant_app/src/domain/repository/status_repository.dart';
import 'package:restaurant_app/src/domain/usecase/update_status_usecase.dart';
import 'package:restaurant_app/src/presentation/controller/home_controller.dart';

class _FakeStatusRepository implements StatusRepository {
  UpdateStatusResponseModel updateStatusResponse;

  _FakeStatusRepository(this.updateStatusResponse);

  @override
  Future<StatusResponseModel> getStatus({Map<String, dynamic>? queryParams}) async {
    return StatusResponseModel(success: true, message: 'Status fetched');
  }

  @override
  Future<UpdateStatusResponseModel> updateStatus(
    UpdateStatusRequestModel request,
  ) async {
    return updateStatusResponse;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Update Status API & Domain Unit Tests', () {
    test('ApiRoutes contains updateStatus endpoints', () {
      expect(ApiRoutes.updateStatus, '/update_status');
      expect(ApiRoutes.apiKey, isNotEmpty);
    });

    test('UpdateStatusRequestModel creates valid JSON for true and false', () {
      final reqTrue = UpdateStatusRequestModel(isOnline: true);
      expect(reqTrue.toJson(), {'is_online': true});

      final reqFalse = UpdateStatusRequestModel(isOnline: false);
      expect(reqFalse.toJson(), {'is_online': false});
    });

    test('UpdateStatusResponseModel parses live success JSON correctly', () {
      final json = {
        'success': true,
        'data': {'is_online': true},
        'message': 'Restaurant status updated successfully.',
        'code': 200,
      };

      final model = UpdateStatusResponseModel.fromJson(json);
      expect(model.success, isTrue);
      expect(model.message, 'Restaurant status updated successfully.');
      expect(model.code, 200);
      expect(model.data, isNotNull);
      expect(model.data!.isOnline, isTrue);
    });

    test('UpdateStatusResponseModel parses offline status JSON correctly', () {
      final json = {
        'success': true,
        'data': {'is_online': false},
        'message': 'Restaurant status updated successfully.',
        'code': 200,
      };

      final model = UpdateStatusResponseModel.fromJson(json);
      expect(model.success, isTrue);
      expect(model.data?.isOnline, isFalse);
    });

    test('UpdateStatusUseCase delegates request to StatusRepository', () async {
      final expectedResponse = UpdateStatusResponseModel(
        success: true,
        data: UpdateStatusDataModel(isOnline: true),
        message: 'Status updated',
      );

      final fakeRepo = _FakeStatusRepository(expectedResponse);
      final useCase = UpdateStatusUseCase(fakeRepo);

      final result = await useCase(UpdateStatusRequestModel(isOnline: true));
      expect(result.success, isTrue);
      expect(result.data?.isOnline, isTrue);
    });

    test('HomeController toggles online status and updates observable', () async {
      final fakeRepo = _FakeStatusRepository(
        UpdateStatusResponseModel(
          success: true,
          data: UpdateStatusDataModel(isOnline: false),
          message: 'Restaurant status updated successfully.',
          code: 200,
        ),
      );
      final useCase = UpdateStatusUseCase(fakeRepo);
      final controller = HomeController(updateStatusUseCase: useCase);

      expect(controller.isOnline.value, isTrue);

      final newStatus = await controller.toggleOnlineStatus(false);
      expect(newStatus, isFalse);
      expect(controller.isOnline.value, isFalse);

      fakeRepo.updateStatusResponse = UpdateStatusResponseModel(
        success: true,
        data: UpdateStatusDataModel(isOnline: true),
        message: 'Restaurant status updated successfully.',
        code: 200,
      );

      final onlineStatus = await controller.toggleOnlineStatus(true);
      expect(onlineStatus, isTrue);
      expect(controller.isOnline.value, isTrue);
    });
  });
}
