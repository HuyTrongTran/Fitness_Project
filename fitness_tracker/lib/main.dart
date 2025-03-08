import 'package:fitness_tracker/screens/GenderScreen/genderScreen.dart';
import 'package:fitness_tracker/screens/OnBoardingScreen/onboardingScreen.dart';
import 'package:fitness_tracker/screens/activityLevelScreen/activityLevelScreen.dart';
import 'package:fitness_tracker/screens/goalScreen/goalScreen.dart';
import 'package:fitness_tracker/screens/splash_screen/splash_screen.dart';
import 'package:fitness_tracker/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'screens/ageScreen/ageScreen.dart';
import 'screens/heightScreen/heightScreen.dart';
import 'screens/weightPage/weightPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routes: {
        '/onboarding': (context) => OnboardingScreen(),
        '/height': (context) => HeightPage(),
        '/age': (context) => AgePage(),
        '/gender': (context) => GenderPage(),
        '/goal': (context) => GoalPage(),
        '/weight': (context) => WeightPage(),
        '/activity': (context) => ActivityPage(),
      },
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
