class ProfileData {
  final double? height;
  final double? weight;
  final String? gender;
  final String? goal;
  final String? activityLevel;
  final int? age;
  final double? bmi;

  ProfileData({
    this.height,
    this.weight,
    this.gender,
    this.goal,
    this.activityLevel,
    this.age,
    this.bmi,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      gender: json['gender'] as String?,
      goal: json['goal'] as String?,
      activityLevel: json['activityLevel'] as String?,
      age: json['age'] as int?,
      bmi: (json['bmi'] as num?)?.toDouble(),
    );
  }
}