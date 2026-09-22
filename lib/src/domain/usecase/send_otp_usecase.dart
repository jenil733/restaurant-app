import '../../data/models/send_otp_model.dart';
import '../repository/send_otp_repository.dart';

class SendOtpUseCase {
  final SendOtpRepository _repository;

  SendOtpUseCase(this._repository);

  Future<SendOtpResponseModel> call(SendOtpRequestModel request) {
    return _repository.sendOtp(request);
  }
}
