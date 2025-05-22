import 'package:fitness_tracker/common/widgets/custome_shape/containers/primary_header_container.dart';
import 'package:fitness_tracker/screens/home/widgets/dailyProgress/daily_progress.dart';
import 'package:fitness_tracker/screens/home/widgets/homeAppBar.dart';
import 'package:fitness_tracker/screens/home/widgets/workout_plan.dart';
import 'package:fitness_tracker/screens/home/widgets/suggest_food.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/features/services/home_services/getTodayActivity.dart';
import 'package:fitness_tracker/features/services/home_services/prefer_target.dart';
import 'package:fitness_tracker/screens/userProfile/profile_data.dart';
import 'package:fitness_tracker/features/services/user_profile_services/getProfile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TodayActivityData? _todayActivityData;
  ActivityTarget? _activityTarget;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadActivityData();
  }

  Future<void> _loadActivityData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final activityData = await GetTodayActivityService.getTodayActivity();
      final profileData = await GetProfileService.fetchProfileData();
      final userProfile =
          profileData ??
          ProfileData(
            weight: 60.0,
            height: 170.0,
            age: 30,
            gender: 'male',
            activityLevel: 'moderate',
            goal: 'maintain',
          );
      final targetData = await ActivityTarget.getRecommendedTarget(userProfile);

      setState(() {
        _todayActivityData = activityData;
        _activityTarget = targetData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Unable to load data: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            PrimaryHeaderContainer(
              child: Column(
                children: [
                  HomeAppBar(onDaySelected: (selectedDay) {}),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  WorkoutPlan(selectedDate: DateTime.now(), isInPopup: false),
                  const SizedBox(height: TSizes.spaceBtwItems),
                ],
              ),
            ),

            if (_isLoading)
              Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F9FF),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                height: 180,
                width: double.infinity,
              )
            else if (_errorMessage.isNotEmpty)
              Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadActivityData,
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              )
            else
              DailyProgress(
                distance: _todayActivityData?.distanceInKm ?? 0,
                distanceGoal: _activityTarget?.targetDistance ?? 5,
                steps: _todayActivityData?.steps ?? 0,
                stepsGoal: _activityTarget?.targetSteps ?? 10000,
                calories: _todayActivityData?.calories ?? 0,
                caloriesGoal: _activityTarget?.targetCalories ?? 2000,
              ),

            const RecentPlans(),
          ],
        ),
      ),
    );
  }
}
