import 'package:fitness_tracker/features/controllers/runControllers/mapControllers/calculate_distance_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fitness_tracker/features/services/getProfile.dart';

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

  /// Tính calories đốt cháy dựa trên khoảng cách và thời gian
  /// [distanceInKm]: Khoảng cách chạy (km)
  /// [routePoints]: Danh sách các điểm trên đường đi
  /// [elapsedTimeInSeconds]: Thời gian đã trôi qua (giây)
  /// Returns: Số calories (double)
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
      final profileData = await ApiService.fetchProfileData();
      if (profileData == null) {
        print('Không thể lấy thông tin profile');
        return 0;
      }

      // Tính số bước chân
      final steps = calculateSteps(distanceInKm);

      // Tính số bước trên mỗi km
      final stepsPerKm = steps / distanceInKm;

      // Xác định hệ số dựa trên số bước/km
      double coefficient;
      if (stepsPerKm > 1333) {
        // Nhiều bước hơn (bước ngắn, chậm)
        coefficient = 3.0;
      } else if (stepsPerKm < 1333) {
        // Ít bước hơn (bước dài, nhanh)
        coefficient = 4.5;
      } else {
        // Trung bình
        coefficient = 3.5;
      }

      // Tính calories theo công thức mới
      final calories = profileData.weight! * coefficient * distanceInKm;
      print(
        'Calories calculated: $calories (weight: ${profileData.weight}kg, distance: ${distanceInKm}km, coefficient: $coefficient)',
      );

      return calories;
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
