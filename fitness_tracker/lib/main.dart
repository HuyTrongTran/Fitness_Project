import 'package:fitness_tracker/screens/GenderScreen/genderScreen.dart';
import 'package:fitness_tracker/screens/Login/login.dart';
import 'package:fitness_tracker/screens/OnBoardingScreen/onboardingScreen.dart';
import 'package:fitness_tracker/screens/activityLevelScreen/activityLevelScreen.dart';
import 'package:fitness_tracker/screens/goalScreen/goalScreen.dart';
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
      home: SplashScreen(), // Change this
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          "assets/icons/splash_logo/splash_logo_white.png",
          fit: BoxFit.cover, // Crop the image to cover the available space
          width:
              MediaQuery.of(context).size.width *
              0.5, // Set width to screen width
        ),
      ),
    );
  }
}
