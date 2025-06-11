import 'package:fitness_tracker/api/apiUrl.dart';
import 'package:fitness_tracker/common/widgets/custome_shape/custome_snackbar/customSnackbar.dart';
import 'package:fitness_tracker/screens/password_configuration/passwordMailServices.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:get/get.dart';

// Using API forgot password
class ForgotPasswordService {

  Future<bool> forgotPassword(String email) async {
    try {
      showCustomSnackbar(
        'Processing',
        'Sending temporary password...',
        type: SnackbarType.processing,
      );
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/forgot-password'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email}),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception(
                'Request timeout. Please check your internet connection.',
              );
            },
          );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          final message =
              responseData['message'] ??
              'A temporary password has been sent to your email successfully!';
          showCustomSnackbar('Success', message, type: SnackbarType.success);
          Get.to(() => const TemporaryPasswordSent());
          return true;
        } else {
          final errorMessage =
              responseData['message'] ?? 'Failed to send temporary password';
          showCustomSnackbar('Error', errorMessage, type: SnackbarType.error);
          return false;
        }
      } else {
        // Handle error response (400, 404, etc.)
        try {
          final responseData = jsonDecode(response.body);
          String errorMessage =
              responseData['message'] ?? 'Failed to send temporary password';

          // Handle specific error cases
          if (response.statusCode == 400) {
            errorMessage = responseData['message'] ?? 'Email is required';
          } else if (response.statusCode == 404) {
            errorMessage =
                responseData['message'] ??
                'User not found with this email address';
          }

          showCustomSnackbar('Error', errorMessage, type: SnackbarType.error);
        } catch (e) {
          showCustomSnackbar(
            'Error',
            'Failed to send temporary password',
            type: SnackbarType.error,
          );
        }
        return false;
      }
    } catch (e) {
      String errorMessage = 'An error occurred';
      if (e.toString().contains('timeout')) {
        errorMessage =
            'Request timeout. Please check your internet connection.';
      } else if (e.toString().contains('SocketException')) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else if (e.toString().contains('FormatException')) {
        errorMessage = 'Invalid server response. Please try again.';
      }

      showCustomSnackbar('Error', errorMessage, type: SnackbarType.error);
      print('Error details: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> resetPassword({
    required String newPassword,
  }) async {
    try {

      // Get JWT token for authentication
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null) {
        return {
          'success': false,
          'message': 'Authentication required. Please log in again.',
        };
      }

      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/reset-password'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({'newPassword': newPassword}),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception(
                'Request timeout. Please check your internet connection.',
              );
            },
          );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          return {
            'success': true,
            'message':
                responseData['message'] ??
                'Password has been reset successfully',
          };
        } else {
          return {
            'success': false,
            'message': responseData['message'] ?? 'Failed to reset password',
          };
        }
      } else {
        // Handle specific error status codes
        try {
          final responseData = jsonDecode(response.body);
          String errorMessage =
              responseData['message'] ?? 'Failed to reset password';

          if (response.statusCode == 400) {
            errorMessage =
                responseData['message'] ??
                'Invalid password or password too short';
          } else if (response.statusCode == 401) {
            errorMessage =
                responseData['message'] ??
                'Authentication failed. Please log in again.';
          } else if (response.statusCode == 404) {
            errorMessage = responseData['message'] ?? 'User not found';
          }

          return {'success': false, 'message': errorMessage};
        } catch (e) {
          return {
            'success': false,
            'message': 'Failed to reset password. Please try again.',
          };
        }
      }
    } catch (e) {
      print('Reset password error: $e');
      String errorMessage = 'An error occurred while resetting password';

      if (e.toString().contains('timeout')) {
        errorMessage =
            'Request timeout. Please check your internet connection.';
      } else if (e.toString().contains('SocketException')) {
        errorMessage = 'Network error. Please check your internet connection.';
      }

      return {'success': false, 'message': errorMessage};
    }
  }
}
