import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rg_design_system/rg_design_system.dart';

void main() {
  InputDecorationThemeData inputTheme(ThemeData theme) =>
      theme.inputDecorationTheme;

  Color borderColor(InputBorder? border) => border!.borderSide.color;

  group('RGTheme input decoration', () {
    final lightScheme = RGTheme.light.colorScheme;

    group('outlined borders (light)', () {
      final theme = inputTheme(RGTheme.light);

      test('enabled uses the outline token', () {
        expect(theme.enabledBorder, isA<OutlineInputBorder>());
        expect(borderColor(theme.enabledBorder), lightScheme.outline);
      });

      test('focused thickens to onSurface', () {
        expect(borderColor(theme.focusedBorder), lightScheme.onSurface);
        expect(theme.focusedBorder!.borderSide.width, 2);
      });

      test('error uses the error token', () {
        expect(borderColor(theme.errorBorder), lightScheme.error);
      });
    });

    group('label ink resolves by state (light)', () {
      final label =
          inputTheme(RGTheme.light).labelStyle! as WidgetStateTextStyle;

      test('disabled dims to 38% onSurface', () {
        expect(
          label.resolve({WidgetState.disabled}).color,
          lightScheme.onSurface.withValues(alpha: 0.38),
        );
      });

      test('error turns to the error token', () {
        expect(label.resolve({WidgetState.error}).color, lightScheme.error);
      });

      test('focused turns to onSurface', () {
        expect(
          label.resolve({WidgetState.focused}).color,
          lightScheme.onSurface,
        );
      });

      test('default is onSurfaceVariant', () {
        expect(
          label.resolve(<WidgetState>{}).color,
          lightScheme.onSurfaceVariant,
        );
      });
    });

    group('icon ink resolves by state (light)', () {
      final icon =
          inputTheme(RGTheme.light).prefixIconColor! as WidgetStateColor;

      test('disabled dims to 38% onSurface', () {
        expect(
          icon.resolve({WidgetState.disabled}),
          lightScheme.onSurface.withValues(alpha: 0.38),
        );
      });

      test('default is onSurfaceVariant', () {
        expect(icon.resolve(<WidgetState>{}), lightScheme.onSurfaceVariant);
      });
    });

    test('content padding and density', () {
      final theme = inputTheme(RGTheme.light);
      expect(theme.isDense, isTrue);
      expect(
        theme.contentPadding,
        const EdgeInsets.symmetric(
          horizontal: RGSpacing.md,
          vertical: RGSpacing.sm + RGSpacing.xs,
        ),
      );
    });

    test('dark mode inverts the enabled border', () {
      expect(
        borderColor(inputTheme(RGTheme.dark).enabledBorder),
        RGTheme.dark.colorScheme.outline,
      );
    });
  });
}
