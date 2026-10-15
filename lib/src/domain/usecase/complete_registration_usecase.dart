import '../../data/models/register_model.dart';
import '../repository/register_repository.dart';

class CompleteRegistrationUseCase {
  final RegisterRepository _repository;

  CompleteRegistrationUseCase(this._repository);

  Future<RegisterResponseModel> call(CompleteRegistrationRequestModel request) {
    return _repository.completeRegistration(request);
  }
}
