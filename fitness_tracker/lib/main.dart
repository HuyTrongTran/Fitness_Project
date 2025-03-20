import 'package:fitness_tracker/app.dart';
import 'package:fitness_tracker/firebase_options.dart';
import 'package:fitness_tracker/navigation_menu.dart';
import 'package:fitness_tracker/screens/Login/login.dart';
import 'package:fitness_tracker/screens/OnBoardingScreen/onboardingScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo GetStorage
  await GetStorage.init();

  // Giữ splash screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Khởi tạo Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Kiểm tra trạng thái đăng nhập và onboarding
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwt_token');
  final userEmail = prefs.getString('user_email'); // Lưu email của user hiện tại

  // Quyết định màn hình khởi đầu
  Widget initialScreen;
  if (token != null && token.isNotEmpty && userEmail != null) {
    final onboardingKey = 'has_completed_onboarding_$userEmail'; // Key riêng cho từng email
    final hasCompletedOnboarding = prefs.getBool(onboardingKey) ?? false;
    if (hasCompletedOnboarding) {
      initialScreen = const NavigationMenu();
    } else {
      initialScreen = const OnboardingScreen();
    }
  } else {
    initialScreen = const Login();
  }

  // Đợi 2 giây để hiển thị splash screen
  await Future.delayed(const Duration(seconds: 2));

  // Xóa splash screen
  FlutterNativeSplash.remove();

  runApp(MyApp(initialScreen: initialScreen));
}