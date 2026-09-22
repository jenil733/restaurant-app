import '../../data/models/document_model.dart';

abstract class DocumentRepository {
  Future<GetDocumentsResponseModel> getDocuments();
  Future<UploadDocumentResponseModel> uploadDocument(UploadDocumentRequestModel request);
}
