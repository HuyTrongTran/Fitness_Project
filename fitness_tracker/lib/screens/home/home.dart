import 'package:fitness_tracker/common/widgets/custome_shape/containers/primary_header_container.dart';
import 'package:fitness_tracker/screens/home/widgets/homeAppBar.dart';
import 'package:fitness_tracker/screens/home/widgets/workout_plan.dart';
import 'package:fitness_tracker/screens/home/widgets/workout_stats.dart';
import 'package:fitness_tracker/screens/home/widgets/recent_plans.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Primary Header Container with Search and Categories
            PrimaryHeaderContainer(
              child: Column(
                children: [
                  HomeAppBar(
                    onDaySelected: (selectedDay) {
                      // Không cần cập nhật _selectedDate nữa vì Home không dùng nó
                    },
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  WorkoutPlan(
                    selectedDate: DateTime.now(), // Luôn hiển thị ngày hiện tại
                    isInPopup: false,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                ],
              ),
            ),

            // Workout Stats Section
            const WorkoutStats(),

            // Recent Plans Section
            const RecentPlans(),
          ],
        ),
      ),
    );
  }
}