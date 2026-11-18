import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// Typography tokens based on design/DESIGN.md.
/// Exclusively uses Plus Jakarta Sans with exact weights, line heights, and letter spacings.
class AppTypography {
  AppTypography._();

  static TextStyle get splashTitle => GoogleFonts.plusJakartaSans(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        height: 36 / 28,
        letterSpacing: -0.56, // -0.02em at 28px
        color: AppColors.primary,
      );

  static TextStyle get headlineH1 => GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        height: 32 / 24,
        letterSpacing: -0.48, // -0.02em at 24px
        color: AppColors.primary,
      );

  static TextStyle get statNumber => GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        height: 38 / 32,
        letterSpacing: -0.96, // -0.03em at 32px
        color: AppColors.primary,
      );

  static TextStyle get modalTitle => GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 24 / 18,
        color: AppColors.primary,
      );

  static TextStyle get cardTitle => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 22 / 16,
        color: AppColors.onSurface,
      );

  static TextStyle get bodyDefault => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 20 / 14,
        color: AppColors.onSurface,
      );

  static TextStyle get buttonText => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        height: 20 / 14,
        color: AppColors.onPrimary,
      );

  static TextStyle get captionMeta => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 16 / 12,
        color: AppColors.secondary,
      );

  static TextStyle get fieldLabel => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        height: 16 / 12,
        letterSpacing: 0.8, // tracking-wider
        color: AppColors.secondary,
      );

  static TextStyle get navLabel => GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 14 / 11,
        color: AppColors.outline,
      );

  /// Standard TextTheme mapped into Flutter's Material TextTheme
  static TextTheme get textTheme => TextTheme(
        displayLarge: statNumber,
        headlineLarge: splashTitle,
        headlineMedium: headlineH1,
        titleLarge: modalTitle,
        titleMedium: cardTitle,
        bodyLarge: bodyDefault,
        bodyMedium: bodyDefault.copyWith(color: AppColors.secondary),
        bodySmall: captionMeta,
        labelLarge: buttonText,
        labelMedium: fieldLabel,
        labelSmall: navLabel,
      );
}
