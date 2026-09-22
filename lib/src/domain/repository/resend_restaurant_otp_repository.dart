import '../../data/models/restaurant_resend_otp_model.dart';

abstract class ResendRestaurantOtpRepository {
  Future<RestaurantResendOtpResponseModel> resendRestaurantOtp(
    RestaurantResendOtpRequestModel request,
  );
}
