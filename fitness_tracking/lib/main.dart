import 'package:fitness_tracking/screens/GenderScreen/genderScreen.dart';
import 'package:fitness_tracking/screens/OnBoardingScreen/onboardingScreen.dart';
import 'package:fitness_tracking/screens/goalScreen/goalScreen.dart';
import 'package:flutter/material.dart';

import 'screens/ageScreen/ageScreen.dart';
import 'screens/heightScreen/heightScreen.dart';
import 'screens/weightPage/weightPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.black,
      routes: {
        '/onboarding': (context) => OnboardingScreen(),
        '/height': (context) => HeightPage(),
        '/age': (context) => AgePage(),
        '/gender': (context) => GenderPage(),
        '/goal': (context) => GoalPage(),
        '/weight': (context) => WeightPage(),
      },
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
    );
  }
}
