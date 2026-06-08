import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rg_design_system/rg_design_system.dart';

void main() {
  group('RGTextStyles', () {
    final tokens = <String, TextStyle>{
      'display': RGTextStyles.display,
      'h1': RGTextStyles.h1,
      'h2': RGTextStyles.h2,
      'h3': RGTextStyles.h3,
      'h4': RGTextStyles.h4,
      'bodyL': RGTextStyles.bodyL,
      'body': RGTextStyles.body,
      'bodyS': RGTextStyles.bodyS,
      'caption': RGTextStyles.caption,
      'overline': RGTextStyles.overline,
      'micro': RGTextStyles.micro,
    };

    group('inherits the shared base', () {
      tokens.forEach((name, style) {
        test('$name uses the system family, fallback and ink color', () {
          expect(style.fontFamily, RGTextStyles.fontFamily);
          expect(style.fontFamilyFallback, const <String>[
            'Helvetica',
            'Arial',
            'sans-serif',
          ]);
          expect(style.color, RGColors.black);
        });
      });
    });

    group('matches the type scale', () {
      void expectMetrics(
        TextStyle style, {
        required double size,
        required double height,
        required FontWeight weight,
        required double spacing,
      }) {
        expect(style.fontSize, size);
        expect(style.height, height);
        expect(style.fontWeight, weight);
        expect(style.letterSpacing, spacing);
      }

      test('display', () {
        expectMetrics(
          RGTextStyles.display,
          size: 72,
          height: 1,
          weight: FontWeight.w700,
          spacing: -1.44,
        );
      });

      test('h1', () {
        expectMetrics(
          RGTextStyles.h1,
          size: 48,
          height: 52 / 48,
          weight: FontWeight.w700,
          spacing: -0.48,
        );
      });

      test('h2', () {
        expectMetrics(
          RGTextStyles.h2,
          size: 32,
          height: 36 / 32,
          weight: FontWeight.w700,
          spacing: 0,
        );
      });

      test('h3', () {
        expectMetrics(
          RGTextStyles.h3,
          size: 24,
          height: 28 / 24,
          weight: FontWeight.w700,
          spacing: 0,
        );
      });

      test('h4', () {
        expectMetrics(
          RGTextStyles.h4,
          size: 18,
          height: 22 / 18,
          weight: FontWeight.w700,
          spacing: 0,
        );
      });

      test('bodyL', () {
        expectMetrics(
          RGTextStyles.bodyL,
          size: 16,
          height: 24 / 16,
          weight: FontWeight.w400,
          spacing: 0,
        );
      });

      test('body', () {
        expectMetrics(
          RGTextStyles.body,
          size: 14,
          height: 22 / 14,
          weight: FontWeight.w400,
          spacing: 0,
        );
      });

      test('bodyS', () {
        expectMetrics(
          RGTextStyles.bodyS,
          size: 12,
          height: 18 / 12,
          weight: FontWeight.w400,
          spacing: 0,
        );
      });

      test('caption', () {
        expectMetrics(
          RGTextStyles.caption,
          size: 10,
          height: 15 / 10,
          weight: FontWeight.w400,
          spacing: 0.2,
        );
      });

      test('overline', () {
        expectMetrics(
          RGTextStyles.overline,
          size: 9,
          height: 14 / 9,
          weight: FontWeight.w700,
          spacing: 0.72,
        );
      });

      test('micro', () {
        expectMetrics(
          RGTextStyles.micro,
          size: 7,
          height: 11 / 7,
          weight: FontWeight.w400,
          spacing: 0.28,
        );
      });
    });
  });
}
