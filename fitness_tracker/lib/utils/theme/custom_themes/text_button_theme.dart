import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class TTextButtonTheme {
  TTextButtonTheme._();

  static final lightTextButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: TColors.dark,
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
    ),
  );

  static final darkTextButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: TColors.light,
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
    ),
  );
}
