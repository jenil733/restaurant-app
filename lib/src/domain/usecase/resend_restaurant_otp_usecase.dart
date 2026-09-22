import '../../data/models/restaurant_resend_otp_model.dart';
import '../repository/resend_restaurant_otp_repository.dart';

class ResendRestaurantOtpUseCase {
  final ResendRestaurantOtpRepository _repository;

  ResendRestaurantOtpUseCase(this._repository);

  Future<RestaurantResendOtpResponseModel> call(
    RestaurantResendOtpRequestModel request,
  ) {
    return _repository.resendRestaurantOtp(request);
  }
}
