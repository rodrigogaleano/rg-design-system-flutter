import 'package:flutter/material.dart';

import 'package:rg_design_system/src/theme/token_extensions.dart';
import 'package:rg_design_system/src/tokens/colors.dart';
import 'package:rg_design_system/src/tokens/typography.dart';

/// Material themes for the RG Design System.
///
/// Binds the primitive tokens into ready-to-use [ThemeData] for both modes.
/// The palette is monochromatic and invertible: black and white swap roles
/// between [light] and [dark], so the [ColorScheme] is built by hand rather
/// than derived from a seed, which would introduce off-system tints. Spacing
/// and radius tokens ride along as [ThemeExtension]s.
abstract final class RGTheme {
  const RGTheme._();

  // MARK: - Themes

  /// Light mode; white canvas with black ink.
  static ThemeData get light => _build(Brightness.light);

  /// Dark mode; black canvas with white ink.
  static ThemeData get dark => _build(Brightness.dark);

  // MARK: - Builder

  static ThemeData _build(Brightness brightness) {
    final colorScheme = _colorScheme(brightness);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: _textTheme(colorScheme),
      scaffoldBackgroundColor: colorScheme.surface,
      extensions: const <ThemeExtension<dynamic>>[
        RGSpacingTheme.standard(),
        RGRadiusTheme.standard(),
      ],
    );
  }

  // MARK: - ColorScheme

  static ColorScheme _colorScheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;

    // Black/white anchor the scheme; the gray ramp fills the tonal roles, so
    // every surface and container stays strictly monochromatic.
    return ColorScheme(
      brightness: brightness,
      primary: isLight ? RGColors.black : RGColors.white,
      onPrimary: isLight ? RGColors.white : RGColors.black,
      primaryContainer: isLight ? RGColors.gray10 : RGColors.gray90,
      onPrimaryContainer: isLight ? RGColors.black : RGColors.white,
      secondary: isLight ? RGColors.gray90 : RGColors.gray10,
      onSecondary: isLight ? RGColors.white : RGColors.black,
      secondaryContainer: isLight ? RGColors.gray05 : RGColors.gray90,
      onSecondaryContainer: isLight ? RGColors.black : RGColors.white,
      tertiary: isLight ? RGColors.gray60 : RGColors.gray30,
      onTertiary: isLight ? RGColors.white : RGColors.black,
      tertiaryContainer: isLight ? RGColors.gray05 : RGColors.gray90,
      onTertiaryContainer: isLight ? RGColors.black : RGColors.white,
      error: RGColors.error,
      onError: RGColors.white,
      errorContainer: isLight ? RGColors.gray10 : RGColors.gray90,
      onErrorContainer: RGColors.error,
      surface: isLight ? RGColors.white : RGColors.black,
      onSurface: isLight ? RGColors.black : RGColors.white,
      onSurfaceVariant: isLight ? RGColors.gray60 : RGColors.gray30,
      surfaceContainerLowest: isLight ? RGColors.white : RGColors.black,
      surfaceContainerLow: isLight ? RGColors.gray05 : RGColors.gray90,
      surfaceContainer: isLight ? RGColors.gray05 : RGColors.gray90,
      surfaceContainerHigh: isLight ? RGColors.gray10 : RGColors.gray90,
      surfaceContainerHighest: isLight ? RGColors.gray10 : RGColors.gray90,
      surfaceDim: isLight ? RGColors.gray10 : RGColors.black,
      surfaceBright: isLight ? RGColors.white : RGColors.gray90,
      outline: isLight ? RGColors.gray30 : RGColors.gray60,
      outlineVariant: isLight ? RGColors.gray10 : RGColors.gray90,
      inverseSurface: isLight ? RGColors.black : RGColors.white,
      onInverseSurface: isLight ? RGColors.white : RGColors.black,
      inversePrimary: isLight ? RGColors.white : RGColors.black,
      shadow: RGColors.black,
      scrim: RGColors.black,
    );
  }

  // MARK: - TextTheme

  static TextTheme _textTheme(ColorScheme colorScheme) {
    final base = TextTheme(
      displayLarge: RGTextStyles.display,
      headlineLarge: RGTextStyles.h1,
      headlineMedium: RGTextStyles.h2,
      headlineSmall: RGTextStyles.h3,
      titleLarge: RGTextStyles.h4,
      titleMedium: RGTextStyles.bodyL,
      titleSmall: RGTextStyles.body,
      bodyLarge: RGTextStyles.bodyL,
      bodyMedium: RGTextStyles.body,
      bodySmall: RGTextStyles.bodyS,
      labelLarge: RGTextStyles.body,
      labelMedium: RGTextStyles.caption,
      labelSmall: RGTextStyles.micro,
    );

    // The token styles bake in black ink; recolor the whole theme from the
    // scheme so text follows the surface in either mode from a single source.
    return base.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );
  }
}
