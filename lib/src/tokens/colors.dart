import 'package:flutter/painting.dart';

/// Monochromatic color palette for the RG Design System.
///
/// Hierarchy is built exclusively through type size and weight, never color.
/// The palette is trivially invertible: black and white swap roles between
/// light and dark mode, nothing else changes.
abstract final class RGColors {
  const RGColors._();

  // MARK: - Primary

  /// `#000000`. Foreground for text and icons; background in dark mode.
  static const Color black = Color.fromRGBO(0, 0, 0, 1);

  /// `#FFFFFF`. Background and canvas; foreground in dark mode.
  static const Color white = Color.fromRGBO(255, 255, 255, 1);

  // MARK: - Grays

  /// `#1A1A1A`. Secondary text on dark backgrounds.
  static const Color gray90 = Color.fromRGBO(26, 26, 26, 1);

  /// `#666666`. Captions, metadata, and disabled states.
  static const Color gray60 = Color.fromRGBO(102, 102, 102, 1);

  /// `#B3B3B3`. Borders, dividers, and placeholders.
  static const Color gray30 = Color.fromRGBO(179, 179, 179, 1);

  /// `#E8E8E8`. Subtle backgrounds and hover states.
  static const Color gray10 = Color.fromRGBO(232, 232, 232, 1);

  /// `#F5F5F5`. Page background and cards.
  static const Color gray05 = Color.fromRGBO(245, 245, 245, 1);

  // MARK: - State

  /// `#2D6A4F`. Success states and confirmations.
  static const Color success = Color.fromRGBO(45, 106, 79, 1);

  /// `#A4243B`. Error states and destructive actions.
  static const Color error = Color.fromRGBO(164, 36, 59, 1);

  /// `#B08B2D`. Warning states and caution indicators.
  static const Color warning = Color.fromRGBO(176, 139, 45, 1);
}
