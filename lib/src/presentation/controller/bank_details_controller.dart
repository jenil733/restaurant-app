import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/di/service_locator.dart';
import '../../core/services/api_services.dart';
import '../../data/models/update_bank_details_model.dart';
import '../../data/repository/bank_details_repository_impl.dart';
import '../../domain/usecase/update_bank_details_usecase.dart';
import '../widgets/app_notification.dart';
import 'profile_controller.dart';

class BankDetailsController extends GetxController {
  late final UpdateBankDetailsUseCase _updateBankDetailsUseCase;

  var isUpdating = false.obs;

  @override
  void onInit() {
    super.onInit();
    _updateBankDetailsUseCase = sl.isRegistered<UpdateBankDetailsUseCase>()
        ? sl<UpdateBankDetailsUseCase>()
        : UpdateBankDetailsUseCase(BankDetailsRepositoryImpl(ApiService()));
  }

  Future<bool> updateBankDetails(UpdateBankDetailsRequestModel request) async {
    isUpdating.value = true;
    try {
      final response = await _updateBankDetailsUseCase(request);
      if (response.success) {
        if (Get.isRegistered<ProfileController>()) {
          final profileController = Get.find<ProfileController>();
          if (request.accountHolder != null) profileController.accountHolder.value = request.accountHolder!;
          if (request.bankName != null) profileController.bankName.value = request.bankName!;
          if (request.accountNumber != null) profileController.accountNumber.value = request.accountNumber!;
          if (request.ifsc != null) profileController.ifsc.value = request.ifsc!;
          if (request.branch != null) profileController.branch.value = request.branch!;
          if (request.upiId != null) profileController.upiId.value = request.upiId!;

          // Re-fetch latest from server
          profileController.fetchProfile(isRefresh: true);
        }

        // Close the screen first so Navigator pop does not dismiss the snackbar
        Get.back();

        AppNotification.showSuccess(
          title: "Bank Details Updated",
          message: response.message.isNotEmpty ? response.message : "Bank details updated successfully.",
        );
        return true;
      } else {
        AppNotification.showError(
          title: "Update Failed",
          message: response.message.isNotEmpty ? response.message : "Could not update bank details.",
        );
      }
    } catch (e) {
      debugPrint("Error updating bank details: $e");
      final err = e.toString().replaceAll("Exception:", "").replaceAll("ServerFailure:", "").trim();
      AppNotification.showError(
        title: "Update Failed",
        message: err.isNotEmpty ? err : "Could not update bank details.",
      );
    } finally {
      isUpdating.value = false;
    }
    return false;
  }
}
