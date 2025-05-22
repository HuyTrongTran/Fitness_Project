import 'dart:math';
import '../../../screens/userProfile/profile_data.dart';
import 'package:fitness_tracker/features/services/fitbot_assitance/recommend_activityLevel.dart';

/// Lớp chứa thông tin về mục tiêu hoạt động của người dùng
class ActivityTarget {
  final double targetDistance; // km
  final int targetSteps;
  final int targetCalories;
  final double targetWater;

  ActivityTarget({
    required this.targetDistance,
    required this.targetSteps,
    required this.targetCalories,
    required this.targetWater,
  });

  @override
  String toString() {
    return 'ActivityTarget(distance: '
        '[32m$targetDistance[0m, steps: '
        '[34m$targetSteps[0m, calories: '
        '[31m$targetCalories[0m)';
  }

  /// Tính toán mục tiêu dựa trên thông tin người dùng
  static ActivityTarget calculateFromProfile(ProfileData profile) {
    final weight = profile.weight ?? 60.0; // kg
    final height = profile.height ?? 170.0; // cm
    final age = profile.age ?? 30;
    final gender = profile.gender?.toLowerCase() ?? 'male';
    final activityLevel = profile.activityLevel?.toLowerCase() ?? 'moderate';
    final goal = profile.goal?.toLowerCase() ?? 'maintain';

    // Tính BMR (Basal Metabolic Rate) theo công thức Mifflin-St Jeor
    double bmr;
    if (gender == 'male') {
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    }

    // Tính TDEE (Total Daily Energy Expenditure) dựa trên mức độ hoạt động
    double tdee = bmr;
    switch (activityLevel) {
      case 'sedentary':
        tdee *= 1.2; // Ít vận động
        break;
      case 'light':
        tdee *= 1.375; // Nhẹ (1-3 ngày/tuần)
        break;
      case 'moderate':
        tdee *= 1.55; // Vừa phải (3-5 ngày/tuần)
        break;
      case 'active':
        tdee *= 1.725; // Năng động (6-7 ngày/tuần)
        break;
      case 'very active':
        tdee *= 1.9; // Rất năng động (2 lần/ngày)
        break;
      default:
        tdee *= 1.55; // Mặc định là vừa phải
    }

    // Điều chỉnh TDEE dựa trên mục tiêu
    double targetCalories;
    switch (goal) {
      case 'lose':
        targetCalories = tdee - 500; // Giảm 500 cal để giảm cân
        break;
      case 'gain':
        targetCalories = tdee + 500; // Tăng 500 cal để tăng cân
        break;
      case 'maintain':
      default:
        targetCalories = tdee; // Duy trì cân nặng
    }

    // Tính mục tiêu calories đốt cháy từ hoạt động thể chất (30% của TDEE)
    final activityCalories = (tdee * 0.3).round();

    // Tính mục tiêu bước chân dựa trên mức độ hoạt động và mục tiêu
    int targetSteps;
    switch (activityLevel) {
      case 'sedentary':
        targetSteps = 5000;
        break;
      case 'light':
        targetSteps = 7500;
        break;
      case 'moderate':
        targetSteps = 10000;
        break;
      case 'active':
        targetSteps = 12500;
        break;
      case 'very active':
        targetSteps = 15000;
        break;
      default:
        targetSteps = 10000; // Mặc định là 10,000 bước
    }

    // Điều chỉnh mục tiêu bước chân dựa trên mục tiêu
    if (goal == 'lose') {
      targetSteps = (targetSteps * 1.2).round();
    } else if (goal == 'gain') {
      targetSteps = (targetSteps * 0.8).round();
    }

    // Tính chiều dài bước chân (mét)
    double stepLength;
    if (gender == 'male') {
      stepLength = height * 0.415 / 100; // cm -> m
    } else {
      stepLength = height * 0.413 / 100;
    }

    // Tính quãng đường (km)
    double targetDistance = (targetSteps * stepLength) / 1000;

    return ActivityTarget(
      targetDistance: double.parse(
        targetDistance.toStringAsFixed(2),
      ), // làm tròn 2 số lẻ
      targetSteps: targetSteps,
      targetCalories: activityCalories,
      targetWater: 2.0,
    );
  }

  /// Tính toán mục tiêu dựa trên BMI
  static ActivityTarget calculateFromBMI(ProfileData profile) {
    final weight = profile.weight ?? 60.0; // kg
    final height = profile.height ?? 170.0; // cm
    final bmi = profile.bmi ?? (weight / pow(height / 100, 2));

    // Xác định mục tiêu dựa trên BMI
    int targetSteps;
    double targetDistance;
    int targetCalories;

    if (bmi < 18.5) {
      // Thiếu cân
      targetSteps = 8000;
      targetDistance = 5.6; // km
      targetCalories = 300;
    } else if (bmi < 25) {
      // Bình thường
      targetSteps = 10000;
      targetDistance = 7.0; // km
      targetCalories = 400;
    } else if (bmi < 30) {
      // Thừa cân
      targetSteps = 12000;
      targetDistance = 8.4; // km
      targetCalories = 500;
    } else {
      // Béo phì
      targetSteps = 15000;
      targetDistance = 10.5; // km
      targetCalories = 600;
    }

    return ActivityTarget(
      targetDistance: targetDistance,
      targetSteps: targetSteps,
      targetCalories: targetCalories,
      targetWater: 2.0,
    );
  }

  /// Lấy mục tiêu phù hợp nhất dựa trên profile
  static Future<ActivityTarget> getRecommendedTarget(
    ProfileData profile,
  ) async {
    // Luôn thử lấy target từ AI nếu đủ thông tin profile
    if (profile.age != null &&
        profile.weight != null &&
        profile.height != null &&
        profile.bmi != null &&
        profile.goal != null) {
      final aiResult = await recommendDailyTarget(
        userId: 'default_user',
        age: profile.age!,
        weight: profile.weight!,
        height: profile.height!,
        bmi: profile.bmi!,
        goal: profile.goal!,
      );
      if (aiResult.isNotEmpty) {
        return ActivityTarget(
          targetDistance: (aiResult['distance'] as num?)?.toDouble() ?? 7.0,
          targetSteps: (aiResult['steps'] as num?)?.toInt() ?? 10000,
          targetCalories: (aiResult['calories'] as num?)?.toInt() ?? 400,
          targetWater: (aiResult['water'] as num?)?.toDouble() ?? 8.0,
        );
      } else {
        print(
          '[DEBUG] aiResult rỗng hoặc parse lỗi, fallback về logic truyền thống',
        );
      }
    }
    // Nếu không đủ thông tin hoặc AI không trả về, fallback logic cũ
    if (profile.weight != null &&
        profile.height != null &&
        profile.age != null) {
      return calculateFromProfile(profile);
    } else if (profile.bmi != null) {
      return calculateFromBMI(profile);
    } else {
      return ActivityTarget(
        targetDistance: 7.0,
        targetSteps: 10000,
        targetCalories: 400,
        targetWater: 2.0,
      );
    }
  }
}
