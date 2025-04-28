// api_service.dart
import 'package:fitness_tracker/api/apiUrl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _apiBaseUrl = ApiConfig.baseUrl;
  static const String _submitRunSessionEndpoint = '/submitRunSession';

  // Hàm Future để gửi dữ liệu chạy lên server
  Future<bool> submitRunSession(int timeInSeconds, double distanceInKm) async {
    try {
      final url = Uri.parse('$_apiBaseUrl$_submitRunSessionEndpoint');
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null) {
        print('No token found');
        return false;
      }

      final body = jsonEncode({
        'time_in_seconds': timeInSeconds,
        'distance_in_km': distanceInKm,
      });
      print('Sending to API: $body');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 201) {
        print('Run session submitted successfully');
        return true;
      } else {
        print('Failed to submit: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error submitting run session: $e');
      return false;
    }
  }
}
