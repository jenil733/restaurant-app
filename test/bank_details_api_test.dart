import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/src/core/const/api_routes.dart';
import 'package:restaurant_app/src/core/error/failure.dart';
import 'package:restaurant_app/src/data/models/update_bank_details_model.dart';
import 'package:restaurant_app/src/domain/repository/bank_details_repository.dart';
import 'package:restaurant_app/src/domain/usecase/update_bank_details_usecase.dart';

class MockBankDetailsRepository implements BankDetailsRepository {
  bool wasCalled = false;
  UpdateBankDetailsRequestModel? lastRequest;
  bool shouldThrow = false;
  String errorMessage = 'Error updating bank details';

  @override
  Future<UpdateBankDetailsResponseModel> updateBankDetails(UpdateBankDetailsRequestModel request) async {
    wasCalled = true;
    lastRequest = request;

    if (shouldThrow) {
      throw ServerFailure(message: errorMessage);
    }

    return UpdateBankDetailsResponseModel(
      success: true,
      message: 'Bank details updated',
      code: 200,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Update Bank Details API & Domain Unit Tests', () {
    test('ApiRoutes contains updateBankDetails endpoint', () {
      expect(ApiRoutes.updateBankDetails, '/update_bank_details');
      expect(
        ApiRoutes.baseURL,
        'http://64.227.170.206/kayal.com/public/api/restaurant',
      );
    });

    test('UpdateBankDetailsRequestModel creates valid JSON and FormData with required keys', () async {
      final request = UpdateBankDetailsRequestModel(
        accountHolder: 'ajay',
        bankName: 'sbi',
        accountNumber: '9876543210',
        ifsc: '98765',
        branch: 'kk',
        upiId: 'ajayupi',
      );

      final json = request.toJson();
      expect(json['account_holder'], 'ajay');
      expect(json['bank_name'], 'sbi');
      expect(json['account_number'], '9876543210');
      expect(json['ifsc'], '98765');
      expect(json['ifsc_code'], '98765');
      expect(json['branch'], 'kk');
      expect(json['branch_name'], 'kk');
      expect(json['upi_id'], 'ajayupi');

      final formData = await request.toFormData();
      expect(
        formData.fields.any((f) => f.key == 'bank_name' && f.value == 'sbi'),
        isTrue,
      );
      expect(
        formData.fields.any((f) => f.key == 'account_number' && f.value == '9876543210'),
        isTrue,
      );
      expect(
        formData.fields.any((f) => f.key == 'ifsc' && f.value == '98765'),
        isTrue,
      );
      expect(
        formData.fields.any((f) => f.key == 'branch' && f.value == 'kk'),
        isTrue,
      );
    });

    test('UpdateBankDetailsResponseModel parses success response correctly', () {
      final json = {
        "success": true,
        "data": [],
        "message": "Bank details updated",
        "code": 200,
      };

      final response = UpdateBankDetailsResponseModel.fromJson(json);
      expect(response.success, isTrue);
      expect(response.message, 'Bank details updated');
      expect(response.code, 200);
    });

    test('UpdateBankDetailsUseCase delegates request to BankDetailsRepository', () async {
      final mockRepo = MockBankDetailsRepository();
      final useCase = UpdateBankDetailsUseCase(mockRepo);

      final request = UpdateBankDetailsRequestModel(
        bankName: 'sbi',
        accountNumber: '9876543210',
        ifsc: 'SBIN0001',
        branch: 'Chennai',
      );

      final result = await useCase(request);

      expect(mockRepo.wasCalled, isTrue);
      expect(mockRepo.lastRequest?.bankName, 'sbi');
      expect(mockRepo.lastRequest?.accountNumber, '9876543210');
      expect(result.success, isTrue);
      expect(result.message, 'Bank details updated');
    });

    test('UpdateBankDetailsUseCase handles repository failure', () async {
      final mockRepo = MockBankDetailsRepository()..shouldThrow = true;
      final useCase = UpdateBankDetailsUseCase(mockRepo);

      expect(
        () => useCase(UpdateBankDetailsRequestModel(bankName: 'sbi')),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}
