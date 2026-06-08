import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rg_design_system/rg_design_system.dart';

void main() {
  group('RGColors', () {
    test('exposes the expected palette values', () {
      expect(RGColors.black, const Color(0xFF000000));
      expect(RGColors.white, const Color(0xFFFFFFFF));

      expect(RGColors.gray90, const Color(0xFF1A1A1A));
      expect(RGColors.gray60, const Color(0xFF666666));
      expect(RGColors.gray30, const Color(0xFFB3B3B3));
      expect(RGColors.gray10, const Color(0xFFE8E8E8));
      expect(RGColors.gray05, const Color(0xFFF5F5F5));

      expect(RGColors.success, const Color(0xFF2D6A4F));
      expect(RGColors.error, const Color(0xFFA4243B));
      expect(RGColors.warning, const Color(0xFFB08B2D));
    });

    test('every token is fully opaque', () {
      const tokens = <Color>[
        RGColors.black,
        RGColors.white,
        RGColors.gray90,
        RGColors.gray60,
        RGColors.gray30,
        RGColors.gray10,
        RGColors.gray05,
        RGColors.success,
        RGColors.error,
        RGColors.warning,
      ];

      for (final color in tokens) {
        expect(color.a, 1.0, reason: '$color should be fully opaque');
      }
    });
  });
}
