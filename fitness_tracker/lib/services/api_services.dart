import 'dart:convert';
import 'package:fitness_tracker/userProfile/profile_data.dart';
import 'package:fitness_tracker/utils/apiUrl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class ApiService {
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
          return ProfileData.fromJson(responseData['data']['profile']);
        } else {
          Get.snackbar('Error', responseData['message'] ?? 'Failed to fetch profile data');
          return null;
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch profile data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching profile data: $e');
      return null;
    }
  }
} 