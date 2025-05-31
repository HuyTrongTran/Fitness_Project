import 'dart:convert';
import 'package:fitness_tracker/api/apiUrl.dart';
import 'package:http/http.dart' as http;

class VerifyEmailServices {
  Future<String> verifyEmail(String email) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/verify-email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return response.body;
    }
  }

  Future<String> resendEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/resend-verification'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } catch (e) {
      return e.toString();
    }
  }
}
