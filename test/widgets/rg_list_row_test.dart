import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rg_design_system/rg_design_system.dart';

void main() {
  // Pumps [child] inside a themed scaffold.
  Future<void> pumpListRow(
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

  // The decoration of the row's backing box.
  BoxDecoration decorationOf(WidgetTester tester) {
    final box = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(RGListRow),
        matching: find.byType(DecoratedBox),
      ),
    );
    return box.decoration as BoxDecoration;
  }

  // The hairline closing the row.
  BorderSide ruleOf(WidgetTester tester) =>
      (decorationOf(tester).border! as Border).bottom;

  // The rendered widget carrying [data].
  Text textOf(WidgetTester tester, String data) =>
      tester.widget<Text>(find.text(data));

  group('RGListRow', () {
    group('title', () {
      testWidgets('renders alone when the optional slots are null', (
        tester,
      ) async {
        await pumpListRow(tester, const RGListRow(title: 'Groceries'));

        expect(find.text('Groceries'), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);
      });

      testWidgets('truncates rather than wrapping', (tester) async {
        await pumpListRow(tester, const RGListRow(title: 'Groceries'));

        final title = textOf(tester, 'Groceries');
        expect(title.maxLines, 1);
        expect(title.overflow, TextOverflow.ellipsis);
      });

      testWidgets('uses the h4 scale by default', (tester) async {
        await pumpListRow(tester, const RGListRow(title: 'Groceries'));

        final title = textOf(tester, 'Groceries');
        expect(title.style?.fontSize, 18);
        expect(title.style?.fontWeight, FontWeight.w700);
      });

      testWidgets('drops to the body scale when secondary', (tester) async {
        await pumpListRow(
          tester,
          const RGListRow.secondary(title: 'Groceries'),
        );

        final title = textOf(tester, 'Groceries');
        expect(title.style?.fontSize, 16);
        expect(title.style?.fontWeight, FontWeight.w700);
      });

      testWidgets('secondary keeps the default padding', (tester) async {
        await pumpListRow(tester, const RGListRow(title: 'Groceries'));
        final standard = tester.getSize(find.byType(RGListRow)).height;

        await pumpListRow(
          tester,
          const RGListRow.secondary(title: 'Groceries'),
        );
        final secondary = tester.getSize(find.byType(RGListRow)).height;

        // Only the title's line box differs; 18/22 against 16/24 is 2px.
        expect(standard - secondary, 22 - 24);
      });
    });

    group('slots', () {
      testWidgets('inks the subtitle with the muted color', (tester) async {
        await pumpListRow(
          tester,
          const RGListRow(title: 'Groceries', subtitle: 'Due today'),
        );

        final subtitle = textOf(tester, 'Due today');
        expect(
          subtitle.style?.color,
          RGTheme.light.colorScheme.onSurfaceVariant,
        );
        expect(subtitle.style?.fontSize, 10);
      });

      testWidgets('inks the caption with the muted color', (tester) async {
        await pumpListRow(
          tester,
          const RGListRow(title: 'Groceries', caption: 'Updated 2h ago'),
        );

        final caption = textOf(tester, 'Updated 2h ago');
        expect(
          caption.style?.color,
          RGTheme.light.colorScheme.onSurfaceVariant,
        );
        expect(caption.style?.fontSize, 7);
      });

      testWidgets('follows the dark theme muted ink', (tester) async {
        await pumpListRow(
          tester,
          const RGListRow(title: 'Groceries', subtitle: 'Due today'),
          theme: RGTheme.dark,
        );

        expect(
          textOf(tester, 'Due today').style?.color,
          RGTheme.dark.colorScheme.onSurfaceVariant,
        );
      });

      testWidgets('stacks the overline above the title', (tester) async {
        await pumpListRow(
          tester,
          RGListRow(
            title: 'Groceries',
            overline: RGText.overline('MY LOCATION'),
          ),
        );

        final overlineY = tester.getCenter(find.text('MY LOCATION')).dy;
        expect(
          overlineY,
          lessThan(tester.getCenter(find.text('Groceries')).dy),
        );
      });

      testWidgets('pins the trailing slot to the end', (tester) async {
        await pumpListRow(
          tester,
          const RGListRow(
            title: 'Groceries',
            trailing: Icon(Icons.chevron_right),
          ),
        );

        final titleX = tester.getCenter(find.text('Groceries')).dx;
        expect(
          tester.getCenter(find.byIcon(Icons.chevron_right)).dx,
          greaterThan(titleX),
        );
      });
    });

    group('rule', () {
      testWidgets('paints a 1px hairline along the bottom', (tester) async {
        await pumpListRow(tester, const RGListRow(title: 'Groceries'));

        final rule = ruleOf(tester);
        expect(rule.color, RGTheme.light.colorScheme.outlineVariant);
        expect(rule.width, 1);
      });

      testWidgets('leaves the other three sides bare', (tester) async {
        await pumpListRow(tester, const RGListRow(title: 'Groceries'));

        final border = decorationOf(tester).border! as Border;
        expect(border.top, BorderSide.none);
        expect(border.left, BorderSide.none);
        expect(border.right, BorderSide.none);
      });

      testWidgets('follows the dark theme hairline', (tester) async {
        await pumpListRow(
          tester,
          const RGListRow(title: 'Groceries'),
          theme: RGTheme.dark,
        );

        expect(ruleOf(tester).color, RGTheme.dark.colorScheme.outlineVariant);
      });
    });

    group('interaction', () {
      testWidgets('fires onTap', (tester) async {
        var taps = 0;
        await pumpListRow(
          tester,
          RGListRow(title: 'Groceries', onTap: () => taps++),
        );

        await tester.tap(find.byType(RGListRow));
        expect(taps, 1);
      });

      testWidgets('takes ink once tappable', (tester) async {
        await pumpListRow(
          tester,
          RGListRow(title: 'Groceries', onTap: () {}),
        );

        expect(find.byType(InkWell), findsOneWidget);
      });

      testWidgets('stays inert without onTap', (tester) async {
        await pumpListRow(tester, const RGListRow(title: 'Groceries'));

        expect(find.byType(InkWell), findsNothing);
      });
    });

    group('layout', () {
      testWidgets('lays out inside an unbounded list', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: RGTheme.light,
            home: Scaffold(
              body: ListView(
                children: const [
                  RGListRow(title: 'Groceries', subtitle: 'Due today'),
                  RGListRow(title: 'Laundry'),
                ],
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.byType(RGListRow), findsNWidgets(2));
      });
    });
  });
}
