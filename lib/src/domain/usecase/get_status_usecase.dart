import '../../data/models/status_model.dart';
import '../repository/status_repository.dart';

class GetStatusUseCase {
  final StatusRepository _repository;

  GetStatusUseCase(this._repository);

  Future<StatusResponseModel> call({Map<String, dynamic>? queryParams}) {
    return _repository.getStatus(queryParams: queryParams);
  }
}
