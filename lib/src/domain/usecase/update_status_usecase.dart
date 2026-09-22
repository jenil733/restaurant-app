import '../../data/models/update_status_model.dart';
import '../repository/update_status_repository.dart';

class UpdateStatusUseCase {
  final UpdateStatusRepository repository;

  UpdateStatusUseCase(this.repository);

  Future<UpdateStatusResponseModel> call(UpdateStatusRequestModel request) async {
    return await repository.updateStatus(request);
  }
}
