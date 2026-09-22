import 'package:dio/dio.dart';
import '../../core/const/api_routes.dart';
import '../../core/error/failure.dart';
import '../../core/services/api_services.dart';
import '../../domain/repository/document_repository.dart';
import '../models/document_model.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  final ApiService _apiService;

  DocumentRepositoryImpl(this._apiService);

  @override
  Future<GetDocumentsResponseModel> getDocuments() async {
    try {
      final response = await _apiService.get(ApiRoutes.getDocuments);
      return GetDocumentsResponseModel.fromJson(response);
    } on DioException catch (e) {
      String message = 'Failed to fetch documents';
      if (e.response?.data is Map) {
        final data = e.response!.data as Map;
        if (data['message'] != null) {
          message = data['message'].toString();
        }
      }
      throw ServerFailure(message: message);
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<UploadDocumentResponseModel> uploadDocument(UploadDocumentRequestModel request) async {
    try {
      final formData = await request.toFormData();
      final response = await _apiService.post(
        ApiRoutes.uploadDocument,
        data: formData,
      );
      return UploadDocumentResponseModel.fromJson(response);
    } on DioException catch (e) {
      String message = 'Failed to upload document';
      if (e.response?.data is Map) {
        final data = e.response!.data as Map;
        if (data['message'] != null) {
          message = data['message'].toString();
        }
      }
      throw ServerFailure(message: message);
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(message: e.toString());
    }
  }
}
