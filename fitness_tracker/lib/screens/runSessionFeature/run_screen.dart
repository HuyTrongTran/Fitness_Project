import 'package:fitness_tracker/screens/runSessionFeature/runSession.dart';
import 'package:fitness_tracker/screens/runSessionFeature/runTrackingScreen.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:fitness_tracker/screens/runSessionFeature/runResult/controllers/run_stats_controller.dart';
import 'package:fitness_tracker/screens/runSessionFeature/runResult/controllers/run_chart_controller.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RunPage extends StatefulWidget {
  const RunPage({super.key});

  @override
  _RunPageState createState() => _RunPageState();
}

class _RunPageState extends State<RunPage> {
  RunSession? _bestSession;
  double _todayCalories = 0.0;
  List<double> _weeklyCalories = List.filled(7, 0.0);
  int _currentDayIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
    _loadWeeklyCalories();
  }

  Future<void> _loadWeeklyCalories() async {
    final weeklyCalories = await RunChartController.getWeeklyCalories();
    if (mounted) {
      setState(() {
        _weeklyCalories = weeklyCalories;
        _currentDayIndex = RunStatsController.getCurrentDayIndex();
      });
    }
  }

  Future<void> _loadStats() async {
    final bestSession = await RunStatsController.getBestSession();
    final todayCalories = await RunStatsController.calculateTodayCalories();

    if (mounted) {
      setState(() {
        _bestSession = bestSession;
        _todayCalories = todayCalories;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
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
                    "Your highest record",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                            "${_bestSession != null ? _bestSession!.calories.toStringAsFixed(2) : 0}",
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
            // Today's calories
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

            // Weekly chart
            SizedBox(
              height: 150,
              child: LineChart(
                RunChartController.createWeeklyChart(
                  weeklyCalories: _weeklyCalories,
                  currentDayIndex: _currentDayIndex,
                  context: context,
                ),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),
            // Start button
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
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall?.copyWith(color: Colors.black),
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
