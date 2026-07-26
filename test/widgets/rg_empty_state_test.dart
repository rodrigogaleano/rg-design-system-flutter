import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rg_design_system/rg_design_system.dart';

void main() {
  // Pumps [child] inside a themed scaffold.
  Future<void> pumpEmptyState(
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

  // The rendered widget carrying [data].
  Text textOf(WidgetTester tester, String data) =>
      tester.widget<Text>(find.text(data));

  group('RGEmptyState', () {
    group('scale', () {
      testWidgets('sets the headline on h2', (tester) async {
        await pumpEmptyState(
          tester,
          const RGEmptyState(title: 'Nothing found'),
        );

        expect(textOf(tester, 'Nothing found').style?.fontSize, 32);
      });

      testWidgets('sets the message on body', (tester) async {
        await pumpEmptyState(
          tester,
          const RGEmptyState(message: 'Try a different search term.'),
        );

        expect(
          textOf(tester, 'Try a different search term.').style?.fontSize,
          14,
        );
      });

      testWidgets('sets the footnote on caption', (tester) async {
        await pumpEmptyState(
          tester,
          const RGEmptyState(footnote: 'Filters may be narrowing results.'),
        );

        expect(
          textOf(tester, 'Filters may be narrowing results.').style?.fontSize,
          10,
        );
      });
    });

    group('slots', () {
      testWidgets('renders a message on its own', (tester) async {
        await pumpEmptyState(
          tester,
          const RGEmptyState(message: 'Try a different search term.'),
        );

        expect(find.text('Try a different search term.'), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);
      });

      testWidgets('skips the slots left null', (tester) async {
        await pumpEmptyState(
          tester,
          const RGEmptyState(title: 'Nothing found'),
        );

        expect(find.byType(Text), findsOneWidget);
      });

      testWidgets('a null slot leaves no gap behind', (tester) async {
        await pumpEmptyState(
          tester,
          const RGEmptyState(
            title: 'Nothing found',
            footnote: 'Filters may be narrowing results.',
          ),
        );

        // Message and action are null, so the footnote closes straight up
        // against the title with a single md gap, not the skipped ones summed.
        final titleBottom = tester.getBottomLeft(find.text('Nothing found')).dy;
        final footnoteTop = tester
            .getTopLeft(find.text('Filters may be narrowing results.'))
            .dy;
        expect(footnoteTop - titleBottom, RGSpacing.md);
      });

      testWidgets('uppercases the overline', (tester) async {
        await pumpEmptyState(
          tester,
          const RGEmptyState(overline: 'No results', title: 'Nothing found'),
        );

        expect(find.text('NO RESULTS'), findsOneWidget);
        expect(find.text('No results'), findsNothing);
      });

      testWidgets('renders the action widget', (tester) async {
        await pumpEmptyState(
          tester,
          RGEmptyState(
            title: 'Nothing found',
            action: RGButton.filled('Try again', onPressed: () {}),
          ),
        );

        expect(find.text('Try again'), findsOneWidget);
      });
    });

    group('ink', () {
      testWidgets('mutes the overline, message and footnote', (tester) async {
        await pumpEmptyState(
          tester,
          const RGEmptyState(
            overline: 'No results',
            title: 'Nothing found',
            message: 'Try a different search term.',
            footnote: 'Filters may be narrowing results.',
          ),
        );

        final muted = RGTheme.light.colorScheme.onSurfaceVariant;
        expect(textOf(tester, 'NO RESULTS').style?.color, muted);
        expect(
          textOf(tester, 'Try a different search term.').style?.color,
          muted,
        );
        expect(
          textOf(tester, 'Filters may be narrowing results.').style?.color,
          muted,
        );
      });

      testWidgets('leaves the title on the strong ink', (tester) async {
        await pumpEmptyState(
          tester,
          const RGEmptyState(title: 'Nothing found'),
        );

        expect(
          textOf(tester, 'Nothing found').style?.color,
          RGTheme.light.colorScheme.onSurface,
        );
      });

      testWidgets('follows the dark theme muted ink', (tester) async {
        await pumpEmptyState(
          tester,
          const RGEmptyState(
            title: 'Nothing found',
            message: 'Try a different search term.',
          ),
          theme: RGTheme.dark,
        );

        expect(
          textOf(tester, 'Try a different search term.').style?.color,
          RGTheme.dark.colorScheme.onSurfaceVariant,
        );
      });
    });

    group('spacing', () {
      testWidgets('stacks the full composition on the spec gaps', (
        tester,
      ) async {
        await pumpEmptyState(
          tester,
          RGEmptyState(
            overline: 'No results',
            title: 'Nothing found',
            message: 'Try a different search term.',
            action: RGButton.filled('Try again', onPressed: () {}),
            footnote: 'Filters may be narrowing results.',
          ),
        );

        double gapAbove(Finder below, Finder above) =>
            tester.getTopLeft(below).dy - tester.getBottomLeft(above).dy;

        final overline = find.text('NO RESULTS');
        final title = find.text('Nothing found');
        final message = find.text('Try a different search term.');
        final action = find.byType(RGButton);
        final footnote = find.text('Filters may be narrowing results.');

        expect(gapAbove(title, overline), RGSpacing.md);
        expect(gapAbove(message, title), RGSpacing.md);
        expect(gapAbove(action, message), RGSpacing.xl);
        expect(gapAbove(footnote, action), RGSpacing.md);
      });
    });

    group('title', () {
      testWidgets('wraps instead of truncating', (tester) async {
        const long = 'Nothing found here and nothing on the way either';
        await pumpEmptyState(
          tester,
          const SizedBox(width: 300, child: RGEmptyState(title: long)),
        );

        final title = textOf(tester, long);
        expect(title.maxLines, isNull);
        expect(title.overflow, isNull);
        // A single h2 line box is 36; wrapping pushes past it.
        expect(tester.getSize(find.text(long)).height, greaterThan(36));
      });
    });

    group('assert', () {
      testWidgets('rejects an empty state with no copy at all', (tester) async {
        expect(RGEmptyState.new, throwsAssertionError);
      });

      testWidgets('an action alone is not enough', (tester) async {
        expect(
          () => RGEmptyState(
            action: RGButton.filled('Try again', onPressed: () {}),
          ),
          throwsAssertionError,
        );
      });
    });
  });
}
