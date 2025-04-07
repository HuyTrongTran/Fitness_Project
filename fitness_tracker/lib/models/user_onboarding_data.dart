// Tạo file mới: lib/models/user_onboarding_data.dart
class UserOnboardingData {
  String? gender;
  int? age;
  double? height;
  double? weight;
  String? goal;
  String? activityLevel;
  double? bmi;

  UserOnboardingData({
    this.gender,
    this.age,
    this.height,
    this.weight,
    this.goal,
    this.activityLevel,
    this.bmi,
  });

  Map<String, dynamic> toJson() => {
    'gender': gender,
    'age': age,
    'height': height,
    'weight': weight,
    'goal': goal,
    'activityLevel': activityLevel,
    'bmi': bmi,
  };
}
