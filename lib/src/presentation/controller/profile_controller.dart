import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/di/service_locator.dart';
import '../../core/services/api_services.dart';
import '../../core/services/local_storage_services.dart';
import '../../data/models/profile_model.dart';
import '../../data/models/update_profile_model.dart';
import '../../data/repository/profile_repository_impl.dart';
import '../../domain/usecase/get_profile_usecase.dart';
import '../../domain/usecase/update_profile_usecase.dart';
import '../widgets/app_notification.dart';
import 'home_controller.dart';

class ProfileController extends GetxController {
  late final GetProfileUseCase _getProfileUseCase;
  late final UpdateProfileUseCase _updateProfileUseCase;

  var isLoading = false.obs;
  var isUpdating = false.obs;
  var errorMessage = RxnString();
  var profile = Rxn<ProfileModel>();

  var restaurantName = "".obs;
  var ownerName = "".obs;
  var mobile = "".obs;
  var email = "".obs;
  var address = "".obs;
  var city = "".obs;
  var street = "".obs;
  var pincode = "".obs;

  var restaurantId = "".obs;
  var startTime = "".obs;
  var endTime = "".obs;
  var storeTiming = "".obs;
  var foodType = "Non-Veg".obs;

  var isActive = true.obs;
  var isOnline = false.obs;
  var profileImage = "".obs;

  var licenseNo = "".obs;
  var gstin = "".obs;
  var panNo = "".obs;
  var aadhar = "".obs;
  var businessStatus = "".obs;

  var accountHolder = "".obs;
  var bankName = "".obs;
  var accountNumber = "".obs;
  var ifsc = "".obs;
  var branch = "".obs;
  var upiId = "".obs;

  @override
  void onInit() {
    super.onInit();
    _getProfileUseCase = sl.isRegistered<GetProfileUseCase>()
        ? sl<GetProfileUseCase>()
        : GetProfileUseCase(ProfileRepositoryImpl(ApiService()));
    _updateProfileUseCase = sl.isRegistered<UpdateProfileUseCase>()
        ? sl<UpdateProfileUseCase>()
        : UpdateProfileUseCase(ProfileRepositoryImpl(ApiService()));

    fetchProfile();
  }

  Future<void> fetchProfile({bool isRefresh = false}) async {
    if (!isRefresh && profile.value != null) {
      // Refresh silently
    } else {
      isLoading.value = true;
    }
    errorMessage.value = null;

    try {
      final response = await _getProfileUseCase();
      if (response.profile != null) {
        final data = response.profile!;
        profile.value = data;

        restaurantName.value = data.restaurantName ?? "";
        ownerName.value = data.ownerName ?? "";
        mobile.value = data.phone ?? "";
        email.value = data.email ?? "";
        address.value = data.address ?? "";
        city.value = data.city ?? "";
        street.value = data.street ?? "";
        pincode.value = data.pincode ?? "";
        if (data.id != null && data.id.toString().trim().isNotEmpty && data.id.toString() != 'null') {
          restaurantId.value = data.id.toString().trim();
          LocalStorageService().saveString('restaurant_id', restaurantId.value);
        } else {
          final savedId = LocalStorageService().getString('restaurant_id');
          if (savedId != null && savedId.trim().isNotEmpty && savedId.trim() != 'null') {
            restaurantId.value = savedId.trim();
          } else {
            final token = LocalStorageService().getString('auth_token');
            if (token != null && token.contains('|')) {
              final possibleId = token.split('|').first.trim();
              if (possibleId.isNotEmpty && int.tryParse(possibleId) != null) {
                restaurantId.value = possibleId;
              }
            }
          }
        }
        startTime.value = data.startTime ?? "";
        endTime.value = data.endTime ?? "";
        if ((data.startTime != null && data.startTime!.isNotEmpty) || (data.endTime != null && data.endTime!.isNotEmpty)) {
          final start = data.startTime ?? "";
          final end = data.endTime ?? "";
          if (start.isNotEmpty && end.isNotEmpty) {
            storeTiming.value = "$start - $end";
          } else {
            storeTiming.value = start.isNotEmpty ? start : end;
          }
        }
        if (data.foodType != null && data.foodType!.isNotEmpty) {
          foodType.value = data.foodType!;
        }
        if (data.image != null && data.image!.isNotEmpty) {
          profileImage.value = data.image!;
        }
        isActive.value = data.isActive;
        isOnline.value = data.isOnline;
        licenseNo.value = data.licenseNo ?? "";
        gstin.value = data.gstin ?? "";
        panNo.value = data.panNo ?? "";
        aadhar.value = data.aadhar ?? "";
        businessStatus.value = data.businessStatus ?? "";

        // If dashboard already verified approval, sync it across profile
        if (Get.isRegistered<HomeController>() && Get.find<HomeController>().isApproved.value) {
          isActive.value = true;
          if (businessStatus.value.isEmpty ||
              businessStatus.value.toLowerCase() == 'rejected' ||
              businessStatus.value.toLowerCase() == 'pending') {
            businessStatus.value = "Approved";
          }
        }

        accountHolder.value = data.accountHolder ?? "";
        bankName.value = data.bankName ?? "";
        accountNumber.value = data.accountNumber ?? "";
        ifsc.value = data.ifsc ?? "";
        branch.value = data.branch ?? "";
        upiId.value = data.upiId ?? "";
      }
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint("Error fetching profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProfile(UpdateProfileRequestModel request) async {
    isUpdating.value = true;
    try {
      final response = await _updateProfileUseCase(request);
      if (response.success || response.profile != null) {
        if (response.profile != null) {
          final data = response.profile!;
          profile.value = data;
          if (data.restaurantName != null) restaurantName.value = data.restaurantName!;
          if (data.ownerName != null) ownerName.value = data.ownerName!;
          if (data.phone != null) mobile.value = data.phone!;
          if (data.email != null) email.value = data.email!;
          if (data.address != null) address.value = data.address!;
          if (data.city != null) city.value = data.city!;
          if (data.street != null) street.value = data.street!;
          if (data.pincode != null) pincode.value = data.pincode!;
          if (data.startTime != null) startTime.value = data.startTime!;
          if (data.endTime != null) endTime.value = data.endTime!;
          if (data.startTime != null || data.endTime != null) {
            storeTiming.value = "${data.startTime ?? startTime.value} - ${data.endTime ?? endTime.value}";
          }
          if (data.foodType != null) foodType.value = data.foodType!;
          if (data.image != null) profileImage.value = data.image!;
        } else {
          if (request.restaurantName != null) restaurantName.value = request.restaurantName!;
          if (request.ownerName != null) ownerName.value = request.ownerName!;
          if (request.email != null) email.value = request.email!;
          if (request.phone != null) mobile.value = request.phone!;
          if (request.address != null) address.value = request.address!;
          if (request.city != null) city.value = request.city!;
          if (request.street != null) street.value = request.street!;
          if (request.pincode != null) pincode.value = request.pincode!;
          if (request.foodType != null) foodType.value = request.foodType!;
          if (request.startTime != null) startTime.value = request.startTime!;
          if (request.endTime != null) endTime.value = request.endTime!;
        }

        // Re-fetch latest from server
        profileControllerFetchSilently();

        Get.back();

        AppNotification.showSuccess(
          title: "Profile Updated",
          message: response.message.isNotEmpty ? response.message : "Profile updated successfully.",
        );
        return true;
      }
    } catch (e) {
      debugPrint("Error updating profile: $e");
      final err = e.toString().replaceAll("Exception:", "").replaceAll("ServerFailure:", "").trim();
      AppNotification.showError(
        title: "Update Failed",
        message: err.isNotEmpty ? err : "Could not update profile.",
      );
    } finally {
      isUpdating.value = false;
    }
    return false;
  }

  void profileControllerFetchSilently() {
    fetchProfile(isRefresh: true);
  }
}