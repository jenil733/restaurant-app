import 'package:dio/dio.dart';
import '../../core/const/api_routes.dart';
import '../../core/error/failure.dart';
import '../../core/services/api_services.dart';
import '../../domain/repository/otp_repository.dart';
import '../models/restaurant_resend_otp_model.dart';
import '../models/send_otp_model.dart';
import '../models/verify_otp_model.dart';

class OtpRepositoryImpl implements OtpRepository {
  final ApiService _apiService;

  OtpRepositoryImpl(this._apiService);

  @override
  Future<SendOtpResponseModel> sendOtp(SendOtpRequestModel request) async {
    try {
      final response = await _apiService.post(
        ApiRoutes.sendOtp,
        data: request.toFormData(),
      );
      return SendOtpResponseModel.fromJson(response);
    } on DioException catch (e) {
      String message = 'Failed to send OTP';
      if (e.response?.data is Map) {
        final data = e.response!.data as Map;
        if (data['message'] != null) {
          message = data['message'].toString();
        }
      }
      throw ServerFailure(message: message);
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<RestaurantResendOtpResponseModel> resendRestaurantOtp(
    RestaurantResendOtpRequestModel request,
  ) async {
    try {
      final response = await _apiService.post(
        ApiRoutes.resendOtp,
        data: request.toFormData(),
      );
      return RestaurantResendOtpResponseModel.fromJson(response);
    } on DioException catch (e) {
      String message = 'Failed to resend OTP';
      if (e.response?.data is Map) {
        final data = e.response!.data as Map;
        if (data['message'] != null) {
          message = data['message'].toString();
        }
      }
      throw ServerFailure(message: message);
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<VerifyOtpResponseModel> verifyOtp(VerifyOtpRequestModel request) async {
    try {
      final response = await _apiService.post(
        ApiRoutes.verifyOtp,
        data: request.toFormData(),
      );
      return VerifyOtpResponseModel.fromJson(response);
    } on DioException catch (e) {
      String message = 'Verification failed';
      if (e.response?.data is Map) {
        final data = e.response!.data as Map;
        if (data['message'] != null) {
          message = data['message'].toString();
        }
      }
      throw ServerFailure(message: message);
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(message: e.toString());
    }
  }
}
