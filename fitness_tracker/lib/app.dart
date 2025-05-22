import 'package:fitness_tracker/screens/onboardingFeature/BMIScreen/bmi_screen.dart';
import 'package:fitness_tracker/screens/onboardingFeature/GenderScreen/genderScreen.dart';
import 'package:fitness_tracker/screens/authentication/Login/login.dart';
import 'package:fitness_tracker/screens/onboardingFeature/OnBoardingScreen/onboardingScreen.dart';
import 'package:fitness_tracker/screens/onboardingFeature/activityLevelScreen/activityLevelScreen.dart';
import 'package:fitness_tracker/screens/onboardingFeature/goalScreen/goalScreen.dart';
import 'package:fitness_tracker/navigation_menu.dart';
import 'package:fitness_tracker/screens/password_configuration/forget_password.dart';
import 'package:fitness_tracker/screens/authentication/signup/signup.dart';
import 'package:fitness_tracker/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitness_tracker/features/models/user_onboarding_data.dart';
import 'screens/onboardingFeature/ageScreen/ageScreen.dart';
import 'screens/onboardingFeature/heightScreen/heightScreen.dart';
import 'screens/onboardingFeature/weightPage/weightPage.dart';

class MyApp extends StatelessWidget {
  final Widget initialScreen;

  const MyApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness Tracker',
      home: initialScreen,
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routes: {
        '/login': (context) => const Login(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/gender': (context) => const GenderPage(),
        '/age': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments as UserOnboardingData?;
          return AgePage(
            userData:
                args ??
                UserOnboardingData(
                  age: 20,
                  gender: '',
                  height: 0,
                  weight: 0,
                  goal: '',
                  activityLevel: '',
                ),
          );
        },
        '/height': (context) => const HeightPage(),
        '/weight': (context) => const WeightPage(),
        '/goal': (context) => const GoalPage(),
        '/activity': (context) => const ActivityPage(),
        '/home': (context) => const NavigationMenu(),
        '/signup': (context) => const Signup(),
        '/forget-password': (context) => const ForgetPassword(),
        '/bmi': (context) => const BMIScreen(),
        '/navigation': (context) => const NavigationMenu(),
      },
    );
  }
}
