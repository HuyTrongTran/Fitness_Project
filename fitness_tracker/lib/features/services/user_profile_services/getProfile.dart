import 'dart:convert';
import 'package:fitness_tracker/screens/userProfile/profile_data.dart';
import 'package:fitness_tracker/api/apiUrl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class GetProfileService {
  static const String baseUrl = ApiConfig.baseUrl;

  // Hàm lấy dữ liệu profile từ API
  static Future<ProfileData?> fetchProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null) {
        Get.snackbar('Error', 'No token found. Please log in again.');
        return null;
      }
      final response = await http.get(
        Uri.parse('$baseUrl/getProfile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          final data = responseData['data'];

          // Tạo một Map mới kết hợp profile và các trường khác
          final Map<String, dynamic> profileMap = {
            ...data['profile'] ?? {},
            'username':
                data['userName'] ?? data['username'], // Ưu tiên userName
            'email': data['email'],
            'profileImage': data['profileImage'],
          };

          final profileData = ProfileData.fromJson(profileMap);

          // Lưu dữ liệu profile vào SharedPreferences
          await prefs.setString('userProfile', jsonEncode(profileMap));

          return profileData;
        } else {
          Get.snackbar(
            'Error',
            responseData['message'] ?? 'Failed to fetch profile data',
          );
          return null;
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch profile data: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred while fetching profile data: $e',
      );
      return null;
    }
  }

  // Hàm cập nhật thông tin profile
  static Future<ProfileData?> updateProfile({
    String? username,
    String? email,
    String? profileImage,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null) {
        Get.snackbar('Error', 'No token found. Please log in again.');
        return null;
      }

      final response = await http.put(
        Uri.parse('$baseUrl/updateProfile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'email': email,
          'profileImage': profileImage,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          return await fetchProfileData();
        } else {
          Get.snackbar(
            'Error',
            responseData['message'] ?? 'Failed to update profile',
          );
          return null;
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to update profile: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while updating profile: $e');
      return null;
    }
  }
}
