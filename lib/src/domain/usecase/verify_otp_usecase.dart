import '../../data/models/verify_otp_model.dart';
import '../repository/verify_otp_repository.dart';

class VerifyOtpUseCase {
  final VerifyOtpRepository _repository;

  VerifyOtpUseCase(this._repository);

  Future<VerifyOtpResponseModel> call(VerifyOtpRequestModel request) {
    return _repository.verifyOtp(request);
  }
}
