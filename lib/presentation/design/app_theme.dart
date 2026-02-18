import 'package:flutter/material.dart';

import 'tokens.dart';

ThemeData buildBlueTalkTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: BlueTalkColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: BlueTalkColors.navPill,
      brightness: Brightness.light,
      surface: BlueTalkColors.background,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: BlueTalkColors.background,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'IMFellEnglish',
        fontSize: 35,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w600,
        color: BlueTalkColors.primaryText,
      ),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 22,
        color: BlueTalkColors.primaryText,
        fontWeight: FontWeight.w400,
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        color: BlueTalkColors.primaryText,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: BlueTalkColors.primaryText,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        fontSize: 13,
        color: BlueTalkColors.secondaryText,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        color: BlueTalkColors.primaryText,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}
