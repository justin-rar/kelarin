/// Dimension, radius, and spacing tokens based on design/DESIGN.md.
class AppDimens {
  AppDimens._();

  // Spacing
  static const double margin = 20.0;
  static const double gutter = 12.0;

  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 12.0;
  static const double spaceLg = 16.0;
  static const double spaceXl = 24.0;

  // Shapes / Radii
  static const double radiusSm = 4.0;
  static const double radiusMd = 6.0;
  static const double radiusLg = 8.0;
  static const double radiusXl = 12.0; // Editor tool buttons
  static const double radius2Xl = 16.0; // Form fields, search bar, segmented, popover, dock, chat bubbles
  static const double radiusFab = 20.0; // FAB (56x56), toast
  static const double radiusCard = 24.0; // List cards, stat tiles, empty cards, reminder card, settings
  static const double radiusSheet = 28.0; // Aksi Cepat floating sheet
  static const double radiusNav = 32.0; // Floating bottom nav
  static const double radiusFull = 9999.0; // Pills, chips, buttons, avatars, checkboxes

  // Backward compatibility aliases
  static const double radiusInput = radius2Xl;
}
