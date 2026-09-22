import 'package:dio/dio.dart';
import '../../core/const/api_routes.dart';
import '../../core/error/failure.dart';
import '../../core/services/api_services.dart';
import '../../domain/repository/verify_otp_repository.dart';
import '../models/verify_otp_model.dart';

class VerifyOtpRepositoryImpl implements VerifyOtpRepository {
  final ApiService _apiService;

  VerifyOtpRepositoryImpl(this._apiService);

  @override
  Future<VerifyOtpResponseModel> verifyOtp(VerifyOtpRequestModel request) async {
    try {
      final formData = request.toFormData();
      final response = await _apiService.post(
        ApiRoutes.verifyOtp,
        data: formData,
      );
      return VerifyOtpResponseModel.fromJson(response);
    } on DioException catch (e) {
      String message = 'Failed to verify OTP';
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
