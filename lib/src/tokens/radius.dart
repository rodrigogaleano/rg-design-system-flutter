/// Border radius scale for the RG Design System.
///
/// The system is rectangular by default, so [none] is the baseline. Rounding is
/// applied deliberately, growing from subtle corners up to a fully pill-shaped
/// [full] value for circular and capsule elements.
abstract final class RGRadius {
  const RGRadius._();

  // MARK: - Scale

  /// Default; sharp rectangular corners.
  static const double none = 0;

  /// Subtle softening for inputs and small controls.
  static const double sm = 4;

  /// Standard rounding for cards and buttons.
  static const double md = 8;

  /// Pronounced rounding for sheets and large surfaces.
  static const double lg = 16;

  /// Fully rounded; pills, avatars, and circular elements.
  static const double full = 999;
}
