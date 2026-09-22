import '../../data/models/restaurant_resend_otp_model.dart';
import '../../data/models/send_otp_model.dart';
import '../../data/models/verify_otp_model.dart';
import 'send_otp_repository.dart';
import 'verify_otp_repository.dart';
import 'resend_restaurant_otp_repository.dart';

export 'send_otp_repository.dart';
export 'verify_otp_repository.dart';
export 'resend_restaurant_otp_repository.dart';

abstract class OtpRepository
    implements SendOtpRepository, ResendRestaurantOtpRepository, VerifyOtpRepository {
  @override
  Future<SendOtpResponseModel> sendOtp(SendOtpRequestModel request);
  @override
  Future<RestaurantResendOtpResponseModel> resendRestaurantOtp(
    RestaurantResendOtpRequestModel request,
  );
  @override
  Future<VerifyOtpResponseModel> verifyOtp(VerifyOtpRequestModel request);
}
