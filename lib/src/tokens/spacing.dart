/// Spacing scale for the RG Design System.
///
/// Built on a 4pt base unit so every gap, pad, and margin lands on a
/// predictable rhythm. The scale grows in even multiples, keeping vertical and
/// horizontal whitespace consistent across the system.
abstract final class RGSpacing {
  const RGSpacing._();

  // MARK: - Scale

  /// Base unit; hairline gaps between tightly related elements.
  static const double xs = 4;

  /// Inner padding for compact controls and chip-like elements.
  static const double sm = 8;

  /// Default spacing; standard padding and gaps between components.
  static const double md = 16;

  /// Separation between distinct groups within a section.
  static const double lg = 24;

  /// Section padding and spacing between major content blocks.
  static const double xl = 32;

  /// Generous breathing room between page-level sections.
  static const double xxl = 48;

  /// Largest token; top-level layout margins and hero spacing.
  static const double xxxl = 64;
}
