import 'package:fitness_tracker/RunFeature/class/runSession.dart';
import 'package:fitness_tracker/screens/runSessionFeature/RunResultPage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StopTrackingController {
  Future<void> stopTracking({
    required BuildContext context,
    required int elapsedTimeInSeconds,
    required double distanceInKm,
    required List<LatLng> routePoints,
    required Function onStop,
  }) async {
    onStop(); // Hủy timer và stream từ class chính

    int steps = (distanceInKm * 1250).toInt();
    double calories = distanceInKm * 60;

    RunSessionManager.addSession(
      RunSession(
        date: DateTime.now(),
        elapsedTimeInSeconds: elapsedTimeInSeconds,
        distanceInKm: distanceInKm,
        routePoints: List.from(routePoints),
        steps: steps,
        calories: calories,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RunResultPage()),
    );
  }
}