class ProfileData {
  final double? height;
  final String? username;
  final String? email;
  final double? weight;
  final String? gender;
  final String? goal;
  final String? activityLevel;
  final int? age;
  final double? bmi;
  final String? profileImage;
  // final List<String>? activities;
  ProfileData({
    this.height,
    this.username,
    this.email,
    this.weight,
    this.gender,
    this.goal,
    this.activityLevel,
    this.age,
    this.bmi,
    this.profileImage,
    // this.activities,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    final profileData = ProfileData(
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      gender: json['gender'] as String?,
      goal: json['goal'] as String?,
      activityLevel: json['activityLevel'] as String?,
      age: json['age'] as int?,
      bmi: (json['bmi'] as num?)?.toDouble(),
      username: json['username'] as String?,
      email: json['email'] as String?,
      profileImage: json['profileImage'] as String?,
      // activities: json['activities'] as List<String>?,
    );
    return profileData;
  }
}
