import '../../data/models/logout_model.dart';
import '../repository/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<LogoutResponseModel> call() {
    return _repository.logout();
  }
}
