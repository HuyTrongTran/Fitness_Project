import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fitness_tracker/common/widgets/custome_shape/custome_snackbar/customSnackbar.dart';

class StartTrackingController {
  StreamSubscription<Position>? _positionStream;

  Future<void> startTracking({
    required Function(LatLng) onPointAdded,
    required Function(double) onDistanceUpdated,
    required Function(Position) onPositionUpdated,
    required BuildContext context,
  }) async {
    try {
      final Position? initialPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if (initialPosition != null) {
        print("Initial position: ${initialPosition.latitude}, ${initialPosition.longitude}");
        onPointAdded(LatLng(initialPosition.latitude, initialPosition.longitude));
        onPositionUpdated(initialPosition);
      } else {
        print("Failed to get initial position");
        showCustomSnackbar('Error', 'Failed to get initial position.', type: SnackbarType.error);
        return;
      }

      _positionStream?.cancel();
      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5,
        ),
      ).listen(
        (Position position) {
          if (position.latitude == null || position.longitude == null) return;

          final LatLng newPoint = LatLng(position.latitude, position.longitude);
          print("New position: ${position.latitude}, ${position.longitude}");

          onPointAdded(newPoint);
          onPositionUpdated(position);
          onDistanceUpdated(_calculateDistance(newPoint));
        },
        onError: (e) {
          print("Position stream error: $e");
          showCustomSnackbar('Error', 'Location tracking failed.', type: SnackbarType.error);
        },
      );
    } catch (e) {
      print("Error starting tracking: $e");
      showCustomSnackbar('Error', 'Failed to start tracking.', type: SnackbarType.error);
    }
  }

  double _calculateDistance(LatLng newPoint) {
    // Giả lập tính toán khoảng cách, cần danh sách điểm từ class chính
    return 0.0; // Thay bằng logic thực tế nếu cần
  }

  void dispose() {
    _positionStream?.cancel();
  }
}