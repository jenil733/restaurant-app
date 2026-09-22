import '../../data/models/update_settings_model.dart';

abstract class SettingsRepository {
  Future<UpdateSettingsResponseModel> updateSettings(UpdateSettingsRequestModel request);
}
