import '../../data/models/send_otp_model.dart';

abstract class SendOtpRepository {
  Future<SendOtpResponseModel> sendOtp(SendOtpRequestModel request);
}
