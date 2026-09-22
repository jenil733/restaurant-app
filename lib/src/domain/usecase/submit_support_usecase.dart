import '../../data/models/submit_support_model.dart';
import '../repository/support_repository.dart';

class SubmitSupportUseCase {
  final SupportRepository _repository;

  SubmitSupportUseCase(this._repository);

  Future<SubmitSupportResponseModel> call(SubmitSupportRequestModel request) {
    return _repository.submitSupport(request);
  }
}
