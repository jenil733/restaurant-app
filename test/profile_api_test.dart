import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/src/core/const/api_routes.dart';
import 'package:restaurant_app/src/core/error/failure.dart';
import 'package:restaurant_app/src/data/models/profile_model.dart';
import 'package:restaurant_app/src/data/models/update_profile_model.dart';
import 'package:restaurant_app/src/domain/repository/profile_repository.dart';
import 'package:restaurant_app/src/domain/usecase/get_profile_usecase.dart';
import 'package:restaurant_app/src/domain/usecase/update_profile_usecase.dart';

class MockProfileRepository implements ProfileRepository {
  bool wasCalled = false;
  Map<String, dynamic>? lastParams;
  bool shouldThrow = false;
  String errorMessage = 'Error fetching profile';

  @override
  Future<ProfileResponseModel> getProfile({Map<String, dynamic>? queryParams}) async {
    wasCalled = true;
    lastParams = queryParams;

    if (shouldThrow) {
      throw ServerFailure(message: errorMessage);
    }

    return ProfileResponseModel(
      success: true,
      message: 'Profile fetched successfully',
      profile: ProfileModel(
        id: 'RST001',
        restaurantName: 'Kayal Restaurant',
        ownerName: 'John Miller',
        phone: '+91 9834572823',
        email: 'kayal@gmail.com',
        address: 'T Nagar, Chennai, Tamil Nadu',
        city: 'Chennai',
        street: 'T Nagar',
        pincode: '600 001',
        startTime: '10:00 AM',
        endTime: '10:00 PM',
        foodType: 'Non-Veg',
        isActive: true,
      ),
      code: 200,
    );
  }

  bool wasUpdateCalled = false;
  UpdateProfileRequestModel? lastUpdateRequest;

  @override
  Future<UpdateProfileResponseModel> updateProfile(UpdateProfileRequestModel request) async {
    wasUpdateCalled = true;
    lastUpdateRequest = request;

    if (shouldThrow) {
      throw ServerFailure(message: errorMessage);
    }

    return UpdateProfileResponseModel(
      success: true,
      message: 'Profile updated successfully',
      profile: ProfileModel(
        id: 'RST001',
        restaurantName: request.restaurantName ?? 'vj restaurant',
        ownerName: request.ownerName ?? 'John Miller',
        phone: request.phone ?? '+91 9834572823',
        email: request.email ?? 'kayal@gmail.com',
        address: request.address ?? 'T Nagar, Chennai, Tamil Nadu',
      ),
      code: 200,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Profile API Unit Tests', () {
    test('ApiRoutes contains profile and updateProfile endpoints', () {
      expect(ApiRoutes.profile, '/profile');
      expect(ApiRoutes.updateProfile, '/update_profile');
      expect(
        ApiRoutes.baseURL,
        'http://64.227.170.206/kayal.com/public/api/restaurant',
      );
      expect(
        ApiRoutes.apiKey,
        'sdfghjkcvbnfghjkcvbnmdfghjdfvgbncvbn',
      );
    });

    test('ProfileModel parses live API format correctly with profile, business, and bank_details', () {
      final liveJson = {
        "success": true,
        "data": {
          "profile": {
            "restaurant_name": "ajay restaurant",
            "owner_name": "ajay",
            "phone": "8667695592",
            "email": "ajay2@gmail.com",
            "city": "kk",
            "street": "kk",
            "address": "kk",
            "pincode": "987654",
            "type": null,
            "image": "http://64.227.170.206/kayal.com/public/storage/restaurant_images/sample.jpg",
            "start_time": "00:00:10",
            "end_time": "00:00:10"
          },
          "business": {
            "status": "Approved",
            "is_online": false,
            "license_no": "1234",
            "gstin": "123"
          },
          "bank_details": {
            "account_holder": "ajay",
            "bank_name": "sbi",
            "account_number": "1234",
            "ifsc": "1234",
            "branch": "kk",
            "upi_id": "ajayupi"
          }
        },
        "message": "Request successful",
        "code": 200
      };

      final response = ProfileResponseModel.fromJson(liveJson);
      expect(response.success, isTrue);
      expect(response.profile, isNotNull);

      final profile = response.profile!;
      expect(profile.restaurantName, 'ajay restaurant');
      expect(profile.ownerName, 'ajay');
      expect(profile.phone, '8667695592');
      expect(profile.email, 'ajay2@gmail.com');
      expect(profile.city, 'kk');
      expect(profile.street, 'kk');
      expect(profile.address, 'kk');
      expect(profile.pincode, '987654');
      expect(profile.image, 'http://64.227.170.206/kayal.com/public/storage/restaurant_images/sample.jpg');
      expect(profile.startTime, '00:00:10');
      expect(profile.endTime, '00:00:10');
      expect(profile.businessStatus, 'Approved');
      expect(profile.isOnline, isFalse);
      expect(profile.licenseNo, '1234');
      expect(profile.gstin, '123');
      expect(profile.bankName, 'sbi');
      expect(profile.accountHolder, 'ajay');
      expect(profile.accountNumber, '1234');
      expect(profile.ifsc, '1234');
      expect(profile.branch, 'kk');
      expect(profile.upiId, 'ajayupi');
    });

    test('ProfileModel parses JSON correctly with full flat fields', () {
      final json = {
        'id': 12,
        'restaurant_name': 'Spice Garden',
        'owner_name': 'Sarah Connor',
        'mobile': '+91 9999988888',
        'email': 'spice@garden.com',
        'address': 'MG Road, Bangalore',
        'city': 'Bangalore',
        'street': 'MG Road',
        'pincode': '560001',
        'start_time': '08:00 AM',
        'end_time': '11:00 PM',
        'food_type': 'Veg',
        'status': '1',
      };

      final profile = ProfileModel.fromJson(json);

      expect(profile.id, 12);
      expect(profile.restaurantName, 'Spice Garden');
      expect(profile.ownerName, 'Sarah Connor');
      expect(profile.phone, '+91 9999988888');
      expect(profile.email, 'spice@garden.com');
      expect(profile.address, 'MG Road, Bangalore');
      expect(profile.city, 'Bangalore');
      expect(profile.street, 'MG Road');
      expect(profile.pincode, '560001');
      expect(profile.startTime, '08:00 AM');
      expect(profile.endTime, '11:00 PM');
      expect(profile.foodType, 'Veg');
      expect(profile.isActive, isTrue);

      final map = profile.toJson();
      expect(map['restaurant_name'], 'Spice Garden');
      expect(map['owner_name'], 'Sarah Connor');
    });

    test('UpdateProfileRequestModel creates valid JSON and FormData', () async {
      final request = UpdateProfileRequestModel(
        restaurantName: 'vj restaurant',
        ownerName: 'Vijay Kumar',
        phone: '+91 9876543210',
        email: 'vj@restaurant.com',
      );

      final json = request.toJson();
      expect(json['restaurant_name'], 'vj restaurant');
      expect(json['name'], 'vj restaurant');
      expect(json['owner_name'], 'Vijay Kumar');
      expect(json['phone'], '+91 9876543210');
      expect(json['email'], 'vj@restaurant.com');

      final formData = await request.toFormData();
      expect(
        formData.fields.any((f) => f.key == 'restaurant_name' && f.value == 'vj restaurant'),
        isTrue,
      );
    });

    test('UpdateProfileResponseModel parses success response correctly', () {
      final json = {
        'status': true,
        'message': 'Profile updated successfully',
        'data': {
          'restaurant_name': 'vj restaurant',
          'owner_name': 'Vijay Kumar',
        },
        'code': 200,
      };

      final response = UpdateProfileResponseModel.fromJson(json);
      expect(response.success, isTrue);
      expect(response.message, 'Profile updated successfully');
      expect(response.profile?.restaurantName, 'vj restaurant');
    });

    test('GetProfileUseCase delegates request to ProfileRepository', () async {
      final mockRepo = MockProfileRepository();
      final useCase = GetProfileUseCase(mockRepo);

      final result = await useCase();

      expect(mockRepo.wasCalled, isTrue);
      expect(result.success, isTrue);
      expect(result.profile?.restaurantName, 'Kayal Restaurant');
      expect(result.profile?.ownerName, 'John Miller');
    });

    test('GetProfileUseCase handles repository failure', () async {
      final mockRepo = MockProfileRepository()..shouldThrow = true;
      final useCase = GetProfileUseCase(mockRepo);

      expect(
        () => useCase(),
        throwsA(isA<ServerFailure>()),
      );
    });

    test('UpdateProfileUseCase delegates request to ProfileRepository', () async {
      final mockRepo = MockProfileRepository();
      final useCase = UpdateProfileUseCase(mockRepo);

      final request = UpdateProfileRequestModel(restaurantName: 'vj restaurant');
      final result = await useCase(request);

      expect(mockRepo.wasUpdateCalled, isTrue);
      expect(mockRepo.lastUpdateRequest?.restaurantName, 'vj restaurant');
      expect(result.success, isTrue);
      expect(result.profile?.restaurantName, 'vj restaurant');
    });

    test('UpdateProfileUseCase handles repository failure', () async {
      final mockRepo = MockProfileRepository()..shouldThrow = true;
      final useCase = UpdateProfileUseCase(mockRepo);

      expect(
        () => useCase(UpdateProfileRequestModel(restaurantName: 'vj restaurant')),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}
