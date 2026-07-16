import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rg_design_system/rg_design_system.dart';

void main() {
  // Pumps [child] inside a themed scaffold.
  Future<void> pumpButton(
    WidgetTester tester,
    Widget child, {
    ThemeData? theme,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: theme ?? RGTheme.light,
        home: Scaffold(body: Center(child: child)),
      ),
    );
  }

  group('RGSocialButton', () {
    testWidgets('renders the label', (tester) async {
      await pumpButton(
        tester,
        RGSocialButton.google(
          label: 'Continuar com Google',
          onPressed: () {},
        ),
      );
      expect(find.text('Continuar com Google'), findsOneWidget);
    });

    testWidgets('embeds the provider glyph for named constructors', (
      tester,
    ) async {
      await pumpButton(
        tester,
        RGSocialButton.apple(label: 'Continuar com Apple', onPressed: () {}),
      );
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('keeps the Google mark multicolor (no color filter)', (
      tester,
    ) async {
      // Google's branding guidelines forbid recoloring the "G": it must stay
      // the standard multicolor mark, so the glyph carries no color filter.
      await pumpButton(
        tester,
        RGSocialButton.google(
          label: 'Continuar com Google',
          onPressed: () {},
        ),
      );
      final glyph = tester.widget<SvgPicture>(find.byType(SvgPicture));
      expect(glyph.colorFilter, isNull);
    });

    testWidgets('tints the Apple glyph with the button ink', (tester) async {
      // Apple's mark is monochrome, so it follows the button's foreground to
      // stay within the system's single-ink identity.
      await pumpButton(
        tester,
        RGSocialButton.apple(label: 'Continuar com Apple', onPressed: () {}),
      );
      final glyph = tester.widget<SvgPicture>(find.byType(SvgPicture));
      expect(glyph.colorFilter, isNotNull);
    });

    testWidgets('renders the supplied icon for the generic constructor', (
      tester,
    ) async {
      await pumpButton(
        tester,
        const RGSocialButton(
          icon: Icon(Icons.star),
          label: 'Continuar',
          onPressed: _noop,
        ),
      );
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('fires onPressed when tapped', (tester) async {
      var taps = 0;
      await pumpButton(
        tester,
        RGSocialButton.google(
          label: 'Continuar com Google',
          onPressed: () => taps++,
        ),
      );
      await tester.tap(find.byType(RGSocialButton));
      expect(taps, 1);
    });

    testWidgets('is disabled when onPressed is null', (tester) async {
      await pumpButton(
        tester,
        const RGSocialButton.google(label: 'Continuar com Google'),
      );
      final button = tester.widget<TextButton>(find.byType(TextButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('expands to the available width by default', (tester) async {
      await pumpButton(
        tester,
        RGSocialButton.google(
          label: 'Continuar com Google',
          onPressed: () {},
        ),
      );
      final box = tester.getSize(find.byType(TextButton));
      final screen = tester.getSize(find.byType(Scaffold));
      expect(box.width, screen.width);
    });
  });
}

void _noop() {}
