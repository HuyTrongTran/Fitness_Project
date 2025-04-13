import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/features/services/run_history_service.dart';
import 'package:fitness_tracker/screens/runSessionFeature/runSession.dart';

class RunChartController {
  static Future<double> getTodayDistance() async {
    try {
      final now = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );

      final sessions = await RunHistoryService.getRunHistory(
        startDate: now,
        endDate: now.add(const Duration(days: 1)),
      );

      double todayDistance = 0.0;
      for (var session in sessions) {
        final sessionDate = DateTime(
          session.date.year,
          session.date.month,
          session.date.day,
        );
        if (sessionDate.isAtSameMomentAs(now)) {
          todayDistance += session.distanceInKm;
        }
      }

      return todayDistance;
    } catch (e) {
      print('Error getting today distance: $e');
      return 0.0;
    }
  }

  static Future<List<double>> getWeeklyDistance() async {
    try {
      final now = DateTime.now();
      print('Current time: $now');

      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      final weekEnd = weekStart.add(const Duration(days: 6));

      print('Week start: ${weekStart.toString()}');
      print('Week end: ${weekEnd.toString()}');

      final sessions = RunSessionManager.runSessions;
      print('Local sessions count: ${sessions.length}');

      if (sessions.isEmpty) {
        print('No sessions found in local storage');
        return List.filled(7, 0.0);
      }

      print('All local sessions:');
      for (var session in sessions) {
        print(
          'Session: date=${session.date}, distance=${session.distanceInKm}',
        );
      }

      List<double> weeklyDistance = List.filled(7, 0.0);

      for (var session in sessions) {
        final sessionDate = session.date;
        final dayIndex = sessionDate.weekday - 1;

        final sessionDateOnly = DateTime(
          sessionDate.year,
          sessionDate.month,
          sessionDate.day,
        );

        if (sessionDateOnly.isAfter(
              weekStart.subtract(const Duration(days: 1)),
            ) &&
            sessionDateOnly.isBefore(weekEnd.add(const Duration(days: 1)))) {
          weeklyDistance[dayIndex] += session.distanceInKm;
         
        } else {
         
        }
      }

      
      return weeklyDistance;
    } catch (e) {
      
      return List.filled(7, 0.0);
    }
  }

  static LineChartData createWeeklyChart({
    required List<double> weeklyDistance,
    required int currentDayIndex,
    required BuildContext context,
  }) {
    print('Creating chart with data: $weeklyDistance');

    final maxY =
        weeklyDistance.isNotEmpty
            ? (weeklyDistance.reduce((a, b) => a > b ? a : b) * 1.2)
            : 10.0;


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
            if (weeklyDistance[index] == 0) {
              return FlSpot(index.toDouble(), 0);
            }
            return FlSpot(index.toDouble(), weeklyDistance[index]);
          }),
          isCurved: true,
          curveSmoothness: 0.35,
          preventCurveOverShooting: true,
          color: TColors.primary,
          barWidth: 2,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, bar, index) {
              if (weeklyDistance[index] == 0) {
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
      maxY: maxY,
    );
  }
}
