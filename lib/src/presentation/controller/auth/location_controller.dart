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

      // 6. Get location with fast timeout and fallbacks
      Position? position;

      // Try last known position first (instant)
      try {
        position = await Geolocator.getLastKnownPosition();
      } catch (e) {
        debugPrint('Last known position error: $e');
      }

      // If no last known position, try getting current position with balanced accuracy and 6s timeout
      if (position == null) {
        try {
          position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.medium,
              timeLimit: Duration(seconds: 6),
            ),
          );
        } catch (e) {
          debugPrint('Medium accuracy timeout/error: $e. Trying low accuracy fallback.');
          try {
            position = await Geolocator.getCurrentPosition(
              locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.low,
                timeLimit: Duration(seconds: 4),
              ),
            );
          } catch (e) {
            debugPrint('Low accuracy timeout/error: $e');
          }
        }
      }

      // Fallback default position if device has no GPS fix (e.g. indoors or emulator)
      position ??= Position(
        longitude: 80.2707,
        latitude: 13.0827,
        timestamp: DateTime.now(),
        accuracy: 100,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );

      isLoading.value = false;

      debugPrint('Latitude: ${position.latitude}');
      debugPrint('Longitude: ${position.longitude}');

      // Navigate to Confirm Location screen
      Get.toNamed(
        AppRoutes.confirmlocation,
        arguments: position,
      );
    } catch (e) {
      isLoading.value = false;
      debugPrint('LOCATION ERROR: $e');

      final fallbackPosition = Position(
        longitude: 80.2707,
        latitude: 13.0827,
        timestamp: DateTime.now(),
        accuracy: 100,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );

      Get.toNamed(
        AppRoutes.confirmlocation,
        arguments: fallbackPosition,
      );
    }
  }

  void notNow() {
    Get.offAllNamed(AppRoutes.home);
  }
}