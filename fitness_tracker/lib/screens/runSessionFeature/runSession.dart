import 'package:google_maps_flutter/google_maps_flutter.dart';

class RunSession {
  final DateTime date;
  final int elapsedTimeInSeconds;
  final double distanceInKm;
  final List<LatLng> routePoints;
  final int steps;
  final double calories;

  RunSession({
    required this.date,
    required this.elapsedTimeInSeconds,
    required this.distanceInKm,
    required this.routePoints,
    required this.steps,
    required this.calories,
  });
}

class RunSessionManager {
  static final List<RunSession> _runSessions = [];

  static List<RunSession> get runSessions => _runSessions;

  static void addSession(RunSession session) {
    _runSessions.add(session);
  }

  static void clearSessions() {
    _runSessions.clear();
  }
}
