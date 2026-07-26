import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rg_design_system/rg_design_system.dart';

void main() {
  // Pumps [child] inside a themed scaffold.
  Future<void> pumpSectionHeader(
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

  // The decoration of the header's backing box.
  BoxDecoration decorationOf(WidgetTester tester) {
    final box = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(RGSectionHeader),
        matching: find.byType(DecoratedBox),
      ),
    );
    return box.decoration as BoxDecoration;
  }

  // The hairline drawn under the label.
  BorderSide ruleOf(WidgetTester tester) =>
      (decorationOf(tester).border! as Border).bottom;

  // The rendered label.
  Text labelOf(WidgetTester tester) => tester.widget<Text>(find.byType(Text));

  group('RGSectionHeader', () {
    group('label', () {
      testWidgets('renders the copy uppercased', (tester) async {
        await pumpSectionHeader(tester, const RGSectionHeader('Appearance'));

        expect(find.text('APPEARANCE'), findsOneWidget);
        expect(find.text('Appearance'), findsNothing);
      });

      testWidgets('leaves copy that is already uppercase alone', (
        tester,
      ) async {
        await pumpSectionHeader(tester, const RGSectionHeader('UNITS'));

        expect(find.text('UNITS'), findsOneWidget);
      });

      testWidgets('uses the muted ink', (tester) async {
        await pumpSectionHeader(tester, const RGSectionHeader('Appearance'));

        expect(
          labelOf(tester).style?.color,
          RGTheme.light.colorScheme.onSurfaceVariant,
        );
      });

      testWidgets('follows the dark theme muted ink', (tester) async {
        await pumpSectionHeader(
          tester,
          const RGSectionHeader('Appearance'),
          theme: RGTheme.dark,
        );

        expect(
          labelOf(tester).style?.color,
          RGTheme.dark.colorScheme.onSurfaceVariant,
        );
      });
    });

    group('rule', () {
      testWidgets('paints a 1px hairline along the bottom', (tester) async {
        await pumpSectionHeader(tester, const RGSectionHeader('Appearance'));

        final rule = ruleOf(tester);
        expect(rule.color, RGTheme.light.colorScheme.outlineVariant);
        expect(rule.width, 1);
      });

      testWidgets('leaves the other three sides bare', (tester) async {
        await pumpSectionHeader(tester, const RGSectionHeader('Appearance'));

        final border = decorationOf(tester).border! as Border;
        expect(border.top, BorderSide.none);
        expect(border.left, BorderSide.none);
        expect(border.right, BorderSide.none);
      });

      testWidgets('follows the dark theme hairline', (tester) async {
        await pumpSectionHeader(
          tester,
          const RGSectionHeader('Appearance'),
          theme: RGTheme.dark,
        );

        expect(ruleOf(tester).color, RGTheme.dark.colorScheme.outlineVariant);
      });
    });

    group('layout', () {
      testWidgets('spans the full width of its parent', (tester) async {
        await pumpSectionHeader(
          tester,
          const SizedBox(width: 300, child: RGSectionHeader('Appearance')),
        );

        expect(tester.getSize(find.byType(RGSectionHeader)).width, 300);
      });

      testWidgets('gaps the label off the rule', (tester) async {
        await pumpSectionHeader(tester, const RGSectionHeader('Appearance'));

        // The rule is the last pixel, so the gap sits above it.
        final labelBottom = tester.getBottomLeft(find.byType(Text)).dy;
        final headerBottom = tester
            .getBottomLeft(find.byType(RGSectionHeader))
            .dy;
        expect(headerBottom - labelBottom, RGSpacing.sm + 1);
      });
    });
  });
}
