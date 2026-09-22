import '../../data/models/verify_otp_model.dart';

abstract class VerifyOtpRepository {
  Future<VerifyOtpResponseModel> verifyOtp(VerifyOtpRequestModel request);
}
