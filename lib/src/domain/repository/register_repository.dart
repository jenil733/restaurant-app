import '../../data/models/register_model.dart';

abstract class RegisterRepository {
  Future<RegisterResponseModel> register(RegisterRequestModel request);
}
