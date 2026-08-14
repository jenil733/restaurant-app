import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:restaurant_app/src/core/utils/navigation/app_routes.dart';


class LocationController extends GetxController {
  final isLoading = false.obs;

  Future<void> allowLocation() async {
    try {
      isLoading.value = true;

      // 1. Check location service
      final serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        isLoading.value = false;

        Get.snackbar(
          'Location Disabled',
          'Please turn on location service',
          snackPosition: SnackPosition.BOTTOM,
        );

        await Geolocator.openLocationSettings();
        return;
      }

      // 2. Check permission
      LocationPermission permission =
          await Geolocator.checkPermission();

      // 3. Request permission
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      // 4. Permission denied
      if (permission == LocationPermission.denied) {
        isLoading.value = false;

        Get.snackbar(
          'Permission Denied',
          'Please allow location permission',
          snackPosition: SnackPosition.BOTTOM,
        );

        return;
      }

      // 5. Permission permanently denied
      if (permission == LocationPermission.deniedForever) {
        isLoading.value = false;

        Get.snackbar(
          'Permission Required',
          'Please enable location permission from Settings',
          snackPosition: SnackPosition.BOTTOM,
        );

        await Geolocator.openAppSettings();
        return;
      }

      // 6. Get current location
      final Position position =
          await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );

      isLoading.value = false;

      debugPrint(
        'Latitude: ${position.latitude}',
      );

      debugPrint(
        'Longitude: ${position.longitude}',
      );

      // IMPORTANT:
      // Go to Confirm Location screen
      Get.toNamed(
        AppRoutes.confirmlocation,
        arguments: position,
      );
    } catch (e) {
      isLoading.value = false;

      debugPrint('LOCATION ERROR: $e');

      Get.snackbar(
        'Location Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void notNow() {
    Get.offAllNamed('/home');
  }
}