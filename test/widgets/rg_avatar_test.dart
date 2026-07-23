import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rg_design_system/rg_design_system.dart';

void main() {
  // Pumps [child] inside a themed scaffold.
  Future<void> pumpAvatar(
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

  // The decoration of the avatar's backing box.
  BoxDecoration decorationOf(WidgetTester tester) {
    final box = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(RGAvatar),
        matching: find.byType(DecoratedBox),
      ),
    );
    return box.decoration as BoxDecoration;
  }

  // The rendered monogram text.
  Text monogramOf(WidgetTester tester) =>
      tester.widget<Text>(find.byType(Text));

  group('RGAvatar', () {
    group('monogram', () {
      testWidgets('renders the initials', (tester) async {
        await pumpAvatar(tester, const RGAvatar('RG'));
        expect(find.text('RG'), findsOneWidget);
      });

      testWidgets('scales the monogram to the size', (tester) async {
        await pumpAvatar(tester, const RGAvatar('RG', size: 48));
        expect(monogramOf(tester).style?.fontSize, 48 * 0.36);

        await pumpAvatar(tester, const RGAvatar('RG', size: 80));
        expect(monogramOf(tester).style?.fontSize, 80 * 0.36);
      });

      testWidgets('inks the monogram from onSurface', (tester) async {
        await pumpAvatar(tester, const RGAvatar('RG'));
        expect(
          monogramOf(tester).style?.color,
          RGTheme.light.colorScheme.onSurface,
        );
      });
    });

    group('shape', () {
      testWidgets('is a full circle', (tester) async {
        await pumpAvatar(tester, const RGAvatar('RG'));
        expect(decorationOf(tester).borderRadius, BorderRadius.circular(999));
      });
    });

    group('size', () {
      testWidgets('lays out a square of the given size', (tester) async {
        await pumpAvatar(tester, const RGAvatar('RG', size: 56));
        expect(tester.getSize(find.byType(RGAvatar)), const Size(56, 56));
      });
    });

    group('accessibility', () {
      testWidgets('exposes the initials as the label', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpAvatar(tester, const RGAvatar('RG'));
        expect(
          tester.getSemantics(find.byType(RGAvatar)),
          matchesSemantics(label: 'RG'),
        );
        handle.dispose();
      });
    });
  });
}
