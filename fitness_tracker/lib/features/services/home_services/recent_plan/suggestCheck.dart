import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitness_tracker/screens/suggestScreen/suggestScreen.dart';
import 'package:fitness_tracker/navigation_menu.dart';

Future<void> checkAndNavigate(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final lastDate = prefs.getString('lastSuggestScreenDate');

  if (lastDate == today) {
    // Đã xem hôm nay, chuyển thẳng tới NavigationHome
    Get.offAll(() => const NavigationMenu());
  } else {
    // Chưa xem hôm nay, hiển thị SuggestScreen
    Get.offAll(() => const SuggestScreen());
    // Lưu lại ngày đã xem
    await prefs.setString('lastSuggestScreenDate', today);
  }
}
