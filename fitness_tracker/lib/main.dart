import 'package:fitness_tracker/app.dart';
import 'package:fitness_tracker/firebase_options.dart';
import 'package:fitness_tracker/screens/authentication/Login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_tracker/features/services/home_services/recent_plan/get_recent_plan.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fitness_tracker/navigation_menu.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file từ thư mục assets
  await dotenv.load(fileName: "assets/.env");

  await GetStorage.init();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwt_token');

  // Điều hướng dựa vào trạng thái token
  Widget initialScreen;
  if (token != null && token.isNotEmpty && !JwtDecoder.isExpired(token)) {
    print('Token is not expired');
    initialScreen = const NavigationMenu();
  } else {
    print('Token is expired or not found');
    initialScreen = const Login();
  }

  RecentPlanService.init();

  await Future.delayed(const Duration(seconds: 2));
  FlutterNativeSplash.remove();

  runApp(MyApp(initialScreen: initialScreen));
}


