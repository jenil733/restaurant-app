import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/di/service_locator.dart';
import '../../core/services/api_services.dart';
import '../../data/models/document_model.dart';
import '../../data/repository/document_repository_impl.dart';
import '../../domain/usecase/get_documents_usecase.dart';
import '../../domain/usecase/upload_document_usecase.dart';
import '../widgets/app_notification.dart';

class DocumentController extends GetxController {
  late final GetDocumentsUseCase _getDocumentsUseCase;
  late final UploadDocumentUseCase _uploadDocumentUseCase;

  var isLoading = false.obs;
  var isUploading = false.obs;
  var documentsData = Rxn<RestaurantDocumentsModel>();
  var documentsList = <DocumentItemModel>[].obs;
  var errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    _getDocumentsUseCase = sl.isRegistered<GetDocumentsUseCase>()
        ? sl<GetDocumentsUseCase>()
        : GetDocumentsUseCase(DocumentRepositoryImpl(ApiService()));
    _uploadDocumentUseCase = sl.isRegistered<UploadDocumentUseCase>()
        ? sl<UploadDocumentUseCase>()
        : UploadDocumentUseCase(DocumentRepositoryImpl(ApiService()));

    fetchDocuments();
  }

  Future<void> fetchDocuments({bool isRefresh = false}) async {
    if (!isRefresh) {
      isLoading.value = true;
      errorMessage.value = null;
    }

    try {
      final response = await _getDocumentsUseCase();
      if (response.success) {
        documentsData.value = response.data;
        documentsList.assignAll(response.documents);
        errorMessage.value = null;
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      debugPrint("Error fetching documents: $e");
      final err = e.toString().replaceAll("Exception:", "").replaceAll("ServerFailure:", "").trim();
      errorMessage.value = err.isNotEmpty ? err : "Failed to load documents";
      if (isRefresh) {
        AppNotification.showError(
          title: "Error",
          message: errorMessage.value!,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> uploadDocument(UploadDocumentRequestModel request) async {
    isUploading.value = true;
    try {
      final response = await _uploadDocumentUseCase(request);
      if (response.success) {
        AppNotification.showSuccess(
          title: "Document Uploaded",
          message: response.message.isNotEmpty ? response.message : "Document uploaded successfully.",
        );
        // Refresh documents list
        await fetchDocuments(isRefresh: true);
        return true;
      } else {
        AppNotification.showError(
          title: "Upload Failed",
          message: response.message.isNotEmpty ? response.message : "Could not upload document.",
        );
        return false;
      }
    } catch (e) {
      debugPrint("Error uploading document: $e");
      final err = e.toString().replaceAll("Exception:", "").replaceAll("ServerFailure:", "").trim();
      AppNotification.showError(
        title: "Upload Failed",
        message: err.isNotEmpty ? err : "Could not upload document.",
      );
      return false;
    } finally {
      isUploading.value = false;
    }
  }
}
