import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rg_design_system/rg_design_system.dart';

void main() {
  // Pumps [child] inside a themed scaffold.
  Future<void> pumpDivider(
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

  // Finder for the line containers inside the divider.
  final lines = find.descendant(
    of: find.byType(RGDivider),
    matching: find.byType(Container),
  );

  group('RGDivider', () {
    group('plain', () {
      testWidgets('renders a single 1px line without text', (tester) async {
        await pumpDivider(tester, const RGDivider());

        expect(lines, findsOneWidget);
        expect(tester.getSize(lines).height, 1);
        expect(find.byType(Text), findsNothing);
      });

      testWidgets('uses the outline color', (tester) async {
        await pumpDivider(tester, const RGDivider());

        final line = tester.widget<Container>(lines);
        expect(line.color, RGTheme.light.colorScheme.outline);
      });

      testWidgets('follows the dark theme outline', (tester) async {
        await pumpDivider(tester, const RGDivider(), theme: RGTheme.dark);

        final line = tester.widget<Container>(lines);
        expect(line.color, RGTheme.dark.colorScheme.outline);
      });
    });

    group('labeled', () {
      testWidgets('renders the label between two lines', (tester) async {
        await pumpDivider(tester, const RGDivider.labeled(label: 'ou'));

        expect(find.text('ou'), findsOneWidget);
        expect(lines, findsNWidgets(2));
      });

      testWidgets('label uses the muted ink', (tester) async {
        await pumpDivider(tester, const RGDivider.labeled(label: 'ou'));

        final text = tester.widget<Text>(find.text('ou'));
        expect(text.style?.color, RGTheme.light.colorScheme.onSurfaceVariant);
      });

      testWidgets('lines flank the label horizontally', (tester) async {
        await pumpDivider(tester, const RGDivider.labeled(label: 'ou'));

        final labelX = tester.getCenter(find.text('ou')).dx;
        expect(tester.getCenter(lines.at(0)).dx, lessThan(labelX));
        expect(tester.getCenter(lines.at(1)).dx, greaterThan(labelX));
      });

      testWidgets('lines sit on a whole pixel', (tester) async {
        await pumpDivider(tester, const RGDivider.labeled(label: 'ou'));

        // A fractional offset anti-aliases the 1px stroke into a fatter one.
        final dividerTop = tester.getTopLeft(find.byType(RGDivider)).dy;
        final lineTop = tester.getTopLeft(lines.at(0)).dy;
        final offset = lineTop - dividerTop;
        expect(offset, offset.roundToDouble());
      });
    });
  });
}
