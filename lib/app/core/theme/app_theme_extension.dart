import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// ThemeExtension to expose custom design tokens from DESIGN.md via Theme.of(context).
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color fill1;
  final Color statLight;
  final Color statDark;
  final Color divider;
  final Color textSecondary;
  final Color textTertiary;
  final Color checkboxIdle;
  final Color separatorDot;
  final Color scrim;

  const AppThemeExtension({
    required this.fill1,
    required this.statLight,
    required this.statDark,
    required this.divider,
    required this.textSecondary,
    required this.textTertiary,
    required this.checkboxIdle,
    required this.separatorDot,
    required this.scrim,
  });

  static const AppThemeExtension light = AppThemeExtension(
    fill1: AppColors.fill1,
    statLight: AppColors.statLight,
    statDark: AppColors.statDark,
    divider: AppColors.divider,
    textSecondary: AppColors.secondary,
    textTertiary: AppColors.outline,
    checkboxIdle: AppColors.surfaceContainerHigh,
    separatorDot: AppColors.outlineVariant,
    scrim: AppColors.scrim,
  );

  @override
  AppThemeExtension copyWith({
    Color? fill1,
    Color? statLight,
    Color? statDark,
    Color? divider,
    Color? textSecondary,
    Color? textTertiary,
    Color? checkboxIdle,
    Color? separatorDot,
    Color? scrim,
  }) {
    return AppThemeExtension(
      fill1: fill1 ?? this.fill1,
      statLight: statLight ?? this.statLight,
      statDark: statDark ?? this.statDark,
      divider: divider ?? this.divider,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      checkboxIdle: checkboxIdle ?? this.checkboxIdle,
      separatorDot: separatorDot ?? this.separatorDot,
      scrim: scrim ?? this.scrim,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      fill1: Color.lerp(fill1, other.fill1, t) ?? fill1,
      statLight: Color.lerp(statLight, other.statLight, t) ?? statLight,
      statDark: Color.lerp(statDark, other.statDark, t) ?? statDark,
      divider: Color.lerp(divider, other.divider, t) ?? divider,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t) ?? textSecondary,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t) ?? textTertiary,
      checkboxIdle: Color.lerp(checkboxIdle, other.checkboxIdle, t) ?? checkboxIdle,
      separatorDot: Color.lerp(separatorDot, other.separatorDot, t) ?? separatorDot,
      scrim: Color.lerp(scrim, other.scrim, t) ?? scrim,
    );
  }
}

/// Convenience extensions on BuildContext to access theme tokens.
extension AppThemeContextExtension on BuildContext {
  AppThemeExtension get appTheme =>
      Theme.of(this).extension<AppThemeExtension>() ?? AppThemeExtension.light;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
}
