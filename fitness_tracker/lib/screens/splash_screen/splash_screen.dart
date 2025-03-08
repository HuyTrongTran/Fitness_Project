import 'package:fitness_tracker/screens/Login/login.dart';
import 'package:fitness_tracker/screens/signup.widgets/signup.dart';
import 'package:fitness_tracker/utils/helpers/helpers_function.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Signup()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = HelpersFunction.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark ? Colors.black : Colors.white,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 200),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.asset(
              dark
                  ? "assets/icons/logos/Logo-white.png"
                  : "assets/icons/logos/Logo-black.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
