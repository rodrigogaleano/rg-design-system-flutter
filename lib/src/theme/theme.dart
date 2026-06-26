import 'package:flutter/material.dart';

import 'package:rg_design_system/src/theme/token_extensions.dart';
import 'package:rg_design_system/src/tokens/colors.dart';
import 'package:rg_design_system/src/tokens/radius.dart';
import 'package:rg_design_system/src/tokens/spacing.dart';
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
      inputDecorationTheme: _inputDecorationTheme(colorScheme),
      extensions: const <ThemeExtension<dynamic>>[
        RGSpacingTheme.standard(),
        RGRadiusTheme.standard(),
      ],
    );
  }

  // MARK: - InputDecorationTheme

  /// The DS look for every Material input. Encodes the outlined variant, so a
  /// bare [TextField] adopts the system without any per-field decoration;
  /// the filled variant layers its fill and underline on top.
  static InputDecorationThemeData _inputDecorationTheme(ColorScheme scheme) {
    final radius = BorderRadius.circular(RGRadius.sm);

    OutlineInputBorder border(Color color, {double width = 1}) =>
        OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: color, width: width),
        );

    return InputDecorationThemeData(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: RGSpacing.md,
        vertical: RGSpacing.sm + RGSpacing.xs,
      ),
      hintStyle: RGTextStyles.body.copyWith(color: scheme.onSurfaceVariant),
      helperStyle: RGTextStyles.bodyS.copyWith(color: scheme.onSurfaceVariant),
      errorStyle: RGTextStyles.bodyS.copyWith(color: scheme.error),
      labelStyle: _labelInk(RGTextStyles.body, scheme),
      floatingLabelStyle: _labelInk(RGTextStyles.bodyS, scheme),
      prefixIconColor: _iconInk(scheme),
      suffixIconColor: _iconInk(scheme),
      enabledBorder: border(scheme.outline),
      focusedBorder: border(scheme.onSurface, width: 2),
      errorBorder: border(scheme.error),
      focusedErrorBorder: border(scheme.error, width: 2),
      disabledBorder: border(scheme.onSurface.withValues(alpha: 0.12)),
      border: border(scheme.outline),
    );
  }

  /// Label ink that follows the disabled, error, and focused states.
  static TextStyle _labelInk(TextStyle base, ColorScheme scheme) =>
      WidgetStateTextStyle.resolveWith(
        (states) => base.copyWith(color: _stateInk(states, scheme)),
      );

  /// Icon ink, dimmed only while the field is disabled.
  static Color _iconInk(ColorScheme scheme) => WidgetStateColor.resolveWith(
    (states) => states.contains(WidgetState.disabled)
        ? scheme.onSurface.withValues(alpha: 0.38)
        : scheme.onSurfaceVariant,
  );

  static Color _stateInk(Set<WidgetState> states, ColorScheme scheme) {
    if (states.contains(WidgetState.disabled)) {
      return scheme.onSurface.withValues(alpha: 0.38);
    }
    if (states.contains(WidgetState.error)) return scheme.error;
    if (states.contains(WidgetState.focused)) return scheme.onSurface;
    return scheme.onSurfaceVariant;
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
