import '../../data/models/register_model.dart';
import '../repository/register_repository.dart';

class RegisterUseCase {
  final RegisterRepository _repository;

  RegisterUseCase(this._repository);

  Future<RegisterResponseModel> call(RegisterRequestModel request) {
    return _repository.register(request);
  }
}
