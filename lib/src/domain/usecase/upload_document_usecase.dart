import '../../data/models/upload_document_model.dart';
import '../repository/document_repository.dart';

class UploadDocumentUseCase {
  final DocumentRepository _repository;

  UploadDocumentUseCase(this._repository);

  Future<UploadDocumentResponseModel> call(UploadDocumentRequestModel request) {
    return _repository.uploadDocument(request);
  }
}
