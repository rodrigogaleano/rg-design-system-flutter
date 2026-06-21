import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rg_design_system/rg_design_system.dart';

void main() {
  group('RGTheme', () {
    test('exposes a light and a dark theme', () {
      expect(RGTheme.light.brightness, Brightness.light);
      expect(RGTheme.dark.brightness, Brightness.dark);
    });

    test('opts into Material 3', () {
      expect(RGTheme.light.useMaterial3, isTrue);
      expect(RGTheme.dark.useMaterial3, isTrue);
    });

    group('color scheme', () {
      test('inverts primary and surface between modes', () {
        final light = RGTheme.light.colorScheme;
        final dark = RGTheme.dark.colorScheme;

        expect(light.primary, RGColors.black);
        expect(light.onPrimary, RGColors.white);
        expect(light.surface, RGColors.white);
        expect(light.onSurface, RGColors.black);

        expect(dark.primary, RGColors.white);
        expect(dark.onPrimary, RGColors.black);
        expect(dark.surface, RGColors.black);
        expect(dark.onSurface, RGColors.white);
      });

      test('keeps the error color constant across modes', () {
        expect(RGTheme.light.colorScheme.error, RGColors.error);
        expect(RGTheme.dark.colorScheme.error, RGColors.error);
      });
    });

    group('scaffold background', () {
      test('follows the canvas of each mode', () {
        expect(RGTheme.light.scaffoldBackgroundColor, RGColors.white);
        expect(RGTheme.dark.scaffoldBackgroundColor, RGColors.black);
      });
    });

    group('text theme', () {
      test('maps key slots to the type scale', () {
        final body = RGTheme.light.textTheme.bodyMedium!;
        expect(body.fontSize, RGTextStyles.body.fontSize);
        expect(body.fontWeight, RGTextStyles.body.fontWeight);

        final title = RGTheme.light.textTheme.titleLarge!;
        expect(title.fontSize, RGTextStyles.h4.fontSize);
        expect(title.fontWeight, RGTextStyles.h4.fontWeight);
      });

      test('paints ink to match the mode', () {
        expect(RGTheme.light.textTheme.bodyMedium!.color, RGColors.black);
        expect(RGTheme.dark.textTheme.bodyMedium!.color, RGColors.white);
      });

      test('recolors display slots from the scheme too', () {
        expect(RGTheme.light.textTheme.displayLarge!.color, RGColors.black);
        expect(RGTheme.dark.textTheme.displayLarge!.color, RGColors.white);
      });
    });

    group('token extensions', () {
      test('registers spacing and radius on both modes', () {
        for (final theme in <ThemeData>[RGTheme.light, RGTheme.dark]) {
          expect(theme.extension<RGSpacingTheme>(), isNotNull);
          expect(theme.extension<RGRadiusTheme>(), isNotNull);
        }
      });

      test('exposes the standard token values', () {
        final spacing = RGTheme.light.extension<RGSpacingTheme>()!;
        expect(spacing.md, RGSpacing.md);
        expect(spacing.xxxl, RGSpacing.xxxl);

        final radius = RGTheme.light.extension<RGRadiusTheme>()!;
        expect(radius.none, RGRadius.none);
        expect(radius.full, RGRadius.full);
      });
    });
  });
}
