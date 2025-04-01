import 'dart:convert';
import 'package:fitness_tracker/api/apiUrl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutPlan {
  static const String _apiBaseUrl = ApiConfig.baseUrl;
  static const String _submitWorkoutPlanEndpoint = '/add-to-plan';
  static const String _getWorkoutPlanEndpoint =
      '/api/exercise/get-workout-plan';

  Future<bool> submitWorkoutPlan(
    String exerciseName,
    String exerciseSubTitle,
    String dateToDo,
    int setToDo,
    int kcalToDo,
    int timeToDo,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      final url = Uri.parse('$_apiBaseUrl$_submitWorkoutPlanEndpoint');

      if (token == null) {
        print('No token found');
        return false;
      }

      final body = jsonEncode({
        'exercise_name': exerciseName,
        'exercise_sub_title': exerciseSubTitle,
        'date_to_do': dateToDo,
        'set_to_do': setToDo,
        'kcal_to_do': kcalToDo,
        'time_to_do': timeToDo,
      });

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 201) {
        print('Workout plan submitted successfully');
        return true;
      } else {
        print('Failed to submit: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error submitting workout plan: $e');
      return false;
    }
  }
}
