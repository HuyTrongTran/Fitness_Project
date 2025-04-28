import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:fitness_tracker/api/apiUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentPlanService extends GetxService {
  final String _baseUrl = ApiConfig.baseUrl;

  // Mapping từ goal hiển thị sang goal trong API
  final Map<String, String> goalMapping = {
    "Lose Weight": "weight_loss",
    "Gain Weight": "weight_gain",
    "Stay Fit": "stay_fit",
  };

  // Đăng ký service với GetX
  static void init() {
    Get.put(RecentPlanService());
  }

  Future<List<SuggestFood>> getSuggestFoodByGoal(String goal) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      print('Getting suggest foods with token: $token');

      if (token == null || token.isEmpty) {
        print('No token found in SharedPreferences');
        return [];
      }

      // Map goal sang định dạng API
      final apiGoal = goalMapping[goal] ?? goal;
      print('Original goal: $goal');
      print('Mapped goal for API: $apiGoal');

      // Encode goal parameter
      final encodedGoal = Uri.encodeComponent(apiGoal);
      final url = Uri.parse(
        '$_baseUrl/get-suggest-foods-by-support/$encodedGoal',
      );
      print('Calling API with encoded URL: $url');

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      print('Request headers: $headers');

      final response = await http.get(url, headers: headers);

      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Decoded data: $data');

        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> foodsJson = data['data']['suggestFoods'] ?? [];
          print('Number of foods found: ${foodsJson.length}');

          final foods =
              foodsJson.map((json) {
                print('Processing food: $json');
                return SuggestFood.fromJson(json);
              }).toList();

          print('Successfully parsed ${foods.length} foods');
          return foods;
        } else {
          print('API returned success: false or no data');
          return [];
        }
      } else {
        print('API call failed with status: ${response.statusCode}');
        print('Error response: ${response.body}');
        return [];
      }
    } catch (e, stackTrace) {
      print('Error in getSuggestFoodByGoal: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }
}

class SuggestFood {
  final String id;
  final String title;
  final String image;
  final String description;
  final List<Step> steps;
  final String supportFor;

  SuggestFood({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.steps,
    required this.supportFor,
  });

  factory SuggestFood.fromJson(Map<String, dynamic> json) {
    return SuggestFood(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      steps:
          (json['steps'] as List<dynamic>?)
              ?.map((step) => Step.fromJson(step))
              .toList() ??
          [],
      supportFor: json['support_for'] ?? '',
    );
  }
}

class Step {
  final int stepNumber;
  final String instruction;

  Step({required this.stepNumber, required this.instruction});

  factory Step.fromJson(Map<String, dynamic> json) {
    return Step(
      stepNumber: json['step_number'] ?? 0,
      instruction: json['instruction'] ?? '',
    );
  }
}
