import 'dart:convert';
import 'package:fitness_tracker/api/apiUrl.dart';
import 'package:http/http.dart' as http;
import 'package:fitness_tracker/screens/runSessionFeature/runSession.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class RunHistoryService {
  static Future<List<RunSession>> getRunHistory({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // Lấy token từ SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Tạo query parameters
      Map<String, String> queryParams = {};
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      // Gọi API
      final response = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/run-history',
        ).replace(queryParameters: queryParams),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return (data['data'] as List).map((activity) {
            // Chuyển đổi route_points từ API thành List<LatLng>
            List<LatLng> routePoints = [];
            if (activity['route_points'] != null) {
              routePoints =
                  (activity['route_points'] as List).map((point) {
                    return LatLng(
                      (point['latitude'] ?? 0.0).toDouble(),
                      (point['longitude'] ?? 0.0).toDouble(),
                    );
                  }).toList();
            }

            return RunSession(
              date: DateTime.parse(
                activity['date'] ?? DateTime.now().toIso8601String(),
              ),
              elapsedTimeInSeconds: activity['time_in_seconds'] ?? 0,
              distanceInKm: (activity['distance_in_km'] ?? 0.0).toDouble(),
              routePoints: routePoints,
              steps: activity['steps'] ?? 0,
              calories: (activity['calories'] ?? 0.0).toDouble(),
            );
          }).toList();
        }
      }

      throw Exception('Failed to load run history');
    } catch (e) {
      debugPrint('Error getting run history: $e');
      return [];
    }
  }

  static Future<bool> submitRunSession(RunSession session) async {
    try {
      // Lấy token từ SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null) {
        debugPrint('No authentication token found');
        return false;
      }

      debugPrint('Token found: ${token.substring(0, 10)}...');

      // Kiểm tra dữ liệu session
      debugPrint('Session data:');
      debugPrint('- Time: ${session.elapsedTimeInSeconds} seconds');
      debugPrint('- Distance: ${session.distanceInKm} km');
      debugPrint('- Steps: ${session.steps}');
      debugPrint('- Calories: ${session.calories}');
      debugPrint('- Route points: ${session.routePoints.length} points');

      // Chuyển đổi route_points thành format phù hợp với API
      List<Map<String, double>> routePoints =
          session.routePoints.map((point) {
            return {'latitude': point.latitude, 'longitude': point.longitude};
          }).toList();

      // Tạo request body với đầy đủ các trường bắt buộc
      final requestBody = {
        'time_in_seconds': session.elapsedTimeInSeconds,
        'distance_in_km': session.distanceInKm,
        'route_points': routePoints,
        'activity_date': session.date.toIso8601String().split('T')[0],
        'activity_type': 'run',
        'steps': session.steps,
        'calories': session.calories,
      };

      // Log request details
      debugPrint('\nRequest details:');
      debugPrint('URL: ${ApiConfig.baseUrl}/run-history');
      debugPrint('Headers:');
      debugPrint('- Content-Type: application/json');
      debugPrint('- Authorization: Bearer ${token.substring(0, 10)}...');
      debugPrint('Body:');
      debugPrint(json.encode(requestBody));

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/submitRunSession'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(requestBody),
      );

      debugPrint('\nResponse details:');
      debugPrint('Status code: ${response.statusCode}');
      debugPrint('Body: ${response.body}');

      if (response.statusCode != 201) {
        final errorBody = json.decode(response.body);
        debugPrint('Error details: $errorBody');

        if (response.statusCode == 401) {
          throw Exception('Session expired. Please login again.');
        } else if (response.statusCode == 400) {
          throw Exception(
            'Invalid data: ${errorBody['error'] ?? 'Unknown error'}',
          );
        } else {
          throw Exception(
            'Server error: ${errorBody['error'] ?? 'Unknown error'}',
          );
        }
      }

      return true;
    } catch (e) {
      debugPrint('Error submitting run session: $e');
      rethrow; // Ném lại lỗi để xử lý ở tầng trên
    }
  }
}
