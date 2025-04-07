import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/features/services/run_history_service.dart';

class RunChartController {
  static Future<List<double>> getWeeklyCalories() async {
    try {
      final sessions = await RunHistoryService.getRunHistory();
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));

      // Khởi tạo mảng calories cho 7 ngày
      List<double> weeklyCalories = List.filled(7, 0.0);

      // Lọc và tính calories cho từng ngày trong tuần
      for (var session in sessions) {
        final sessionDate = session.date;
        final dayIndex = sessionDate.weekday - 1; // 0 = Thứ 2, 6 = Chủ nhật

        if (sessionDate.isAfter(weekStart) &&
            sessionDate.isBefore(weekStart.add(const Duration(days: 7)))) {
          weeklyCalories[dayIndex] += session.calories;
        }
      }

      return weeklyCalories;
    } catch (e) {
      print('Error getting weekly calories: $e');
      return List.filled(7, 0.0); // Trả về mảng 0 nếu có lỗi
    }
  }

  static LineChartData createWeeklyChart({
    required List<double> weeklyCalories,
    required int currentDayIndex,
    required BuildContext context,
  }) {
    return LineChartData(
      gridData: const FlGridData(
        drawHorizontalLine: false,
        drawVerticalLine: false,
      ),
      titlesData: FlTitlesData(
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, meta) {
              const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
              int index = value.toInt();
              if (index < 0 || index >= days.length)
                return const SizedBox.shrink();
              return Text(
                days[index],
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color:
                      index == currentDayIndex ? TColors.primary : Colors.grey,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.bold,
                ),
              );
            },
            reservedSize: 30,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(7, (index) {
            // Nếu không có dữ liệu cho ngày này, trả về điểm 0
            if (weeklyCalories[index] == 0) {
              return FlSpot(index.toDouble(), 0);
            }
            return FlSpot(index.toDouble(), weeklyCalories[index]);
          }),
          isCurved: true,
          curveSmoothness: 0.35, // Giảm độ cong
          preventCurveOverShooting: true, // Ngăn đường cong bị out
          color: TColors.primary,
          barWidth: 2,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, bar, index) {
              // Chỉ hiển thị dot cho các ngày có dữ liệu
              if (weeklyCalories[index] == 0) {
                return FlDotCirclePainter(radius: 0);
              }

              if (index == currentDayIndex) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: TColors.primary,
                );
              }
              return FlDotCirclePainter(radius: 3, color: TColors.primary);
            },
          ),
        ),
      ],
      minY: 0,
      maxY:
          weeklyCalories.isNotEmpty
              ? (weeklyCalories.reduce((a, b) => a > b ? a : b) * 1.2)
              : 100,
    );
  }
}
