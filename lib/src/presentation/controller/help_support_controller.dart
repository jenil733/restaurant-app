import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/di/service_locator.dart';
import '../../core/services/api_services.dart';
import '../../data/models/submit_support_model.dart';
import '../../data/repository/support_repository_impl.dart';
import '../../domain/usecase/submit_support_usecase.dart';

class HelpSupportController extends GetxController {
  late final SubmitSupportUseCase _submitSupportUseCase;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _submitSupportUseCase = sl.isRegistered<SubmitSupportUseCase>()
        ? sl<SubmitSupportUseCase>()
        : SubmitSupportUseCase(SupportRepositoryImpl(ApiService()));
  }

  Future<void> submitSupport() async {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    if (title.isEmpty) {
      Get.snackbar(
        "Required",
        "Please enter a title for your support request",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade700,
        colorText: Colors.white,
      );
      return;
    }

    if (description.isEmpty) {
      Get.snackbar(
        "Required",
        "Please enter a description for your support request",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade700,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final request = SubmitSupportRequestModel(
        title: title,
        description: description,
      );

      final response = await _submitSupportUseCase(request);

      if (response.success) {
        titleController.clear();
        descriptionController.clear();
        Get.snackbar(
          "Success",
          response.message.isNotEmpty
              ? response.message
              : "Support request submitted successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          response.message.isNotEmpty
              ? response.message
              : "Failed to submit support request",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
