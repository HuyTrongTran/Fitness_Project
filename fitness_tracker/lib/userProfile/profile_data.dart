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
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    print('Parsing JSON: $json'); // Debug input JSON

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
    );

    print(
      'Parsed profile data: height=${profileData.height}, weight=${profileData.weight}, goal=${profileData.goal}, activityLevel=${profileData.activityLevel}, username=${profileData.username}, email=${profileData.email}',
    ); // Debug parsed data
    return profileData;
  }
}
