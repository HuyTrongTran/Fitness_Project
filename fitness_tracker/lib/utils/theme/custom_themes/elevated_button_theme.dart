import 'package:flutter/material.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: Colors.white,
      backgroundColor: TColors.primary,
      disabledForegroundColor: Colors.grey.withOpacity(0.38),
      disabledBackgroundColor: Colors.grey.withOpacity(0.12),
      side: const BorderSide(color: TColors.primary),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: Colors.white,
      backgroundColor: TColors.primary,
      disabledForegroundColor: Colors.grey.withOpacity(0.38),
      disabledBackgroundColor: Colors.grey.withOpacity(0.12),
      side: const BorderSide(color: TColors.primary),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
