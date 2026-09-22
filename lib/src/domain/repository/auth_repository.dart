import '../../data/models/logout_model.dart';

abstract class AuthRepository {
  Future<LogoutResponseModel> logout();
}
