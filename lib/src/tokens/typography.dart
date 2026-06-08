import 'package:flutter/widgets.dart';

import 'colors.dart';

/// Typographic scale for the RG Design System.
///
/// Hierarchy is expressed through size and weight alone. Every token shares the
/// same typeface and ink color, deriving from a single private [_base] so the
/// family, fallback stack, and color stay in one place.
///
/// The font is declared by name only. Bundling the files is the consuming app's
/// job, which keeps this package free of dependencies.
abstract final class RGTextStyles {
  const RGTextStyles._();

  // MARK: - Font

  /// Primary typeface for the entire system.
  static const String fontFamily = 'Helvetica Neue';

  static const List<String> _fontFamilyFallback = <String>[
    'Helvetica',
    'Arial',
    'sans-serif',
  ];

  static const TextStyle _base = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    color: RGColors.black,
  );

  // MARK: - Display

  /// Hero numbers and oversized statement headlines. Use once per view, at most.
  static final TextStyle display = _base.copyWith(
    fontSize: 72,
    height: 1.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.44,
  );

  // MARK: - Headings

  /// Primary page title; the largest heading in normal content flow.
  static final TextStyle h1 = _base.copyWith(
    fontSize: 48,
    height: 52 / 48,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.48,
  );

  /// Major section heading.
  static final TextStyle h2 = _base.copyWith(
    fontSize: 32,
    height: 36 / 32,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );

  /// Subsection heading.
  static final TextStyle h3 = _base.copyWith(
    fontSize: 24,
    height: 28 / 24,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );

  /// Smallest heading; card titles and list-group labels.
  static final TextStyle h4 = _base.copyWith(
    fontSize: 18,
    height: 22 / 18,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );

  // MARK: - Body

  /// Large body copy; lead paragraphs and comfortable reading contexts.
  static final TextStyle bodyL = _base.copyWith(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  /// Default body text for most UI.
  static final TextStyle body = _base.copyWith(
    fontSize: 14,
    height: 22 / 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  /// Small body copy; secondary descriptions and dense layouts.
  static final TextStyle bodyS = _base.copyWith(
    fontSize: 12,
    height: 18 / 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  // MARK: - Supporting

  /// Captions, metadata, and timestamps beneath content.
  static final TextStyle caption = _base.copyWith(
    fontSize: 10,
    height: 15 / 10,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
  );

  /// Uppercase eyebrow labels and section kickers; tracked wide for legibility.
  static final TextStyle overline = _base.copyWith(
    fontSize: 9,
    height: 14 / 9,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.72,
  );

  /// Smallest token; legal lines, fine print, and dense annotations.
  static final TextStyle micro = _base.copyWith(
    fontSize: 7,
    height: 11 / 7,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.28,
  );
}
