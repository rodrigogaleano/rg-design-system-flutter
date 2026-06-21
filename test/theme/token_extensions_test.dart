import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rg_design_system/rg_design_system.dart';

void main() {
  group('RGSpacingTheme', () {
    const standard = RGSpacingTheme.standard();

    test('standard maps to the spacing tokens', () {
      expect(standard.xs, RGSpacing.xs);
      expect(standard.sm, RGSpacing.sm);
      expect(standard.md, RGSpacing.md);
      expect(standard.lg, RGSpacing.lg);
      expect(standard.xl, RGSpacing.xl);
      expect(standard.xxl, RGSpacing.xxl);
      expect(standard.xxxl, RGSpacing.xxxl);
    });

    group('copyWith', () {
      test('returns an equal scale when no overrides are given', () {
        final copy = standard.copyWith();
        expect(copy.xs, standard.xs);
        expect(copy.sm, standard.sm);
        expect(copy.md, standard.md);
        expect(copy.lg, standard.lg);
        expect(copy.xl, standard.xl);
        expect(copy.xxl, standard.xxl);
        expect(copy.xxxl, standard.xxxl);
      });

      test('overrides only the provided values', () {
        final copy = standard.copyWith(md: 99, xxxl: 1);
        expect(copy.md, 99);
        expect(copy.xxxl, 1);
        expect(copy.xs, standard.xs);
        expect(copy.lg, standard.lg);
      });
    });

    group('lerp', () {
      const other = RGSpacingTheme(
        xs: 10,
        sm: 20,
        md: 30,
        lg: 40,
        xl: 50,
        xxl: 60,
        xxxl: 70,
      );
      const start = RGSpacingTheme(
        xs: 0,
        sm: 0,
        md: 0,
        lg: 0,
        xl: 0,
        xxl: 0,
        xxxl: 0,
      );

      test('returns this when other is null', () {
        expect(standard.lerp(null, 0.5), same(standard));
      });

      test('returns the start values at t = 0', () {
        final result = start.lerp(other, 0);
        expect(result.xs, 0);
        expect(result.xxxl, 0);
      });

      test('returns the end values at t = 1', () {
        final result = start.lerp(other, 1);
        expect(result.xs, other.xs);
        expect(result.xxxl, other.xxxl);
      });

      test('interpolates halfway at t = 0.5', () {
        final result = start.lerp(other, 0.5);
        expect(result.xs, 5);
        expect(result.md, 15);
        expect(result.xxxl, 35);
      });
    });
  });

  group('RGRadiusTheme', () {
    const standard = RGRadiusTheme.standard();

    test('standard maps to the radius tokens', () {
      expect(standard.none, RGRadius.none);
      expect(standard.sm, RGRadius.sm);
      expect(standard.md, RGRadius.md);
      expect(standard.lg, RGRadius.lg);
      expect(standard.full, RGRadius.full);
    });

    group('copyWith', () {
      test('returns an equal scale when no overrides are given', () {
        final copy = standard.copyWith();
        expect(copy.none, standard.none);
        expect(copy.sm, standard.sm);
        expect(copy.md, standard.md);
        expect(copy.lg, standard.lg);
        expect(copy.full, standard.full);
      });

      test('overrides only the provided values', () {
        final copy = standard.copyWith(md: 99, full: 1);
        expect(copy.md, 99);
        expect(copy.full, 1);
        expect(copy.none, standard.none);
        expect(copy.lg, standard.lg);
      });
    });

    group('lerp', () {
      const other = RGRadiusTheme(
        none: 10,
        sm: 20,
        md: 30,
        lg: 40,
        full: 50,
      );
      const start = RGRadiusTheme(
        none: 0,
        sm: 0,
        md: 0,
        lg: 0,
        full: 0,
      );

      test('returns this when other is null', () {
        expect(standard.lerp(null, 0.5), same(standard));
      });

      test('returns the start values at t = 0', () {
        final result = start.lerp(other, 0);
        expect(result.none, 0);
        expect(result.full, 0);
      });

      test('returns the end values at t = 1', () {
        final result = start.lerp(other, 1);
        expect(result.none, other.none);
        expect(result.full, other.full);
      });

      test('interpolates halfway at t = 0.5', () {
        final result = start.lerp(other, 0.5);
        expect(result.none, 5);
        expect(result.md, 15);
        expect(result.full, 25);
      });
    });
  });

  group('RGThemeTokens', () {
    testWidgets('reads the scales registered on the theme', (tester) async {
      late RGSpacingTheme spacing;
      late RGRadiusTheme radius;

      await tester.pumpWidget(
        MaterialApp(
          theme: RGTheme.light,
          home: Builder(
            builder: (context) {
              spacing = context.spacing;
              radius = context.radius;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(spacing.md, RGSpacing.md);
      expect(radius.full, RGRadius.full);
    });

    testWidgets('falls back to the standard scales without a theme', (
      tester,
    ) async {
      late RGSpacingTheme spacing;
      late RGRadiusTheme radius;

      // A bare theme carries no RG extensions; the getters must not throw.
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(),
          home: Builder(
            builder: (context) {
              spacing = context.spacing;
              radius = context.radius;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(spacing.xxxl, RGSpacing.xxxl);
      expect(radius.none, RGRadius.none);
    });
  });
}
