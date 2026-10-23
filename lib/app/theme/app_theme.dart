import 'package:flutter/material.dart';

class AppColors {
  static const navy = Color(0xFF102A43);
  static const navy2 = Color(0xFF243F59);
  static const gold = Color(0xFFC8A66A);
  static const canvas = Color(0xFFF7F5F0);
  static const ink = Color(0xFF172B3A);
  static const muted = Color(0xFF657786);
  static const green = Color(0xFF21865B);
  static const red = Color(0xFFB42318);
}

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true, scaffoldBackgroundColor: AppColors.canvas,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.navy, primary: AppColors.navy, secondary: AppColors.gold),
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.navy, foregroundColor: Colors.white, centerTitle: false),
    cardTheme: CardThemeData(color: Colors.white, elevation: 1, margin: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
    inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE1E6EA))), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.gold, width: 1.5))),
    filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, minimumSize: const Size(48, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)))),
  );
}
