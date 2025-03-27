import 'package:fitness_tracker/app.dart';
import 'package:fitness_tracker/firebase_options.dart';
import 'package:fitness_tracker/screens/authentication/Login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwt_token');

  Widget initialScreen;
  if (token != null && token.isNotEmpty) {
    // Kiểm tra trạng thái onboarding sẽ được xử lý trong LoginForm
    initialScreen = const Login();
  } else {
    initialScreen = const Login();
  }

  await Future.delayed(const Duration(seconds: 2));
  FlutterNativeSplash.remove();

  runApp(MyApp(initialScreen: initialScreen));
}