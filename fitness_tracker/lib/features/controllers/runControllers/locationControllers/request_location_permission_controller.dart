import 'package:fitness_tracker/common/widgets/custome_shape/custome_snackbar/customSnackbar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class RequestLocationPermissionController {
  Future<void> requestLocationPermission(BuildContext context, Function onPermissionGranted) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showCustomSnackbar('Error', 'Please enable location services.', type: SnackbarType.error);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showCustomSnackbar('Error', 'Location permission denied.', type: SnackbarType.error);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showCustomSnackbar('Error', 'Location permissions permanently denied.', type: SnackbarType.error);
      return;
    }

    onPermissionGranted();
  }
}