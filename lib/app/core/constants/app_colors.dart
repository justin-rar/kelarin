import 'package:flutter/material.dart';
import 'app_shadows.dart';

/// Design tokens for colors based on Google Stitch TaskFlow Design System.
/// Acuan: design/DESIGN.md
class AppColors {
  AppColors._();

  // Core roles
  static const Color primary = Color(0xFF000000); // Ink / text-1
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1A1C1D); // Body text
  static const Color secondary = Color(0xFF5E5E65); // Text-2
  static const Color outline = Color(0xFF747878); // Text-3, placeholders, inactive tabs
  static const Color background = Color(0xFFF9F9FA); // Canvas
  static const Color surface = Color(0xFFFFFFFF); // Surface
  static const Color fill1 = Color(0xFFEFEFF1); // Fill-1
  static const Color statLight = Color(0xFFEDEDEF); // Stat light
  static const Color statDark = Color(0xFFE2E2E5); // Stat dark
  static const Color divider = Color(0xFFECECEE); // 1px separators
  static const Color surfaceContainerHigh = Color(0xFFE8E8E9); // Checkbox idle
  static const Color outlineVariant = Color(0xFFC4C7C7); // Separator dot "•"

  // Scrim: #0A0A0A at 40%
  static const Color scrim = Color(0x660A0A0A);

  // Material-style semantic tokens (not used visually for UI states per DESIGN.md)
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);

  // Backward compatibility aliases
  static const Color tertiary = outline;
  static const BoxShadow cardShadow = AppShadows.standard;
  static const BoxShadow popoverShadow = AppShadows.popover;
  static const BoxShadow floatingShadow = AppShadows.standard;
}
