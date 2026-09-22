import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/src/core/const/api_routes.dart';
import 'package:restaurant_app/src/core/error/failure.dart';
import 'package:restaurant_app/src/data/models/restaurant_resend_otp_model.dart';
import 'package:restaurant_app/src/data/models/send_otp_model.dart';
import 'package:restaurant_app/src/data/models/verify_otp_model.dart';
import 'package:restaurant_app/src/domain/repository/otp_repository.dart';
import 'package:restaurant_app/src/domain/usecase/resend_restaurant_otp_usecase.dart';
import 'package:restaurant_app/src/domain/usecase/send_otp_usecase.dart';
import 'package:restaurant_app/src/domain/usecase/verify_otp_usecase.dart';
import 'package:restaurant_app/src/presentation/controller/auth/login_controller.dart';
import 'package:restaurant_app/src/presentation/controller/auth/otp_controller.dart';
import 'package:restaurant_app/src/presentation/controller/auth/sign_in_controller.dart';

class MockOtpRepository implements OtpRepository {
  bool wasSendOtpCalled = false;
  bool wasResendRestaurantOtpCalled = false;
  bool wasVerifyOtpCalled = false;
  SendOtpRequestModel? lastSendOtpRequest;
  RestaurantResendOtpRequestModel? lastResendRestaurantOtpRequest;
  VerifyOtpRequestModel? lastVerifyOtpRequest;
  bool shouldThrow = false;
  String errorMessage = 'Error occurred';

  @override
  Future<SendOtpResponseModel> sendOtp(SendOtpRequestModel request) async {
    wasSendOtpCalled = true;
    lastSendOtpRequest = request;

    if (shouldThrow) {
      throw ServerFailure(message: errorMessage);
    }

    return SendOtpResponseModel(
      success: true,
      message: 'OTP sent successfully',
      data: {'phone': request.phone, 'otp': '1234'},
      code: 200,
    );
  }

  @override
  Future<RestaurantResendOtpResponseModel> resendRestaurantOtp(
    RestaurantResendOtpRequestModel request,
  ) async {
    wasResendRestaurantOtpCalled = true;
    lastResendRestaurantOtpRequest = request;

    if (shouldThrow) {
      throw ServerFailure(message: errorMessage);
    }

    return RestaurantResendOtpResponseModel(
      success: true,
      message: 'Restaurant OTP resent successfully',
      data: {'phone': request.phone},
      code: 200,
    );
  }

  @override
  Future<VerifyOtpResponseModel> verifyOtp(VerifyOtpRequestModel request) async {
    wasVerifyOtpCalled = true;
    lastVerifyOtpRequest = request;

    if (shouldThrow) {
      throw ServerFailure(message: errorMessage);
    }

    return VerifyOtpResponseModel(
      success: true,
      message: 'OTP verified successfully',
      token: 'test_auth_token_123',
      data: {'phone': request.phone},
      code: 200,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Send, Resend & Verify OTP API Unit Tests', () {
    test('ApiRoutes contains sendOtp, resendOtp, and verifyOtp endpoints', () {
      expect(ApiRoutes.sendOtp, '/send_otp');
      expect(ApiRoutes.resendOtp, '/resend_otp');
      expect(ApiRoutes.verifyOtp, '/verify_otp');
      expect(
        ApiRoutes.baseURL,
        'http://64.227.170.206/kayal.com/public/api/restaurant',
      );
      expect(
        ApiRoutes.apiKey,
        'sdfghjkcvbnfghjkcvbnmdfghjdfvgbncvbn',
      );
    });

    test('SendOtpRequestModel creates correct FormData and field mappings', () {
      final request = SendOtpRequestModel(phone: '8667695591');

      final formData = request.toFormData();
      expect(
        formData.fields.any((f) => f.key == 'phone' && f.value == '8667695591'),
        isTrue,
      );

      final json = request.toJson();
      expect(json['phone'], '8667695591');
    });

    test('VerifyOtpRequestModel creates correct FormData and JSON', () {
      final request = VerifyOtpRequestModel(phone: '8667695591', otp: '1234');

      final formData = request.toFormData();
      expect(formData.fields.any((f) => f.key == 'phone' && f.value == '8667695591'), isTrue);
      expect(formData.fields.any((f) => f.key == 'otp' && f.value == '1234'), isTrue);

      final json = request.toJson();
      expect(json['phone'], '8667695591');
      expect(json['otp'], '1234');
    });

    test('VerifyOtpResponseModel parses success response and token correctly', () {
      final json = {
        'status': true,
        'message': 'OTP verified successfully',
        'data': {
          'token': 'bearer_token_xyz',
          'user': {'id': 1, 'name': 'Restaurant Owner'}
        },
        'code': 200,
      };

      final response = VerifyOtpResponseModel.fromJson(json);

      expect(response.success, isTrue);
      expect(response.message, 'OTP verified successfully');
      expect(response.token, 'bearer_token_xyz');
      expect(response.code, 200);
    });

    test('VerifyOtpUseCase calls repository with valid request', () async {
      final mockRepo = MockOtpRepository();
      final useCase = VerifyOtpUseCase(mockRepo);

      final request = VerifyOtpRequestModel(phone: '8667695591', otp: '1234');
      final result = await useCase(request);

      expect(mockRepo.wasVerifyOtpCalled, isTrue);
      expect(mockRepo.lastVerifyOtpRequest?.phone, '8667695591');
      expect(mockRepo.lastVerifyOtpRequest?.otp, '1234');
      expect(result.success, isTrue);
      expect(result.token, 'test_auth_token_123');
    });

    test('OtpController executes verifyOtp with 4 digits and updates state', () async {
      final mockRepo = MockOtpRepository();
      final verifyUseCase = VerifyOtpUseCase(mockRepo);
      final sendUseCase = SendOtpUseCase(mockRepo);
      final controller = OtpController(
        sendOtpUseCase: sendUseCase,
        verifyOtpUseCase: verifyUseCase,
      );

      controller.otpController.text = '1234';
      await controller.verifyOtp();

      expect(mockRepo.wasVerifyOtpCalled, isTrue);
      expect(mockRepo.lastVerifyOtpRequest?.otp, '1234');
      expect(controller.isVerifying.value, isFalse);
    });

    test('OtpController rejects incomplete OTP without calling verify API', () async {
      final mockRepo = MockOtpRepository();
      final verifyUseCase = VerifyOtpUseCase(mockRepo);
      final sendUseCase = SendOtpUseCase(mockRepo);
      final controller = OtpController(
        sendOtpUseCase: sendUseCase,
        verifyOtpUseCase: verifyUseCase,
      );

      controller.otpController.text = '12';
      await controller.verifyOtp();

      expect(mockRepo.wasVerifyOtpCalled, isFalse);
      expect(controller.isVerifying.value, isFalse);
    });

    test('RestaurantResendOtpRequestModel creates correct FormData and fields', () {
      final request = RestaurantResendOtpRequestModel(
        accountHolder: 'ajay',
        bankName: 'sbi',
        accountNumber: '9898989898',
        ifscCode: '123456',
        branchName: 'kk',
        upiId: 'ajayupi',
        phone: '9898989898',
      );

      final formData = request.toFormData();
      expect(formData.fields.any((f) => f.key == 'account_holder' && f.value == 'ajay'), isTrue);
      expect(formData.fields.any((f) => f.key == 'bank_name' && f.value == 'sbi'), isTrue);
      expect(formData.fields.any((f) => f.key == 'account_number' && f.value == '9898989898'), isTrue);
      expect(formData.fields.any((f) => f.key == 'ifsc_code' && f.value == '123456'), isTrue);
      expect(formData.fields.any((f) => f.key == 'branch_name' && f.value == 'kk'), isTrue);
      expect(formData.fields.any((f) => f.key == 'upi_id' && f.value == 'ajayupi'), isTrue);
      expect(formData.fields.any((f) => f.key == 'phone' && f.value == '9898989898'), isTrue);

      final json = request.toJson();
      expect(json['account_holder'], 'ajay');
      expect(json['phone'], '9898989898');
    });

    test('ResendRestaurantOtpUseCase calls repository with correct payload', () async {
      final mockRepo = MockOtpRepository();
      final useCase = ResendRestaurantOtpUseCase(mockRepo);

      final request = RestaurantResendOtpRequestModel(
        accountHolder: 'ajay',
        bankName: 'sbi',
        accountNumber: '9898989898',
        ifscCode: '123456',
        branchName: 'kk',
        upiId: 'ajayupi',
        phone: '9898989898',
      );

      final result = await useCase(request);

      expect(mockRepo.wasResendRestaurantOtpCalled, isTrue);
      expect(mockRepo.lastResendRestaurantOtpRequest?.accountHolder, 'ajay');
      expect(mockRepo.lastResendRestaurantOtpRequest?.phone, '9898989898');
      expect(result.success, isTrue);
      expect(result.message, 'Restaurant OTP resent successfully');
    });

    test('SignInController executes resendRestaurantOtp properly', () async {
      final mockRepo = MockOtpRepository();
      final useCase = ResendRestaurantOtpUseCase(mockRepo);
      final controller = SignInController(resendRestaurantOtpUseCase: useCase);

      controller.accountHolderController.text = 'ajay';
      controller.bankNameController.text = 'sbi';
      controller.accountNumberController.text = '9898989898';
      controller.ifscController.text = '123456';
      controller.branchNameController.text = 'kk';
      controller.upiController.text = 'ajayupi';
      controller.phoneController.text = '9898989898';

      final success = await controller.resendRestaurantOtp();

      expect(success, isTrue);
      expect(mockRepo.wasResendRestaurantOtpCalled, isTrue);
      expect(mockRepo.lastResendRestaurantOtpRequest?.phone, '9898989898');
      expect(controller.isLoading.value, isFalse);
    });

    test('LoginController executes OTP send with valid phone', () async {
      final mockRepo = MockOtpRepository();
      final useCase = SendOtpUseCase(mockRepo);
      final controller = LoginController(sendOtpUseCase: useCase);

      controller.phoneController.text = '8667695591';
      await controller.login();

      expect(mockRepo.wasSendOtpCalled, isTrue);
      expect(mockRepo.lastSendOtpRequest?.phone, '8667695591');
      expect(controller.isLoading.value, isFalse);
    });

    test('OtpController resends OTP when canResend is true', () async {
      final mockRepo = MockOtpRepository();
      final useCase = SendOtpUseCase(mockRepo);
      final controller = OtpController(sendOtpUseCase: useCase);

      controller.secondsRemaining.value = 0;
      expect(controller.canResend, isTrue);

      await controller.resendOtp();

      expect(mockRepo.wasSendOtpCalled, isTrue);
      expect(controller.secondsRemaining.value, 30);
    });
  });
}
