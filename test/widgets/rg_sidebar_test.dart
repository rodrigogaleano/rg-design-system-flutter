import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rg_design_system/rg_design_system.dart';

void main() {
  // Pumps [child] with a bounded height; the sidebar sizes to its parent.
  Future<void> pumpSidebar(
    WidgetTester tester,
    Widget child, {
    ThemeData? theme,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: theme ?? RGTheme.light,
        home: Scaffold(
          body: Row(children: [SizedBox(height: 600, child: child)]),
        ),
      ),
    );
  }

  // A sidebar with [active] selected out of three destinations.
  RGSidebar sidebar({
    int active = 0,
    Widget? footer,
    double? width,
    void Function(String label)? onTap,
    String thirdLabel = 'Archive',
  }) {
    final labels = ['Tasks', 'Settings', thirdLabel];

    return RGSidebar(
      header: RGText.h3('Todo'),
      items: [
        for (final (index, label) in labels.indexed)
          RGNavItem(
            label: label,
            active: index == active,
            onTap: () => onTap?.call(label),
          ),
      ],
      footer: footer,
      width: width ?? 240,
    );
  }

  // The decoration of the sidebar's backing box.
  BoxDecoration decorationOf(WidgetTester tester) {
    final box = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(RGSidebar),
        matching: find.byType(DecoratedBox),
      ),
    );
    return box.decoration as BoxDecoration;
  }

  // The marker square painted beside [label].
  Container markerOf(WidgetTester tester, String label) => tester.widget(
    find.descendant(
      of: find.ancestor(of: find.text(label), matching: find.byType(RGNavItem)),
      matching: find.byType(Container),
    ),
  );

  group('RGSidebar', () {
    group('composition', () {
      testWidgets('renders the header, the items and the footer', (
        tester,
      ) async {
        await pumpSidebar(tester, sidebar(footer: RGText.caption('v1.0.0')));

        expect(find.text('Todo'), findsOneWidget);
        expect(find.byType(RGNavItem), findsNWidgets(3));
        expect(find.text('v1.0.0'), findsOneWidget);
      });

      testWidgets('works without a footer', (tester) async {
        await pumpSidebar(tester, sidebar());

        expect(find.byType(RGNavItem), findsNWidgets(3));
        expect(tester.takeException(), isNull);
      });

      testWidgets('keeps the items at the top without a footer', (
        tester,
      ) async {
        await pumpSidebar(tester, sidebar());

        // 600 tall parent; the spacer takes the slack below the last item.
        final lastItemBottom = tester
            .getBottomLeft(find.byType(RGNavItem).last)
            .dy;
        expect(lastItemBottom, lessThan(300));
      });

      testWidgets('respects the given width', (tester) async {
        await pumpSidebar(tester, sidebar(width: 320));

        expect(tester.getSize(find.byType(RGSidebar)).width, 320);
      });

      testWidgets('defaults to 240 wide', (tester) async {
        await pumpSidebar(
          tester,
          RGSidebar(
            header: RGText.h3('Todo'),
            items: [RGNavItem(label: 'Tasks', active: true, onTap: () {})],
          ),
        );

        expect(tester.getSize(find.byType(RGSidebar)).width, 240);
      });
    });

    group('edge', () {
      testWidgets('draws a 1px hairline down the right', (tester) async {
        await pumpSidebar(tester, sidebar());

        final border = decorationOf(tester).border! as Border;
        expect(border.right.color, RGTheme.light.colorScheme.outlineVariant);
        expect(border.right.width, 1);
        expect(border.left, BorderSide.none);
        expect(border.top, BorderSide.none);
        expect(border.bottom, BorderSide.none);
      });

      testWidgets('follows the dark theme hairline', (tester) async {
        await pumpSidebar(tester, sidebar(), theme: RGTheme.dark);

        final border = decorationOf(tester).border! as Border;
        expect(border.right.color, RGTheme.dark.colorScheme.outlineVariant);
      });
    });
  });

  group('RGNavItem', () {
    group('active', () {
      testWidgets('bolds the label', (tester) async {
        await pumpSidebar(tester, sidebar());

        expect(
          tester.widget<Text>(find.text('Tasks')).style?.fontWeight,
          FontWeight.w700,
        );
      });

      testWidgets('leaves the label on the strong ink', (tester) async {
        await pumpSidebar(tester, sidebar());

        expect(
          tester.widget<Text>(find.text('Tasks')).style?.color,
          RGTheme.light.colorScheme.onSurface,
        );
      });

      testWidgets('fills the marker', (tester) async {
        await pumpSidebar(tester, sidebar());

        expect(
          markerOf(tester, 'Tasks').color,
          RGTheme.light.colorScheme.onSurface,
        );
      });
    });

    group('inactive', () {
      testWidgets('mutes the label', (tester) async {
        await pumpSidebar(tester, sidebar());

        final label = tester.widget<Text>(find.text('Settings'));
        expect(label.style?.color, RGTheme.light.colorScheme.onSurfaceVariant);
        expect(label.style?.fontWeight, isNot(FontWeight.w700));
      });

      testWidgets('clears the marker without losing its space', (tester) async {
        await pumpSidebar(tester, sidebar());

        expect(markerOf(tester, 'Settings').color, Colors.transparent);
        expect(
          tester.getSize(find.byWidget(markerOf(tester, 'Settings'))),
          tester.getSize(find.byWidget(markerOf(tester, 'Tasks'))),
        );
      });
    });

    group('overflow', () {
      testWidgets('truncates a label too long for the width', (tester) async {
        await pumpSidebar(
          tester,
          sidebar(thirdLabel: 'Archived and completed tasks'),
        );

        expect(tester.takeException(), isNull);
        final label = tester.widget<Text>(
          find.text('Archived and completed tasks'),
        );
        expect(label.overflow, TextOverflow.ellipsis);
      });
    });

    group('interaction', () {
      testWidgets('fires onTap for the item that was tapped', (tester) async {
        final tapped = <String>[];
        await pumpSidebar(tester, sidebar(onTap: tapped.add));

        await tester.tap(find.text('Settings'));
        expect(tapped, ['Settings']);

        await tester.tap(find.text('Archive'));
        expect(tapped, ['Settings', 'Archive']);
      });
    });

    group('accessibility', () {
      testWidgets('exposes the active item as a selected button', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();
        await pumpSidebar(tester, sidebar());

        expect(
          tester.getSemantics(find.byType(RGNavItem).first),
          isSemantics(label: 'Tasks', isButton: true, isSelected: true),
        );
        handle.dispose();
      });

      testWidgets('leaves an inactive item unselected', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpSidebar(tester, sidebar());

        expect(
          tester.getSemantics(find.byType(RGNavItem).at(1)),
          isSemantics(label: 'Settings', isButton: true, isSelected: false),
        );
        handle.dispose();
      });
    });
  });
}
