import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/src/core/const/api_routes.dart';
import 'package:restaurant_app/src/data/models/register_model.dart';
import 'package:restaurant_app/src/domain/repository/register_repository.dart';
import 'package:restaurant_app/src/domain/usecase/register_usecase.dart';
import 'package:restaurant_app/src/presentation/controller/auth/sign_in_controller.dart';

class MockRegisterRepository implements RegisterRepository {
  bool wasCalled = false;
  RegisterRequestModel? lastRequest;

  @override
  Future<RegisterResponseModel> register(RegisterRequestModel request) async {
    wasCalled = true;
    lastRequest = request;
    return RegisterResponseModel(
      success: true,
      message: 'Registration successful',
      data: {'user_id': 101},
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Register API & Auth Unit Tests', () {
    test('ApiRoutes contains register endpoint', () {
      expect(ApiRoutes.register, '/register');
      expect(ApiRoutes.baseURL, contains('/api'));
    });

    test('RegisterRequestModel creates correct FormData and field mappings', () async {
      final request = RegisterRequestModel(
        name: 'Ajay Restaurant',
        ownerName: 'Ajay',
        phone: '8667695592',
        email: 'ajay2@gmail.com',
        city: 'Chennai',
        street: 'Anna Nagar',
        address: '1st Block',
        pincode: '600001',
        startTime: '10:00 AM',
        endTime: '10:00 PM',
        licenseNo: 'LIC12345',
        aadhar: '123456123456',
        panNo: 'ABCDE1234F',
        gstin: 'GST123456',
        accountHolder: 'Ajay',
        bankName: 'SBI',
        accountNumber: '9876543210',
        ifscCode: 'SBIN0001234',
        branchName: 'Main Branch',
        upiId: 'ajay@upi',
        termsConditions: 'I agree to the terms',
        privacyPolicy: 'I agree to the privacy policy',
      );

      final formData = await request.toFormData();

      expect(formData.fields.any((f) => f.key == 'name' && f.value == 'Ajay Restaurant'), isTrue);
      expect(formData.fields.any((f) => f.key == 'owner_name' && f.value == 'Ajay'), isTrue);
      expect(formData.fields.any((f) => f.key == 'phone' && f.value == '8667695592'), isTrue);
      expect(formData.fields.any((f) => f.key == 'email' && f.value == 'ajay2@gmail.com'), isTrue);
      expect(formData.fields.any((f) => f.key == 'license_no' && f.value == 'LIC12345'), isTrue);
      expect(formData.fields.any((f) => f.key == 'aadhar' && f.value == '123456123456'), isTrue);
      expect(formData.fields.any((f) => f.key == 'pan_no' && f.value == 'ABCDE1234F'), isTrue);
      expect(formData.fields.any((f) => f.key == 'gstin' && f.value == 'GST123456'), isTrue);
      expect(formData.fields.any((f) => f.key == 'account_holder' && f.value == 'Ajay'), isTrue);
      expect(formData.fields.any((f) => f.key == 'account_number' && f.value == '9876543210'), isTrue);
      expect(formData.fields.any((f) => f.key == 'ifsc_code' && f.value == 'SBIN0001234'), isTrue);
    });

    test('RegisterResponseModel parses success response correctly', () {
      final json = {
        'status': 'success',
        'message': 'Restaurant registered successfully',
        'data': {'id': 12, 'name': 'Ajay Restaurant'}
      };

      final response = RegisterResponseModel.fromJson(json);

      expect(response.success, isTrue);
      expect(response.message, 'Restaurant registered successfully');
      expect(response.data['id'], 12);
    });

    test('RegisterUseCase calls repository and handles submission', () async {
      final mockRepo = MockRegisterRepository();
      final useCase = RegisterUseCase(mockRepo);

      final request = RegisterRequestModel(
        name: 'Test',
        ownerName: 'Owner',
        phone: '9999999999',
        email: 'test@example.com',
        city: 'City',
        street: 'Street',
        address: 'Address',
        pincode: '123456',
        startTime: '9',
        endTime: '9',
        licenseNo: '1234',
        aadhar: '123456789012',
        panNo: 'PAN1234',
        accountHolder: 'Holder',
        bankName: 'Bank',
        accountNumber: '1111',
        ifscCode: 'IFSC',
        branchName: 'Branch',
      );

      final result = await useCase(request);

      expect(mockRepo.wasCalled, isTrue);
      expect(mockRepo.lastRequest?.name, 'Test');
      expect(result.success, isTrue);
      expect(result.message, 'Registration successful');
    });

    test('SignInController executes submission via RegisterUseCase', () async {
      final mockRepo = MockRegisterRepository();
      final useCase = RegisterUseCase(mockRepo);
      final controller = SignInController(registerUseCase: useCase);

      controller.restaurantNameController.text = 'Ajay Kitchen';
      controller.ownerNameController.text = 'Ajay';
      controller.phoneController.text = '8667695592';
      controller.emailController.text = 'ajay@gmail.com';
      controller.cityController.text = 'City';
      controller.streetController.text = 'Street';
      controller.addressController.text = 'Address';
      controller.pincodeController.text = '600001';
      controller.startTimeController.text = '10';
      controller.endTimeController.text = '22';
      controller.fssaiController.text = '12345678901234';
      controller.aadhaarController.text = '123412341234';
      controller.panController.text = 'ABCDE1234F';
      controller.accountHolderController.text = 'Ajay';
      controller.bankNameController.text = 'SBI';
      controller.accountNumberController.text = '123456';
      controller.ifscController.text = 'SBIN123';
      controller.branchNameController.text = 'Main';
      controller.acceptedTerms.value = true;
      controller.currentStep.value = 3;
      await controller.nextStep();

      expect(mockRepo.wasCalled, isTrue);
      expect(mockRepo.lastRequest?.name, 'Ajay Kitchen');
      expect(mockRepo.lastRequest?.ownerName, 'Ajay');
    });

    test('SignInController has available restaurant types list and updates selection', () {
      expect(SignInController.availableRestaurantTypes, ['Veg', 'Non-Veg', 'Both']);

      final mockRepo = MockRegisterRepository();
      final useCase = RegisterUseCase(mockRepo);
      final controller = SignInController(registerUseCase: useCase);

      expect(controller.restaurantType.value, isNull);
      expect(controller.restaurantTypeController.text, isEmpty);

      controller.setRestaurantType('Veg');
      expect(controller.restaurantType.value, 'Veg');
      expect(controller.restaurantTypeController.text, 'Veg');

      controller.setRestaurantType('Non-Veg');
      expect(controller.restaurantType.value, 'Non-Veg');
      expect(controller.restaurantTypeController.text, 'Non-Veg');

      controller.setRestaurantType('Both');
      expect(controller.restaurantType.value, 'Both');
      expect(controller.restaurantTypeController.text, 'Both');
    });

    test('SignInController field validators validate inputs properly', () {
      final mockRepo = MockRegisterRepository();
      final useCase = RegisterUseCase(mockRepo);
      final controller = SignInController(registerUseCase: useCase);

      // Email validator
      expect(controller.emailValidator(null), 'Email is required');
      expect(controller.emailValidator(''), 'Email is required');
      expect(controller.emailValidator('invalid-email'), 'Please enter a valid email address');
      expect(controller.emailValidator('test@'), 'Please enter a valid email address');
      expect(controller.emailValidator('test@domain.com'), isNull);

      // Phone validator
      expect(controller.phoneValidator(null), 'Phone number is required');
      expect(controller.phoneValidator('12345'), 'Please enter a valid 10-digit phone number');
      expect(controller.phoneValidator('9876543210'), isNull);

      // Pincode validator
      expect(controller.pincodeValidator(''), isNull);
      expect(controller.pincodeValidator('123'), 'Pincode must be 6 digits');
      expect(controller.pincodeValidator('600001'), isNull);

      // FSSAI validator
      expect(controller.fssaiValidator(null), 'FSSAI License number is required');
      expect(controller.fssaiValidator('123'), 'FSSAI License number must be exactly 14 digits');
      expect(controller.fssaiValidator('12345678901234'), isNull);

      // Aadhaar validator
      expect(controller.aadhaarValidator(null), 'Aadhaar number is required');
      expect(controller.aadhaarValidator('1234'), 'Aadhaar number must be exactly 12 digits');
      expect(controller.aadhaarValidator('123412341234'), isNull);

      // PAN validator
      expect(controller.panValidator(null), 'PAN number is required');
      expect(controller.panValidator('INVALID12'), 'Enter a valid 10-character PAN (e.g. ABCDE1234F)');
      expect(controller.panValidator('ABCDE1234F'), isNull);

      // GSTIN validator
      expect(controller.gstinValidator(''), isNull);
      expect(controller.gstinValidator(null), isNull);
      expect(controller.gstinValidator('INVALID'), 'Enter a valid 15-character GSTIN (e.g. 22AAAAA0000A1Z5)');
      expect(controller.gstinValidator('22AAAAA0000A1Z5'), isNull);

      // Account holder validator
      expect(controller.accountHolderValidator(null), 'Account holder name is required');
      expect(controller.accountHolderValidator(''), 'Account holder name is required');
      expect(controller.accountHolderValidator('A'), 'Account holder name must be at least 2 characters');
      expect(controller.accountHolderValidator('John Doe'), isNull);

      // Bank name validator
      expect(controller.bankNameValidator(null), 'Bank name is required');
      expect(controller.bankNameValidator(''), 'Bank name is required');
      expect(controller.bankNameValidator('S'), 'Bank name must be at least 2 characters');
      expect(controller.bankNameValidator('State Bank of India'), isNull);

      // Account number validator
      expect(controller.accountNumberValidator(null), 'Account number is required');
      expect(controller.accountNumberValidator(''), 'Account number is required');
      expect(controller.accountNumberValidator('12345'), 'Account number must be between 9 and 18 digits');
      expect(controller.accountNumberValidator('12345678901234567890'), 'Account number must be between 9 and 18 digits');
      expect(controller.accountNumberValidator('987654321012'), isNull);

      // IFSC validator
      expect(controller.ifscValidator(null), 'IFSC code is required');
      expect(controller.ifscValidator(''), 'IFSC code is required');
      expect(controller.ifscValidator('INVALID'), 'Enter a valid 11-character IFSC code (e.g. SBIN0001234)');
      expect(controller.ifscValidator('SBIN0001234'), isNull);

      // Branch name validator
      expect(controller.branchNameValidator(null), 'Branch name is required');
      expect(controller.branchNameValidator(''), 'Branch name is required');
      expect(controller.branchNameValidator('M'), 'Branch name must be at least 2 characters');
      expect(controller.branchNameValidator('Anna Nagar'), isNull);

      // UPI validator
      expect(controller.upiValidator(null), isNull);
      expect(controller.upiValidator(''), isNull);
      expect(controller.upiValidator('invalid_upi'), 'Please enter a valid UPI ID (e.g. user@okhdfcbank)');
      expect(controller.upiValidator('user@okhdfcbank'), isNull);
    });

    test('SignInController nextStep does not advance when profile photo is missing on step 0', () async {
      final mockRepo = MockRegisterRepository();
      final useCase = RegisterUseCase(mockRepo);
      final controller = SignInController(registerUseCase: useCase);

      controller.currentStep.value = 0;
      controller.profileImagePath.value = null;

      await controller.nextStep();

      // Should still be on step 0 because profile photo is mandatory
      expect(controller.currentStep.value, 0);
    });
  });
}
