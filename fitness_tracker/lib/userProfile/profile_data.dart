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
  // final String? avatar;
  final String? profileImage;
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
    // this.avatar,  
    this.profileImage,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    // Lấy profile data từ response
    final profile = json['profile'] as Map<String, dynamic>? ?? {};

    return ProfileData(
      height: (profile['height'] as num?)?.toDouble(),
      weight: (profile['weight'] as num?)?.toDouble(),
      gender: profile['gender'] as String?,
      goal: profile['goal'] as String?,
      activityLevel: profile['activityLevel'] as String?,
      age: profile['age'] as int?,
      bmi: (profile['bmi'] as num?)?.toDouble(),
      username: json['username'] as String?, // Lấy username từ root level
      email: json['email'] as String?,
      profileImage: json['profileImage'] as String?,
      // // Lấy email từ root level
      // avatar: json['avatar'] as String?,
    );
  }
}
