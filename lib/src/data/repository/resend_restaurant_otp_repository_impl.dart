import 'package:dio/dio.dart';
import '../../core/const/api_routes.dart';
import '../../core/error/failure.dart';
import '../../core/services/api_services.dart';
import '../../domain/repository/resend_restaurant_otp_repository.dart';
import '../models/restaurant_resend_otp_model.dart';

class ResendRestaurantOtpRepositoryImpl implements ResendRestaurantOtpRepository {
  final ApiService _apiService;

  ResendRestaurantOtpRepositoryImpl(this._apiService);

  @override
  Future<RestaurantResendOtpResponseModel> resendRestaurantOtp(
    RestaurantResendOtpRequestModel request,
  ) async {
    try {
      final formData = request.toFormData();
      final response = await _apiService.post(
        ApiRoutes.resendOtp,
        data: formData,
      );
      return RestaurantResendOtpResponseModel.fromJson(response);
    } on DioException catch (e) {
      String message = 'Failed to resend restaurant OTP';
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
