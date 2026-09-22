import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/di/service_locator.dart';
import '../../core/services/api_services.dart';
import '../../data/models/update_settings_model.dart';
import '../../data/repository/settings_repository_impl.dart';
import '../../domain/usecase/update_settings_usecase.dart';
import '../widgets/app_notification.dart';

class SettingsController extends GetxController {
  late final UpdateSettingsUseCase _updateSettingsUseCase;

  var notificationsEnabled = true.obs;
  var isUpdating = false.obs;

  static const String _prefKeyNotifications = 'pref_notifications_enabled';

  @override
  void onInit() {
    super.onInit();
    _updateSettingsUseCase = sl.isRegistered<UpdateSettingsUseCase>()
        ? sl<UpdateSettingsUseCase>()
        : UpdateSettingsUseCase(SettingsRepositoryImpl(ApiService()));

    _loadLocalSettings();
  }

  Future<void> _loadLocalSettings() async {
    try {
      final prefs = sl.isRegistered<SharedPreferences>()
          ? sl<SharedPreferences>()
          : await SharedPreferences.getInstance();
      notificationsEnabled.value = prefs.getBool(_prefKeyNotifications) ?? true;
    } catch (e) {
      debugPrint("Error loading settings: $e");
    }
  }

  Future<void> toggleNotifications(bool value) async {
    final previousValue = notificationsEnabled.value;
    notificationsEnabled.value = value;
    isUpdating.value = true;

    try {
      final request = UpdateSettingsRequestModel(notificationsEnabled: value);
      final response = await _updateSettingsUseCase(request);

      if (response.success) {
        notificationsEnabled.value = response.notificationsEnabled;
        final prefs = sl.isRegistered<SharedPreferences>()
            ? sl<SharedPreferences>()
            : await SharedPreferences.getInstance();
        await prefs.setBool(_prefKeyNotifications, response.notificationsEnabled);

        AppNotification.showSuccess(
          title: "Settings Updated",
          message: response.message.isNotEmpty
              ? response.message
              : "Notifications ${value ? 'enabled' : 'disabled'} successfully.",
        );
      } else {
        notificationsEnabled.value = previousValue;
        AppNotification.showError(
          title: "Update Failed",
          message: response.message.isNotEmpty ? response.message : "Could not update settings.",
        );
      }
    } catch (e) {
      notificationsEnabled.value = previousValue;
      debugPrint("Error updating settings: $e");
      final err = e.toString().replaceAll("Exception:", "").trim();
      AppNotification.showError(
        title: "Update Failed",
        message: err.isNotEmpty ? err : "Could not update settings.",
      );
    } finally {
      isUpdating.value = false;
    }
  }
}
