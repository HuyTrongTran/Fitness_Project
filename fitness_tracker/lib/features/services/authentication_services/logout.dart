import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_tracker/api/apiUrl.dart';
import 'package:fitness_tracker/screens/authentication/Login/login.dart';
import 'package:get/get.dart';

class LogoutService {
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token != null) {
      try {
        const String apiUrl = '${ApiConfig.baseUrl}/logout';
        await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
       
      } catch (e) {
        print('Error during logout: $e');
      }
    }

    // Xóa token ở client
    await prefs.remove('jwt_token');
    Get.offAll(() => const Login());
  }
}   
