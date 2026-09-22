import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/services/local_storage_services.dart';
import 'package:restaurant_app/src/core/utils/navigation/app_routes.dart';

class LocationConfirmController extends GetxController {
  final isLoading = false.obs;

  final address = ''.obs;
  final city = ''.obs;
  final state = ''.obs;
  final pincode = ''.obs;

  Position position = Position(
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

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments;

    if (arguments != null && arguments is Position) {
      position = arguments;
    }
    getAddress();
  }

  Future<void> getAddress() async {
    try {
      isLoading.value = true;

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      ).timeout(const Duration(seconds: 5));

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        address.value = [
          place.subThoroughfare,
          place.thoroughfare,
          place.subLocality,
        ].where((e) => e != null && e.isNotEmpty).join(', ');

        city.value = place.locality ?? place.subAdministrativeArea ?? '';
        state.value = place.administrativeArea ?? '';
        pincode.value = place.postalCode ?? '';
      }
    } catch (e) {
      debugPrint('Address error: $e');
      if (address.value.isEmpty) {
        address.value = 'Current Location';
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> confirmLocation() async {
    await LocalStorageService().saveBool('is_logged_in', true);
    Get.offAllNamed(
      AppRoutes.home,
      arguments: {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'address': address.value,
        'city': city.value,
        'state': state.value,
        'pincode': pincode.value,
      },
    );
  }

  void chooseAnotherLocation() {
    Get.back();
  }
}