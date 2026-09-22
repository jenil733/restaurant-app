import '../../data/models/update_status_model.dart';

abstract class UpdateStatusRepository {
  Future<UpdateStatusResponseModel> updateStatus(UpdateStatusRequestModel request);
}
