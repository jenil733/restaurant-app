import 'package:dio/dio.dart';
import '../../core/const/api_routes.dart';
import '../../core/error/failure.dart';
import '../../core/services/api_services.dart';
import '../../domain/repository/send_otp_repository.dart';
import '../models/send_otp_model.dart';

class SendOtpRepositoryImpl implements SendOtpRepository {
  final ApiService _apiService;

  SendOtpRepositoryImpl(this._apiService);

  @override
  Future<SendOtpResponseModel> sendOtp(SendOtpRequestModel request) async {
    try {
      final formData = request.toFormData();
      final response = await _apiService.post(
        ApiRoutes.sendOtp,
        data: formData,
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
}
