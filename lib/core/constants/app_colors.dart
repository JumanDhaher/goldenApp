import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Gold Colors
  static const Color gold = Color(0xFFFFB800);
  static const Color goldLight = Color(0xFFFFD54F);
  static const Color goldDark = Color(0xFFFF8F00);

  // Dark Theme
  static const Color darkBackground = Color(0xFF0A0A0A);
  static const Color darkSurface = Color(0xFF1A1A1A);
  static const Color darkCard = Color(0xFF242424);
  static const Color darkDivider = Color(0xFF2E2E2E);

  // Light Theme
  static const Color lightBackground = Color(0xFFFAF8F0);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFF8E1);

  // Text
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFAAAAAA);
  static const Color textOnLight = Color(0xFF1A1A1A);
  static const Color textSecondaryLight = Color(0xFF666666);

  // Status
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFB300);

  // Karat colors
  static const Map<int, Color> karatColors = {
    18: Color(0xFFE6BE8A),
    21: Color(0xFFFFCC44),
    22: Color(0xFFFFB800),
    24: Color(0xFFFF9500),
  };
}
