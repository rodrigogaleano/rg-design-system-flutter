import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rg_design_system/rg_design_system.dart';

void main() {
  // Pumps [child] inside a themed scaffold and returns the rendered [Text].
  Future<Text> pumpText(
    WidgetTester tester,
    RGText child, {
    ThemeData? theme,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: theme ?? RGTheme.light,
        home: Scaffold(body: child),
      ),
    );
    return tester.widget<Text>(find.byType(Text));
  }

  group('RGText', () {
    // Each named constructor paired with the token it must render.
    final cases = <String, (RGText, TextStyle)>{
      'display': (RGText.display('x'), RGTextStyles.display),
      'h1': (RGText.h1('x'), RGTextStyles.h1),
      'h2': (RGText.h2('x'), RGTextStyles.h2),
      'h3': (RGText.h3('x'), RGTextStyles.h3),
      'h4': (RGText.h4('x'), RGTextStyles.h4),
      'bodyL': (RGText.bodyL('x'), RGTextStyles.bodyL),
      'body': (RGText.body('x'), RGTextStyles.body),
      'bodyS': (RGText.bodyS('x'), RGTextStyles.bodyS),
      'caption': (RGText.caption('x'), RGTextStyles.caption),
      'overline': (RGText.overline('x'), RGTextStyles.overline),
      'micro': (RGText.micro('x'), RGTextStyles.micro),
    };

    group('maps each constructor to its token metrics', () {
      cases.forEach((name, data) {
        testWidgets(name, (tester) async {
          final (widget, token) = data;
          final text = await pumpText(tester, widget);

          expect(text.style!.fontSize, token.fontSize);
          expect(text.style!.fontWeight, token.fontWeight);
          expect(text.style!.height, token.height);
          expect(text.style!.letterSpacing, token.letterSpacing);
        });
      });
    });

    group('color', () {
      testWidgets('defaults to onSurface in light mode', (tester) async {
        final text = await pumpText(tester, RGText.body('x'));
        expect(text.style!.color, RGColors.black);
      });

      testWidgets('defaults to onSurface in dark mode', (tester) async {
        final text = await pumpText(
          tester,
          RGText.body('x'),
          theme: RGTheme.dark,
        );
        expect(text.style!.color, RGColors.white);
      });

      testWidgets('honors an explicit override over the mode', (tester) async {
        final text = await pumpText(
          tester,
          RGText.body('x', color: RGColors.error),
          theme: RGTheme.dark,
        );
        expect(text.style!.color, RGColors.error);
      });

      testWidgets('keeps a color carried by style over the mode', (
        tester,
      ) async {
        final text = await pumpText(
          tester,
          RGText.body('x', style: const TextStyle(color: RGColors.error)),
          theme: RGTheme.dark,
        );
        expect(text.style!.color, RGColors.error);
      });

      testWidgets('lets an explicit color win over style', (tester) async {
        final text = await pumpText(
          tester,
          RGText.body(
            'x',
            color: RGColors.white,
            style: const TextStyle(color: RGColors.error),
          ),
        );
        expect(text.style!.color, RGColors.white);
      });
    });

    group('style override', () {
      testWidgets('merges over the token without losing its metrics', (
        tester,
      ) async {
        final text = await pumpText(
          tester,
          RGText.h1('x', style: const TextStyle(fontStyle: FontStyle.italic)),
        );

        expect(text.style!.fontStyle, FontStyle.italic);
        expect(text.style!.fontSize, RGTextStyles.h1.fontSize);
      });
    });

    group('passthrough', () {
      testWidgets('forwards layout properties to the Text', (tester) async {
        final text = await pumpText(
          tester,
          RGText.body(
            'x',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        );

        expect(text.textAlign, TextAlign.center);
        expect(text.maxLines, 2);
        expect(text.overflow, TextOverflow.ellipsis);
      });
    });

    testWidgets('renders the given string', (tester) async {
      await pumpText(tester, RGText.body('hello'));
      expect(find.text('hello'), findsOneWidget);
    });
  });
}
