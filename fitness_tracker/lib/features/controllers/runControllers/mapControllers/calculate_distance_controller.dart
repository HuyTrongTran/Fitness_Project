import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CalculateDistanceController {
  // Khoảng cách tối thiểu giữa các điểm để được tính là di chuyển (mét)
  static const double minimumDistance = 5.0;

  // Thời gian tối thiểu giữa các điểm để được tính là di chuyển (giây)
  static const int minimumTime = 1;

  // Tốc độ tối thiểu để được tính là di chuyển (km/h)
  static const double minimumSpeed = 1.0;

  // Tốc độ tối đa hợp lý cho người chạy (km/h)
  static const double maximumSpeed = 30.0;

  double calculateDistance(List<LatLng> routePoints, int elapsedTimeInSeconds) {
    if (routePoints.length < 2) return 0.0;

    double totalDistance = 0.0;
    double currentSpeed = calculateSpeed(routePoints, elapsedTimeInSeconds);

    // Chỉ tính khoảng cách nếu tốc độ nằm trong khoảng hợp lý
    if (currentSpeed >= minimumSpeed && currentSpeed <= maximumSpeed) {
      for (int i = 0; i < routePoints.length - 1; i++) {
        double distance = Geolocator.distanceBetween(
          routePoints[i].latitude,
          routePoints[i].longitude,
          routePoints[i + 1].latitude,
          routePoints[i + 1].longitude,
        );

        if (distance >= minimumDistance) {
          totalDistance += distance;
        }
      }
    }

    // Chuyển đổi từ mét sang km
    return totalDistance / 1000;
  }

  // Tính tốc độ di chuyển (km/h)
  double calculateSpeed(List<LatLng> routePoints, int elapsedTimeInSeconds) {
    if (elapsedTimeInSeconds == 0) return 0.0;

    double distanceInMeters = 0.0;
    for (int i = 0; i < routePoints.length - 1; i++) {
      distanceInMeters += Geolocator.distanceBetween(
        routePoints[i].latitude,
        routePoints[i].longitude,
        routePoints[i + 1].latitude,
        routePoints[i + 1].longitude,
      );
    }

    double distanceInKm = distanceInMeters / 1000;
    double timeInHours = elapsedTimeInSeconds / 3600;

    return distanceInKm / timeInHours;
  }

  // Kiểm tra xem có đang di chuyển không
  bool isMoving(List<LatLng> routePoints, int elapsedTimeInSeconds) {
    double currentSpeed = calculateSpeed(routePoints, elapsedTimeInSeconds);
    return currentSpeed >= minimumSpeed && currentSpeed <= maximumSpeed;
  }
}
