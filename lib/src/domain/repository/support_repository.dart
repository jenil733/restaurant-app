import '../../data/models/submit_support_model.dart';

abstract class SupportRepository {
  Future<SubmitSupportResponseModel> submitSupport(SubmitSupportRequestModel request);
}
