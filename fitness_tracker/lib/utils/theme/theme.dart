import 'package:fitness_tracker/utils/theme/custom_themes/appbar_theme.dart';
import 'package:fitness_tracker/utils/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:fitness_tracker/utils/theme/custom_themes/checkbox_theme.dart';
import 'package:fitness_tracker/utils/theme/custom_themes/chip_theme.dart';
import 'package:fitness_tracker/utils/theme/custom_themes/elevated_button_theme.dart';
import 'package:fitness_tracker/utils/theme/custom_themes/outlined_button_theme.dart';
import 'package:fitness_tracker/utils/theme/custom_themes/text_button_theme.dart';
import 'package:fitness_tracker/utils/theme/custom_themes/text_field_theme.dart';
import 'package:fitness_tracker/utils/theme/custom_themes/text_theme.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Nunito',
    brightness: Brightness.light,
    primaryColor: const Color(0xFFFF6079),
    textTheme: TTextTheme.lightTextTheme,
    chipTheme: TChipTheme.lightChipTheme,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    textButtonTheme: TTextButtonTheme.lightTextButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: TColors.primary,
      selectionColor: TColors.primary.withOpacity(0.1),
      selectionHandleColor: TColors.primary.withOpacity(0.1),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Nunito',
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    textTheme: TTextTheme.darkTextTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    textButtonTheme: TTextButtonTheme.darkTextButtonTheme,
    chipTheme: TChipTheme.darkChipTheme,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    checkboxTheme: TCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: TColors.primary,
      selectionColor: TColors.primary.withOpacity(0.1),
      selectionHandleColor: TColors.primary.withOpacity(0.1),
    ),
  );
}
