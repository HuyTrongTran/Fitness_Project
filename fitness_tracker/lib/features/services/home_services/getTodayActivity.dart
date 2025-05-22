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
  final Map<String, dynamic> totals;

  TodayActivityData({
    required this.distanceInKm,
    required this.steps,
    required this.calories,
    required this.activities,
    required this.totals,
  });

  factory TodayActivityData.fromJson(Map<String, dynamic> json) {
    try {
      // Lấy danh sách các hoạt động
      final List<dynamic> activitiesJson = json['data'] as List<dynamic>;
      final activities =
          activitiesJson.map((item) => ActivityItem.fromJson(item)).toList();

      // Tính tổng các giá trị
      double totalDistance = 0;
      int totalSteps = 0;
      double totalCalories = 0;

      for (var activity in activities) {
        totalDistance += activity.distanceInKm;
        totalSteps += activity.steps;
        totalCalories += activity.calories;
      }

      // Tạo map totals
      final totals = {
        'distance_in_km': totalDistance,
        'steps': totalSteps,
        'calories': totalCalories.round(),
      };

      return TodayActivityData(
        distanceInKm: totalDistance,
        steps: totalSteps,
        calories: totalCalories.round(),
        activities: activities,
        totals: totals,
      );
    } catch (e) {
      print('Error parsing TodayActivityData: $e');
      // Trả về dữ liệu mặc định nếu có lỗi
      return TodayActivityData(
        distanceInKm: 0.0,
        steps: 0,
        calories: 0,
        activities: [],
        totals: {'distance_in_km': 0.0, 'steps': 0, 'calories': 0},
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'distanceInKm': distanceInKm,
      'steps': steps,
      'calories': calories,
      'activities': activities.map((item) => item.toJson()).toList(),
      'totals': totals,
    };
  }
}

/// Lớp chứa thông tin chi tiết của một hoạt động
class ActivityItem {
  final String id;
  final DateTime date;
  final int timeInSeconds;
  final double distanceInKm;
  final double calories;
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
    try {
      return ActivityItem(
        id: json['_id']?.toString() ?? '',
        date:
            DateTime.tryParse(json['activity_date']?.toString() ?? '') ??
            DateTime.now(),
        timeInSeconds:
            json['time_in_seconds'] is int
                ? json['time_in_seconds']
                : int.tryParse(json['time_in_seconds']?.toString() ?? '0') ?? 0,
        distanceInKm:
            json['distance_in_km'] is num
                ? (json['distance_in_km'] as num).toDouble()
                : double.tryParse(json['distance_in_km']?.toString() ?? '0') ??
                    0.0,
        calories:
            json['calories'] is num
                ? (json['calories'] as num).toDouble()
                : double.tryParse(json['calories']?.toString() ?? '0') ?? 0.0,
        steps:
            json['steps'] is int
                ? json['steps']
                : int.tryParse(json['steps']?.toString() ?? '0') ?? 0,
        routePoints:
            (json['route_points'] as List?)
                ?.map((point) => RoutePoint.fromJson(point))
                .toList() ??
            [],
      );
    } catch (e) {
      print('Error parsing ActivityItem: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'activity_date': date.toIso8601String(),
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
        throw Exception('Invalid token');
      }

      const apiUrl = '${ApiConfig.baseUrl}/today-activity';
      // Gọi API để lấy dữ liệu hoạt động của ngày hôm nay
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Log response body
      print('Response body get today activity: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          return TodayActivityData.fromJson(data);
        } else {
          throw Exception('API returned success: false');
        }
      } else {
        throw Exception('Cannot fetch activity data: ${response.statusCode}');
      }
    } catch (e) {
      // Trả về dữ liệu mặc định nếu có lỗi
      return TodayActivityData(
        distanceInKm: 0.0,
        steps: 0,
        calories: 0,
        activities: [],
        totals: {},
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
    return activityData.totals['calories'] as int;
  }
}
