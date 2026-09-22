import '../../data/models/update_profile_model.dart';
import '../repository/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<UpdateProfileResponseModel> call(UpdateProfileRequestModel request) {
    return _repository.updateProfile(request);
  }
}
