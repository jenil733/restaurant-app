import '../../data/models/profile_model.dart';
import '../../data/models/update_profile_model.dart';

abstract class ProfileRepository {
  Future<ProfileResponseModel> getProfile({Map<String, dynamic>? queryParams});
  Future<UpdateProfileResponseModel> updateProfile(UpdateProfileRequestModel request);
}

