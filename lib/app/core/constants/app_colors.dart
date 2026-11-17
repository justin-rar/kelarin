import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Monochromatic Inks
  static const Color primary = Color(0xFF0A0A0A);
  static const Color onPrimary = Color(0xFFFFFFFF);
  
  // Canvas & Surfaces
  static const Color background = Color(0xFFF6F6F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1A1C1D);

  // Grey Tonalities
  static const Color secondary = Color(0xFF6F6F76);
  static const Color tertiary = Color(0xFFA8A8AE);
  static const Color outline = Color(0xFF747878);
  static const Color outlineVariant = Color(0xFFC4C7C7);
  static const Color divider = Color(0xFFECECEE);

  // Surface Fills
  static const Color fill1 = Color(0xFFEFEFF1);
  static const Color statLight = Color(0xFFEDEDEF);
  static const Color statDark = Color(0xFFE2E2E5);

  // Functional / Alert
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);

  // Shadows
  static const BoxShadow cardShadow = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.06),
    blurRadius: 24,
    offset: Offset(0, 8),
    spreadRadius: 0,
  );

  static const BoxShadow popoverShadow = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.12),
    blurRadius: 32,
    offset: Offset(0, 12),
    spreadRadius: 0,
  );

  static const BoxShadow floatingShadow = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.08),
    blurRadius: 24,
    offset: Offset(0, 8),
    spreadRadius: 0,
  );
}

