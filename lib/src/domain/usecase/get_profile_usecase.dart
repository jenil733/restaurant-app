import '../../data/models/profile_model.dart';
import '../repository/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository _repository;

  GetProfileUseCase(this._repository);

  Future<ProfileResponseModel> call({Map<String, dynamic>? queryParams}) {
    return _repository.getProfile(queryParams: queryParams);
  }
}
