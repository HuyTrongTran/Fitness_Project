import 'package:fitness_tracker/common/widgets/custome_shape/containers/primary_header_container.dart';
import 'package:fitness_tracker/screens/home/widgets/homeAppBar.dart';
import 'package:fitness_tracker/screens/home/widgets/workout_plan.dart';
import 'package:fitness_tracker/screens/home/widgets/workout_stats.dart';
import 'package:fitness_tracker/screens/home/widgets/recent_plans.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Primary Header Container with Search and Categories
            PrimaryHeaderContainer(
              child: Column(
                children: [
                  HomeAppBar(),
                  SizedBox(height: TSizes.spaceBtwItems),
                  // Workout Stats Section
                  WorkoutPlan(),
                  SizedBox(height: TSizes.spaceBtwItems),
                ],
              ),
            ),

            // Workout Stats Section
            WorkoutStats(),

            // Workout Plan Section
            RecentPlans(),

            // Promo Slider
            // Padding(
            //   padding: EdgeInsets.all(TSizes.defaultSpace),
            //   child: PromoSlider(banner: [Images.slider1, Images.slider2]),
            // ),
          ],
        ),
      ),
    );
  }
}
