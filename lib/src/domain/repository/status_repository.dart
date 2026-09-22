import '../../data/models/status_model.dart';
import '../../data/models/update_status_model.dart';
import 'update_status_repository.dart';

export 'update_status_repository.dart';

abstract class StatusRepository implements UpdateStatusRepository {
  Future<StatusResponseModel> getStatus({Map<String, dynamic>? queryParams});
  @override
  Future<UpdateStatusResponseModel> updateStatus(UpdateStatusRequestModel request);
}
