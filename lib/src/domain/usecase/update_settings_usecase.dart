import '../../data/models/update_settings_model.dart';
import '../repository/settings_repository.dart';

class UpdateSettingsUseCase {
  final SettingsRepository _repository;

  UpdateSettingsUseCase(this._repository);

  Future<UpdateSettingsResponseModel> call(UpdateSettingsRequestModel request) {
    return _repository.updateSettings(request);
  }
}
