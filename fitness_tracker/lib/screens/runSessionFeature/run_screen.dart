import 'package:fitness_tracker/RunFeature/class/runSession.dart';
import 'package:fitness_tracker/RunFeature/runTrackingScreen/runTrackingScreen.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RunPage extends StatefulWidget {
  const RunPage({super.key});

  @override
  _RunPageState createState() => _RunPageState();
}

class _RunPageState extends State<RunPage> {
  RunSession? _bestSession; // Phiên chạy có khoảng cách lớn nhất
  double _todayCalories = 0.0; // Tổng kcal của ngày hôm nay
  List<double> _weeklyCalories = [
    50, // Mon
    30, // Tue
    80, // Wed
    20, // Thu
    60, // Fri
    40, // Sat
    70, // Sun
  ]; // Dữ liệu demo cho 7 ngày trong tuần
  int _currentDayIndex = 0; // Vị trí của ngày hiện tại trong tuần

  @override
  void initState() {
    super.initState();
    _calculateStats();
  }

  // Tính toán các số liệu: khoảng cách lớn nhất, kcal hôm nay
  void _calculateStats() {
    // 1. Tìm phiên chạy có khoảng cách lớn nhất
    if (RunSessionManager.runSessions.isNotEmpty) {
      _bestSession = RunSessionManager.runSessions.reduce(
        (a, b) => a.distanceInKm > b.distanceInKm ? a : b,
      );
    }

    // 2. Tính tổng kcal của ngày hôm nay và xác định thứ hiện tại
    DateTime today = DateTime.now();
    // weekday: 1 (Mon) đến 7 (Sun), ánh xạ sang index: 0 (Mon) đến 6 (Sun)
    _currentDayIndex =
        (today.weekday - 1) % 7; // 0 (Mon), 1 (Tue), ..., 6 (Sun)
    print(
      "Current day: ${today.weekday}, Index: $_currentDayIndex",
    ); // Debug: 2 (Tue) -> index 1

    _todayCalories = RunSessionManager.runSessions
        .where(
          (session) =>
              session.date.day == today.day &&
              session.date.month == today.month &&
              session.date.year == today.year,
        )
        .fold(0.0, (sum, session) => sum + session.calories);

    // Nếu không có dữ liệu thực tế, dùng dữ liệu demo cho ngày hiện tại
    if (_todayCalories == 0.0) {
      _todayCalories = _weeklyCalories[_currentDayIndex];
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Move your body",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Your record
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: AssetImage(
                    'assets/backgrounds/run_background/Duel.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Your record",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: TColors.black,
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(
                        image: AssetImage(
                          "assets/icons/app_icons/calories.png",
                        ),
                      ),
                      const SizedBox(width: TSizes.spaceBtwInputfields),
                      Text(
                        _bestSession != null
                            ? "${_bestSession!.distanceInKm.toStringAsFixed(1)} km"
                            : "0.0 km",
                        style: Theme.of(
                          context,
                        ).textTheme.headlineLarge?.copyWith(
                          color: TColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Step: ",
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: TColors.black,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${_bestSession != null ? _bestSession!.steps : 0}",
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(color: TColors.primary),
                          ),
                        ],
                      ),
                      const SizedBox(width: TSizes.spaceBtwSections),
                      Row(
                        children: [
                          Text(
                            "Calories: ",
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: TColors.black,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${_bestSession != null ? _bestSession!.calories.toStringAsFixed(0) : 0}",
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(color: TColors.primary),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 100,
                    child: Image.asset(
                      'assets/backgrounds/run_background/Progressbar.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            // Tổng kcal hôm nay
            Center(
              child: Column(
                children: [
                  Text(
                    _todayCalories.toStringAsFixed(0),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.black,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Kcal",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Biểu đồ (hiển thị 7 ngày trong tuần, bắt đầu từ Mon)
            SizedBox(
              height: 150,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(
                    drawHorizontalLine: false,
                    drawVerticalLine: false,
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1, // Đảm bảo mỗi ngày hiển thị 1 lần
                        getTitlesWidget: (value, meta) {
                          const days = [
                            'Mon',
                            'Tue',
                            'Wed',
                            'Thu',
                            'Fri',
                            'Sat',
                            'Sun',
                          ];
                          int index = value.toInt();
                          if (index < 0 || index >= days.length)
                            return const SizedBox.shrink();
                          return Text(
                            days[index],
                            style: Theme.of(
                              context,
                            ).textTheme.labelLarge?.copyWith(
                              color:
                                  index == _currentDayIndex
                                      ? TColors
                                          .primary // Ngày hiện tại có màu primary
                                      : Colors.grey,
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
                      spots: List.generate(
                        7,
                        (index) =>
                            FlSpot(index.toDouble(), _weeklyCalories[index]),
                      ),
                      isCurved: true, // Đường cong mượt mà
                      color: TColors.primary,
                      barWidth: 2,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, bar, index) {
                          // Chỉ hiển thị chấm cho ngày hiện tại
                          if (index == _currentDayIndex) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: Colors.white,
                              strokeWidth: 2,
                              strokeColor: TColors.primary,
                            );
                          }
                          return FlDotCirclePainter(
                            radius: 0,
                          ); // Ẩn chấm cho các ngày khác
                        },
                      ),
                    ),
                  ],
                  minY: 0,
                  maxY:
                      _weeklyCalories.isNotEmpty
                          ? (_weeklyCalories.reduce((a, b) => a > b ? a : b) *
                              1.2)
                          : 100,
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            // Nút "Start"
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: TColors.grey.withOpacity(0.8),
                  width: 0.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Let's start new run session",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      // fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Run is the simple movement to start your journey",
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RunTrackingPage(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: TColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Start",
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: TColors.primary,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
