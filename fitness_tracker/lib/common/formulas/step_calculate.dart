import 'dart:core';

import 'package:fitness_tracker/features/controllers/runControllers/mapControllers/calculate_distance_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fitness_tracker/features/services/user_profile_services/getProfile.dart';

class StepCalculator {
  // Độ dài bước chân trung bình (mét)
  static const double averageStepLength = 0.75;

  /// Tính số bước chân dựa trên khoảng cách
  /// [distanceInKm]: Khoảng cách chạy (km)
  /// Returns: Số bước chân (int)
  static int calculateSteps(double distanceInKm) {
    // Chuyển đổi km sang mét
    double distanceInMeters = distanceInKm * 1000;

    // Tính số bước chân
    return (distanceInMeters / averageStepLength).round();
  }

  /// Tính số calories tiêu thụ dựa trên khoảng cách, điểm dừng và thời gian
  /// Sử dụng công thức MET chính xác: Calories/phút = (MET × cân nặng × 3.5) / 200
  static Future<double> caloriesCaculator(
    double distanceInKm,
    List<LatLng> routePoints,
    int elapsedTimeInSeconds,
  ) async {
    try {
      // Kiểm tra xem có đang di chuyển không
      final calculator = CalculateDistanceController();
      if (!calculator.isMoving(routePoints, elapsedTimeInSeconds)) {
        return 0;
      }

      // Lấy thông tin profile để lấy cân nặng
      final profileData = await GetProfileService.fetchProfileData();
      if (profileData == null) {
        return 0;
      }

      // Tính tốc độ chạy (km/h)
      final timeInHours = elapsedTimeInSeconds / 3600;
      if (timeInHours == 0) return 0;

      final runSpeed = distanceInKm / timeInHours;

      // Xác định giá trị MET dựa trên tốc độ chạy theo bảng chuẩn
      double metValue = _getMETValueBySpeed(runSpeed);

      // Tính calories tiêu thụ mỗi phút theo công thức: (MET × cân nặng × 3.5) / 200
      final caloriesPerMinute = (metValue * profileData.weight! * 3.5) / 200;

      // Tính tổng calories tiêu thụ
      final timeInMinutes = elapsedTimeInSeconds / 60;
      final totalCalories = caloriesPerMinute * timeInMinutes;

      print(
        'Calories calculated: ${totalCalories.toStringAsFixed(2)} '
        '(weight: ${profileData.weight}kg, speed: ${runSpeed.toStringAsFixed(2)}km/h, '
        'MET: $metValue, time: ${timeInMinutes.toStringAsFixed(2)}min)',
      );

      return totalCalories;
    } catch (e) {
      print('Error calculating calories: $e');
      return 0;
    }
  }

  /// Xác định giá trị MET dựa trên tốc độ chạy theo bảng chuẩn
  static double _getMETValueBySpeed(double speedKmh) {
    if (speedKmh < 6.43) {
      return 5.0; // Chạy chậm hơn 6.43km/h
    } else if (speedKmh < 8.0) {
      return 5.0; // Chạy 6.43km/h (9,3p/km)
    } else if (speedKmh < 8.4) {
      return 8.0; // Chạy 8km/h (7,5p/km)
    } else if (speedKmh < 9.7) {
      return 9.0; // Chạy 8,4km/h (7,1p/km) hoặc chạy việt dã
    } else if (speedKmh < 10.8) {
      return 9.8; // Chạy 9,7km/h (6,2p/km)
    } else if (speedKmh < 11.3) {
      return 10.5; // Chạy 10,8km/h (5,5p/km)
    } else if (speedKmh < 12.1) {
      return 11.0; // Chạy 11,3km/h (5,3p/km)
    } else if (speedKmh < 12.9) {
      return 11.5; // Chạy 12,1km/h (5p/km)
    } else if (speedKmh < 13.8) {
      return 11.8; // Chạy 12,9km/h (4,65p/km)
    } else if (speedKmh < 14.5) {
      return 12.3; // Chạy 13,8km/h (4,35p/km)
    } else if (speedKmh < 16.1) {
      return 12.8; // Chạy 14,5km/h (4,13p/km)
    } else if (speedKmh < 17.7) {
      return 14.5; // Chạy 16,1km/h (3,72p/km)
    } else if (speedKmh < 19.3) {
      return 16.0; // Chạy 17,7km/h (3,39p/km)
    } else if (speedKmh < 21.0) {
      return 19.0; // Chạy 19,3km/h (3,1p/km)
    } else if (speedKmh < 22.5) {
      return 19.8; // Chạy 21km/h (2,85p/km)
    } else {
      return 23.0; // Chạy 22,5km/h (2,66p/km) hoặc nhanh hơn
    }
  }

  static Future<double> calculateCalories(
    double distanceInKm,
    List<LatLng> routePoints,
    int elapsedTimeInSeconds,
  ) async {
    try {
      // Kiểm tra xem có đang di chuyển không
      final calculator = CalculateDistanceController();
      if (!calculator.isMoving(routePoints, elapsedTimeInSeconds)) {
        return 0;
      }

      // Lấy thông tin profile để lấy cân nặng
      final profileData = await GetProfileService.fetchProfileData();
      if (profileData == null) {
        print('Unable to fetch profile data');
        return 0;
      }

      // Tính tốc độ chạy (km/h)
      final timeInHours = elapsedTimeInSeconds / 3600;
      if (timeInHours == 0) return 0;

      final runSpeed = distanceInKm / timeInHours;

      // Xác định giá trị MET dựa trên tốc độ chạy
      double metValue = _getMETValueBySpeed(runSpeed);

      // Tính calories tiêu thụ mỗi phút theo công thức: (MET × cân nặng × 3.5) / 200
      final caloriesPerMinute = (metValue * profileData.weight! * 3.5) / 200;

      // Tính tổng calories tiêu thụ
      final timeInMinutes = elapsedTimeInSeconds / 60;
      final totalCalories = caloriesPerMinute * timeInMinutes;

      print(
        'Calories calculated: ${totalCalories.toStringAsFixed(2)} '
        '(weight: ${profileData.weight}kg, speed: ${runSpeed.toStringAsFixed(2)}km/h, '
        'MET: $metValue, time: ${timeInMinutes.toStringAsFixed(2)}min)',
      );

      return totalCalories;
    } catch (e) {
      print('Error calculating calories: $e');
      return 0;
    }
  }

  /// Tính tốc độ chạy (km/h) dựa trên khoảng cách và thời gian
  /// [distanceInKm]: Khoảng cách chạy (km)
  /// [elapsedTimeInSeconds]: Thời gian đã trôi qua (giây)
  /// Returns: Tốc độ (km/h)
  static double calculateSpeed(double distanceInKm, int elapsedTimeInSeconds) {
    if (elapsedTimeInSeconds == 0) return 0.0;
    double timeInHours = elapsedTimeInSeconds / 3600;
    return distanceInKm / timeInHours;
  }

  /// Tính nhịp chạy (số bước/phút) dựa trên số bước và thời gian
  /// [steps]: Số bước chân
  /// [elapsedTimeInSeconds]: Thời gian đã trôi qua (giây)
  /// Returns: Nhịp chạy (bước/phút)
  static double calculateCadence(int steps, int elapsedTimeInSeconds) {
    if (elapsedTimeInSeconds == 0) return 0.0;
    double timeInMinutes = elapsedTimeInSeconds / 60;
    return steps / timeInMinutes;
  }
}
