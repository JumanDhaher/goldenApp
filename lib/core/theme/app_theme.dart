import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    primaryColor: AppColors.gold,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.gold,
      secondary: AppColors.goldLight,
      surface: AppColors.darkSurface,
      error: AppColors.error,
      onPrimary: AppColors.darkBackground,
      onSecondary: AppColors.darkBackground,
      onSurface: AppColors.textOnDark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.gold,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.gold,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      selectedItemColor: AppColors.gold,
      unselectedItemColor: AppColors.textSecondaryDark,
      type: BottomNavigationBarType.fixed,
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.gold,
      foregroundColor: AppColors.darkBackground,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.darkBackground,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.darkDivider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
      hintStyle: const TextStyle(color: AppColors.textSecondaryDark),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.darkDivider,
      thickness: 1,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: AppColors.textOnDark,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: AppColors.textOnDark,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: AppColors.textOnDark,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: AppColors.textOnDark,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: AppColors.textOnDark,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: AppColors.textSecondaryDark,
        fontSize: 14,
      ),
      labelSmall: TextStyle(
        color: AppColors.textSecondaryDark,
        fontSize: 12,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.darkCard,
      contentTextStyle: const TextStyle(color: AppColors.textOnDark),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    primaryColor: AppColors.gold,
    colorScheme: const ColorScheme.light(
      primary: AppColors.gold,
      secondary: AppColors.goldDark,
      surface: AppColors.lightSurface,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textOnLight,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      foregroundColor: AppColors.goldDark,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.goldDark,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightSurface,
      selectedItemColor: AppColors.goldDark,
      unselectedItemColor: AppColors.textSecondaryLight,
      type: BottomNavigationBarType.fixed,
    ),
    cardTheme: CardThemeData(
      color: AppColors.lightCard,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.gold,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.gold,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
      ),
      labelStyle: const TextStyle(color: AppColors.textSecondaryLight),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.textOnLight,
      contentTextStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
