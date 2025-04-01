import 'dart:convert';
import 'package:fitness_tracker/userProfile/profile_data.dart';
import 'package:fitness_tracker/api/apiUrl.dart';
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

      print('Token: $token'); // Debug token

      if (token == null) {
        print('No token found'); // Debug no token
        Get.snackbar('Error', 'No token found. Please log in again.');
        return null;
      }

      print('Calling API: $baseUrl/getProfile'); // Debug API URL
      final response = await http.get(
        Uri.parse('$baseUrl/getProfile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}'); // Debug response status
      print('Response body: ${response.body}'); // Debug response body

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Decoded response: $responseData'); // Debug decoded response

        if (responseData['success'] == true) {
          final data = responseData['data'];
          print('Profile data: $data'); // Debug profile data

          // Tạo một Map mới kết hợp profile và các trường khác
          final Map<String, dynamic> profileMap = {
            ...data['profile'] ?? {},
            'username': data['username'],
            'email': data['email'],
          };

          return ProfileData.fromJson(profileMap);
        } else {
          print('API error: ${responseData['message']}'); // Debug API error
          Get.snackbar(
            'Error',
            responseData['message'] ?? 'Failed to fetch profile data',
          );
          return null;
        }
      } else {
        print('HTTP error: ${response.statusCode}'); // Debug HTTP error
        Get.snackbar(
          'Error',
          'Failed to fetch profile data: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      print('Exception: $e'); // Debug exception
      Get.snackbar(
        'Error',
        'An error occurred while fetching profile data: $e',
      );
      return null;
    }
  }
}
