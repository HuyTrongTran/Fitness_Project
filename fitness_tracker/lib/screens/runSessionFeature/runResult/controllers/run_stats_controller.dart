import 'package:flutter/foundation.dart';
import 'package:fitness_tracker/screens/runSessionFeature/runSession.dart';
import 'package:fitness_tracker/features/services/run_history_service.dart';

class RunStatsController {
  // Lấy session có quãng đường dài nhất
  static Future<RunSession?> getBestSession() async {
    try {
      final sessions = await RunHistoryService.getRunHistory();
      if (sessions.isEmpty) return null;

      // Sắp xếp các session theo quãng đường giảm dần
      sessions.sort((a, b) => b.distanceInKm.compareTo(a.distanceInKm));

      // Trả về session có quãng đường dài nhất
      final bestSession = sessions.first;
      print("Best session is: ${bestSession.distanceInKm} km");
      return bestSession;
    } catch (e) {
      print('Error getting best session: $e');
      return null;
    }
  }

  // Tính tổng calories đốt cháy hôm nay
  static Future<double> calculateTodayCalories() async {
    try {
      final today = DateTime.now();
      final todayString =
          today.toIso8601String().split('T')[0]; // Format: YYYY-MM-DD

      final sessions = await RunHistoryService.getRunHistory();

      // Lọc các session có activity_date trùng với ngày hôm nay
      final todaySessions = sessions.where((session) {
        final sessionDate = session.date.toIso8601String().split('T')[0];
        return sessionDate == todayString;
      });

      // Tính tổng calories của các session hôm nay
      final todayCalories = todaySessions.fold<double>(
        0,
        (sum, session) => sum + session.calories,
      );
      debugPrint("Today calories: $todayCalories");
      return todayCalories;
    } catch (e) {
      print('Error calculating today calories: $e');
      return 0;
    }
  }

  // Lấy index của ngày hiện tại trong tuần (0 = Thứ 2, 6 = Chủ nhật)
  static int getCurrentDayIndex() {
    final now = DateTime.now();
    final weekday = now.weekday;
    return weekday - 1; // Chuyển đổi từ 1-7 (Thứ 2-Chủ nhật) sang 0-6
  }
}
