import '../../data/models/document_model.dart';
import '../repository/document_repository.dart';

class GetDocumentsUseCase {
  final DocumentRepository _repository;

  GetDocumentsUseCase(this._repository);

  Future<GetDocumentsResponseModel> call() {
    return _repository.getDocuments();
  }
}
