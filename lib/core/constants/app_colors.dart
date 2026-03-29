import 'package:flutter/material.dart';

/// ألوان مطابقة للموقع — Golden Web App
/// --gold: #C9A84C  --gold-light: #E8C97A  --gold-dark: #A07820
class AppColors {
  AppColors._();

  // ── Gold Palette (نفس الموقع) ──
  static const Color gold      = Color(0xFFC9A84C); // --gold
  static const Color goldLight = Color(0xFFE8C97A); // --gold-light
  static const Color goldPale  = Color(0xFFF5E6B8); // --gold-pale
  static const Color goldDark  = Color(0xFFA07820); // --gold-dark

  // ── Dark Theme (نفس الموقع) ──
  static const Color darkBackground = Color(0xFF0A0A0A); // --black
  static const Color darkSurface    = Color(0xFF111108); // --surface
  static const Color darkSurface2   = Color(0xFF1C1B10); // --surface2
  static const Color darkCard       = Color(0xFF252414); // --surface3
  static const Color darkText       = Color(0xFFF5EDD8); // --text
  static const Color darkTextMuted  = Color(0xFFA89870); // --text-muted
  static const Color darkBorder     = Color(0x40C9A84C); // rgba(201,168,76,0.25)
  static const Color darkDivider    = Color(0xFF252414);

  // ── Light Theme (نفس الموقع) ──
  static const Color lightBackground = Color(0xFFFAF7F0); // --black light
  static const Color lightSurface    = Color(0xFFFFFFFF); // --surface light
  static const Color lightSurface2   = Color(0xFFFBF6E9); // --surface2 light
  static const Color lightCard       = Color(0xFFF5EDD5); // --surface3 light
  static const Color lightText       = Color(0xFF1A1500); // --text light
  static const Color lightTextMuted  = Color(0xFF6B5C30); // --text-muted light
  static const Color lightGold       = Color(0xFFA0720A); // --gold light
  static const Color lightGoldDark   = Color(0xFF3D2A00); // --gold-dark light

  // ── Status ──
  static const Color success = Color(0xFF4CAF50);
  static const Color error   = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFB300);

  // ── Karat Colors (مطابق للموقع) ──
  static const Map<int, Color> karatColors = {
    18: Color(0xFFE8C97A),
    21: Color(0xFFC9A84C),
    22: Color(0xFFA07820),
    24: Color(0xFFF5E6B8),
  };

  // ── PDF Colors ──
  static const Color pdfGold    = Color(0xFF8B6914);
  static const Color pdfGoldBg  = Color(0xFFFFFDF5);
}
