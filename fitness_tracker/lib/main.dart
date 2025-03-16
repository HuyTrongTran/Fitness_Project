import 'package:fitness_tracker/screens/GenderScreen/genderScreen.dart';
import 'package:fitness_tracker/screens/Login/login.dart';
import 'package:fitness_tracker/screens/OnBoardingScreen/onboardingScreen.dart';
import 'package:fitness_tracker/screens/activityLevelScreen/activityLevelScreen.dart';
import 'package:fitness_tracker/screens/goalScreen/goalScreen.dart';
import 'package:fitness_tracker/navigation_menu.dart';
import 'package:fitness_tracker/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'screens/ageScreen/ageScreen.dart';
import 'screens/heightScreen/heightScreen.dart';
import 'screens/weightPage/weightPage.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Do initialization tasks here
  await Future.delayed(
    const Duration(seconds: 2),
  ); // Add some delay to show splash

  FlutterNativeSplash.remove();
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
        '/onboarding': (context) => const OnboardingScreen(),
        '/height': (context) => const HeightPage(),
        '/age': (context) => const AgePage(),
        '/gender': (context) => const GenderPage(),
        '/goal': (context) => const GoalPage(),
        '/weight': (context) => const WeightPage(),
        '/activity': (context) => const ActivityPage(),
        '/navigation': (context) => const NavigationMenu(),
        '/login': (context) => const Login(),
      },
      debugShowCheckedModeBanner: false,
      home:
          const OnboardingScreen(), // Change to OnboardingScreen instead of SplashScreen
    );
  }
}
