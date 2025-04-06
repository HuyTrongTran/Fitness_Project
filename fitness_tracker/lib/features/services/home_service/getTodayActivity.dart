import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api/apiUrl.dart';

/// Lớp chứa dữ liệu hoạt động của ngày hôm nay
class TodayActivityData {
  final double distanceInKm;
  final int steps;
  final int calories;
  final List<ActivityItem> activities;

  TodayActivityData({
    required this.distanceInKm,
    required this.steps,
    required this.calories,
    required this.activities,
  });

  factory TodayActivityData.fromJson(Map<String, dynamic> json) {
    print('Parsing TodayActivityData from JSON: $json');
    try {
      return TodayActivityData(
        distanceInKm: (json['totals']['distance_in_km'] as num).toDouble(),
        steps: json['totals']['steps'] as int,
        calories: json['totals']['calories'] as int,
        activities:
            (json['data'] as List)
                .map((item) => ActivityItem.fromJson(item))
                .toList(),
      );
    } catch (e) {
      print('Error parsing TodayActivityData: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'distanceInKm': distanceInKm,
      'steps': steps,
      'calories': calories,
      'activities': activities.map((item) => item.toJson()).toList(),
    };
  }
}

/// Lớp chứa thông tin chi tiết của một hoạt động
class ActivityItem {
  final String id;
  final DateTime date;
  final int timeInSeconds;
  final double distanceInKm;
  final int calories;
  final int steps;
  final List<RoutePoint> routePoints;

  ActivityItem({
    required this.id,
    required this.date,
    required this.timeInSeconds,
    required this.distanceInKm,
    required this.calories,
    required this.steps,
    required this.routePoints,
  });

  factory ActivityItem.fromJson(Map<String, dynamic> json) {
    print('Parsing ActivityItem from JSON: $json');
    try {
      return ActivityItem(
        id: json['id'] as String,
        date: DateTime.parse(json['date'] as String),
        timeInSeconds: json['time_in_seconds'] as int,
        distanceInKm: (json['distance_in_km'] as num).toDouble(),
        calories: json['calories'] as int,
        steps: json['steps'] as int,
        routePoints:
            (json['route_points'] as List)
                .map((point) => RoutePoint.fromJson(point))
                .toList(),
      );
    } catch (e) {
      print('Error parsing ActivityItem: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'time_in_seconds': timeInSeconds,
      'distance_in_km': distanceInKm,
      'calories': calories,
      'steps': steps,
      'route_points': routePoints.map((point) => point.toJson()).toList(),
    };
  }
}

/// Lớp chứa thông tin về một điểm trên lộ trình
class RoutePoint {
  final double latitude;
  final double longitude;

  RoutePoint({required this.latitude, required this.longitude});

  factory RoutePoint.fromJson(Map<String, dynamic> json) {
    print('Parsing RoutePoint from JSON: $json');
    try {
      return RoutePoint(
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
      );
    } catch (e) {
      print('Error parsing RoutePoint: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude};
  }
}

/// Lớp service để lấy dữ liệu hoạt động của ngày hôm nay
class GetTodayActivityService {
  /// Lấy dữ liệu hoạt động của ngày hôm nay từ API
  static Future<TodayActivityData> getTodayActivity() async {
    try {
      // Lấy token từ SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null) {
        print('Token is null, cannot fetch activity data');
        throw Exception('Invalid token');
      }

      print('Using token: ${token.substring(0, 10)}...');
      print('API URL: ${ApiConfig.baseUrl}/run-history');

      // Gọi API để lấy dữ liệu hoạt động của ngày hôm nay
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/run-history'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Decoded response: $data');

        if (data['success'] == true) {
          return TodayActivityData.fromJson(data);
        } else {
          print('API returned success: false');
          throw Exception('API returned success: false');
        }
      } else {
        print('Error response: ${response.statusCode} - ${response.body}');
        throw Exception('Cannot fetch activity data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching activity data: $e');
      // Trả về dữ liệu mặc định nếu có lỗi
      return TodayActivityData(
        distanceInKm: 0.0,
        steps: 0,
        calories: 0,
        activities: [],
      );
    }
  }

  /// Lấy tổng khoảng cách của ngày hôm nay
  static Future<double> getTodayDistance() async {
    final activityData = await getTodayActivity();
    return activityData.distanceInKm;
  }

  /// Lấy tổng số bước của ngày hôm nay
  static Future<int> getTodaySteps() async {
    final activityData = await getTodayActivity();
    return activityData.steps;
  }

  /// Lấy tổng calories của ngày hôm nay
  static Future<int> getTodayCalories() async {
    final activityData = await getTodayActivity();
    return activityData.calories;
  }
}
