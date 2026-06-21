import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'package:rg_design_system/src/tokens/radius.dart';
import 'package:rg_design_system/src/tokens/spacing.dart';

/// Exposes [RGSpacing] through the theme.
///
/// Registering the scale as a [ThemeExtension] lets widgets read spacing from
/// `context` (see [RGThemeTokens.spacing]) and lets the values interpolate
/// smoothly when themes animate between one another.
@immutable
class RGSpacingTheme extends ThemeExtension<RGSpacingTheme> {
  /// Creates a spacing theme with explicit values.
  const RGSpacingTheme({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.xxxl,
  });

  /// The default scale, backed by the [RGSpacing] tokens.
  const RGSpacingTheme.standard()
    : xs = RGSpacing.xs,
      sm = RGSpacing.sm,
      md = RGSpacing.md,
      lg = RGSpacing.lg,
      xl = RGSpacing.xl,
      xxl = RGSpacing.xxl,
      xxxl = RGSpacing.xxxl;

  /// See [RGSpacing.xs].
  final double xs;

  /// See [RGSpacing.sm].
  final double sm;

  /// See [RGSpacing.md].
  final double md;

  /// See [RGSpacing.lg].
  final double lg;

  /// See [RGSpacing.xl].
  final double xl;

  /// See [RGSpacing.xxl].
  final double xxl;

  /// See [RGSpacing.xxxl].
  final double xxxl;

  @override
  RGSpacingTheme copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? xxxl,
  }) {
    return RGSpacingTheme(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      xxxl: xxxl ?? this.xxxl,
    );
  }

  @override
  RGSpacingTheme lerp(RGSpacingTheme? other, double t) {
    if (other == null) return this;
    return RGSpacingTheme(
      xs: lerpDouble(xs, other.xs, t)!,
      sm: lerpDouble(sm, other.sm, t)!,
      md: lerpDouble(md, other.md, t)!,
      lg: lerpDouble(lg, other.lg, t)!,
      xl: lerpDouble(xl, other.xl, t)!,
      xxl: lerpDouble(xxl, other.xxl, t)!,
      xxxl: lerpDouble(xxxl, other.xxxl, t)!,
    );
  }
}

/// Exposes [RGRadius] through the theme.
///
/// Mirrors [RGSpacingTheme]: widgets read corner radii from `context` (see
/// [RGThemeTokens.radius]) and the values lerp during theme transitions.
@immutable
class RGRadiusTheme extends ThemeExtension<RGRadiusTheme> {
  /// Creates a radius theme with explicit values.
  const RGRadiusTheme({
    required this.none,
    required this.sm,
    required this.md,
    required this.lg,
    required this.full,
  });

  /// The default scale, backed by the [RGRadius] tokens.
  const RGRadiusTheme.standard()
    : none = RGRadius.none,
      sm = RGRadius.sm,
      md = RGRadius.md,
      lg = RGRadius.lg,
      full = RGRadius.full;

  /// See [RGRadius.none].
  final double none;

  /// See [RGRadius.sm].
  final double sm;

  /// See [RGRadius.md].
  final double md;

  /// See [RGRadius.lg].
  final double lg;

  /// See [RGRadius.full].
  final double full;

  @override
  RGRadiusTheme copyWith({
    double? none,
    double? sm,
    double? md,
    double? lg,
    double? full,
  }) {
    return RGRadiusTheme(
      none: none ?? this.none,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      full: full ?? this.full,
    );
  }

  @override
  RGRadiusTheme lerp(RGRadiusTheme? other, double t) {
    if (other == null) return this;
    return RGRadiusTheme(
      none: lerpDouble(none, other.none, t)!,
      sm: lerpDouble(sm, other.sm, t)!,
      md: lerpDouble(md, other.md, t)!,
      lg: lerpDouble(lg, other.lg, t)!,
      full: lerpDouble(full, other.full, t)!,
    );
  }
}

/// Ergonomic access to the RG token extensions from a [BuildContext].
///
/// Falls back to the standard scales when no theme is in scope, so reads never
/// throw even outside a configured [Theme].
extension RGThemeTokens on BuildContext {
  /// The spacing scale registered on the nearest theme.
  RGSpacingTheme get spacing =>
      Theme.of(this).extension<RGSpacingTheme>() ??
      const RGSpacingTheme.standard();

  /// The radius scale registered on the nearest theme.
  RGRadiusTheme get radius =>
      Theme.of(this).extension<RGRadiusTheme>() ??
      const RGRadiusTheme.standard();
}
