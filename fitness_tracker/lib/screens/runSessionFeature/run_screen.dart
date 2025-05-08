import 'package:fitness_tracker/common/widgets/appbar/appbar.dart';
import 'package:fitness_tracker/screens/runSessionFeature/runResult/RunResultPage.dart';
import 'package:fitness_tracker/screens/runSessionFeature/runResult/runHistory.dart';
import 'package:fitness_tracker/screens/runSessionFeature/runSession.dart';
import 'package:fitness_tracker/screens/runSessionFeature/runTrackingScreen.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/image_strings.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:fitness_tracker/screens/runSessionFeature/runResult/controllers/run_stats_controller.dart';
import 'package:fitness_tracker/screens/runSessionFeature/runResult/controllers/run_chart_controller.dart';
import 'package:fitness_tracker/features/services/run_services/run_history_service.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:iconsax/iconsax.dart';

class RunPage extends StatefulWidget {
  const RunPage({super.key});

  @override
  _RunPageState createState() => _RunPageState();
}

class _RunPageState extends State<RunPage> {
  RunSession? _bestSession;
  double _todayDistance = 0.0;
  List<double> _weeklyDistance = List.filled(7, 0.0);
  int _currentDayIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
    _loadRunHistory();
  }

  Future<void> _loadRunHistory() async {
    try {
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      final weekEnd = weekStart.add(const Duration(days: 6));

      print('Loading run history from ${weekStart} to ${weekEnd}');

      final sessions = await RunHistoryService.getRunHistory(
        startDate: weekStart,
        endDate: weekEnd,
      );

      print('Loaded ${sessions.length} sessions');

      // Clear existing sessions
      RunSessionManager.clearSessions();

      // Add new sessions
      for (var session in sessions) {
        RunSessionManager.addSession(session);
        print(
          'Added session: date=${session.date}, distance=${session.distanceInKm}',
        );
      }

      // Load weekly distance after updating sessions
      _loadWeeklyDistance();
    } catch (e) {
      print('Error loading run history: $e');
    }
  }

  Future<void> _loadWeeklyDistance() async {
    final weeklyDistance = await RunChartController.getWeeklyDistance();
    if (mounted) {
      setState(() {
        _weeklyDistance = weeklyDistance;
        _currentDayIndex = RunStatsController.getCurrentDayIndex();
      });
    }
  }

  Future<void> _loadStats() async {
    final bestSession = await RunStatsController.getBestSession();
    final todayDistance = await RunStatsController.calculateTodayDistance();

    if (mounted) {
      setState(() {
        _bestSession = bestSession;
        _todayDistance = todayDistance;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        showBackButton: true,
        title: const Text("Start your run"),
        color: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RunHistoryScreen()),
              );
            },
            icon: const Icon(Iconsax.calendar_search, size: 24),
          ),
        ],
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
                    _todayDistance.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.black,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Km",
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
                  weeklyDistance: _weeklyDistance,
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
