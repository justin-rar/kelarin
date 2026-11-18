import 'package:flutter/material.dart';

/// Design tokens for elevation and box shadows based on design/DESIGN.md.
class AppShadows {
  AppShadows._();

  /// Standard shadow: 0 8px 24px rgba(0,0,0,0.06)
  /// Applied to: Cards, search bar, header circle buttons, pills with shadow,
  /// bottom nav, reminder card, AI bubbles.
  static const BoxShadow standard = BoxShadow(
    offset: Offset(0, 8),
    blurRadius: 24,
    color: Color.fromRGBO(0, 0, 0, 0.06),
  );

  /// Field shadow: 0 4px 12px rgba(0,0,0,0.03)
  /// Applied to: Form inputs and textareas.
  static const BoxShadow field = BoxShadow(
    offset: Offset(0, 4),
    blurRadius: 12,
    color: Color.fromRGBO(0, 0, 0, 0.03),
  );
  static const BoxShadow inputField = field;

  /// Field focus shadow: 0 8px 20px rgba(0,0,0,0.06)
  static const BoxShadow fieldFocus = BoxShadow(
    offset: Offset(0, 8),
    blurRadius: 20,
    color: Color.fromRGBO(0, 0, 0, 0.06),
  );

  /// Selected segment shadow: 0 4px 12px rgba(0,0,0,0.08)
  /// Applied to: Active segmented option.
  static const BoxShadow selectedSegment = BoxShadow(
    offset: Offset(0, 4),
    blurRadius: 12,
    color: Color.fromRGBO(0, 0, 0, 0.08),
  );

  /// Stat tile shadow: 0 8px 24px rgba(0,0,0,0.03)
  /// Applied to: Rekap stat tiles.
  static const BoxShadow statTile = BoxShadow(
    offset: Offset(0, 8),
    blurRadius: 24,
    color: Color.fromRGBO(0, 0, 0, 0.03),
  );

  /// CTA shadow: 0 8px 24px rgba(0,0,0,0.12)
  /// Applied to: FAB, primary empty-state button.
  static const BoxShadow cta = BoxShadow(
    offset: Offset(0, 8),
    blurRadius: 24,
    color: Color.fromRGBO(0, 0, 0, 0.12),
  );

  /// Toast shadow: 0 8px 24px rgba(0,0,0,0.18)
  /// Applied to: Floating toast.
  static const BoxShadow toast = BoxShadow(
    offset: Offset(0, 8),
    blurRadius: 24,
    color: Color.fromRGBO(0, 0, 0, 0.18),
  );

  /// Popover shadow: 0 12px 32px rgba(0,0,0,0.14)
  /// Applied to: Three-dot menu popover.
  static const BoxShadow popover = BoxShadow(
    offset: Offset(0, 12),
    blurRadius: 32,
    color: Color.fromRGBO(0, 0, 0, 0.14),
  );

  /// Sheet shadow: 0 12px 36px rgba(0,0,0,0.16)
  /// Applied to: Aksi Cepat floating sheet.
  static const BoxShadow sheet = BoxShadow(
    offset: Offset(0, 12),
    blurRadius: 36,
    color: Color.fromRGBO(0, 0, 0, 0.16),
  );

  /// Top bar shadow: 0 1px 8px rgba(0,0,0,0.04)
  /// Applied to: Form top bar.
  static const BoxShadow topBar = BoxShadow(
    offset: Offset(0, 1),
    blurRadius: 8,
    color: Color.fromRGBO(0, 0, 0, 0.04),
  );

  /// Sticky action bar shadow: 0 -8px 24px rgba(0,0,0,0.06)
  /// Applied to: Fixed bottom action bar on forms.
  static const BoxShadow stickyActionBar = BoxShadow(
    offset: Offset(0, -8),
    blurRadius: 24,
    color: Color.fromRGBO(0, 0, 0, 0.06),
  );
}
