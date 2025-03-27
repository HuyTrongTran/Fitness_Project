import 'package:flutter/material.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';

class TTextFormFieldTheme {
  TTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
    // Focus color
    focusColor: TColors.primary,
    floatingLabelStyle: const TextStyle().copyWith(
      color: Colors.black,
      fontFamily: 'Nunito',
      fontSize: 14,
    ),
    labelStyle: const TextStyle().copyWith(
      fontSize: 14,
      color: Colors.black,
      fontFamily: 'Nunito',
    ),
    hintStyle: const TextStyle().copyWith(
      fontSize: 14,
      color: Colors.black,
      fontFamily: 'Nunito',
    ),
    errorStyle: const TextStyle().copyWith(
      fontStyle: FontStyle.normal,
      fontFamily: 'Nunito',
    ),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Colors.grey, width: 1),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Colors.grey, width: 1),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: TColors.primary, width: 1.5),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Colors.red, width: 1),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Colors.orange, width: 1),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
    // Focus color
    focusColor: TColors.primary,
    floatingLabelStyle: const TextStyle().copyWith(
      color: Colors.white,
      fontFamily: 'Nunito',
      fontSize: 14,
    ),
    labelStyle: const TextStyle().copyWith(
      fontSize: 14,
      color: Colors.white,
      fontFamily: 'Nunito',
    ),
    hintStyle: const TextStyle().copyWith(
      fontSize: 14,
      color: Colors.white,
      fontFamily: 'Nunito',
    ),
    errorStyle: const TextStyle().copyWith(
      fontStyle: FontStyle.normal,
      fontFamily: 'Nunito',
    ),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Colors.grey, width: 1),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Colors.grey, width: 1),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: TColors.primary, width: 1.5),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Colors.red, width: 1),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Colors.orange, width: 1),
    ),
  );
}
