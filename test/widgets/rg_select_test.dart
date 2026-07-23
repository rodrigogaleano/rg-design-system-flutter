import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rg_design_system/rg_design_system.dart';

const _options = <RGSelectOption<String>>[
  RGSelectOption(value: 'en', label: 'English'),
  RGSelectOption(value: 'pt', label: 'Portugues'),
  RGSelectOption(value: 'es', label: 'Espanol'),
];

void main() {
  // Pumps [child] inside a themed scaffold.
  Future<void> pumpSelect(
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

  // Opens the panel by tapping the trigger and settling the open animation.
  Future<void> open(WidgetTester tester) async {
    await tester.tap(find.byType(RGSelect<String>));
    await tester.pumpAndSettle();
  }

  group('RGSelect', () {
    group('open state', () {
      testWidgets('keeps the panel closed until tapped', (tester) async {
        await pumpSelect(
          tester,
          RGSelect<String>(value: 'en', options: _options, onChanged: (_) {}),
        );
        // The English label shows once in the trigger, not in a panel row.
        expect(find.text('English'), findsOneWidget);
        expect(find.text('Portugues'), findsNothing);
      });

      testWidgets('tapping the trigger reveals the options', (tester) async {
        await pumpSelect(
          tester,
          RGSelect<String>(value: 'en', options: _options, onChanged: (_) {}),
        );
        await open(tester);
        expect(find.text('Portugues'), findsOneWidget);
        expect(find.text('Espanol'), findsOneWidget);
      });
    });

    group('selection', () {
      testWidgets('picking an option reports its value', (tester) async {
        String? captured;
        await pumpSelect(
          tester,
          RGSelect<String>(
            value: 'en',
            options: _options,
            onChanged: (value) => captured = value,
          ),
        );
        await open(tester);
        await tester.tap(find.text('Portugues'));
        await tester.pumpAndSettle();
        expect(captured, 'pt');
      });

      testWidgets('picking an option closes the panel', (tester) async {
        await pumpSelect(
          tester,
          RGSelect<String>(value: 'en', options: _options, onChanged: (_) {}),
        );
        await open(tester);
        await tester.tap(find.text('Espanol'));
        await tester.pumpAndSettle();
        expect(find.text('Espanol'), findsNothing);
      });

      testWidgets('the selected option shows a check, others do not', (
        tester,
      ) async {
        await pumpSelect(
          tester,
          RGSelect<String>(value: 'pt', options: _options, onChanged: (_) {}),
        );
        await open(tester);
        expect(find.byIcon(Icons.check), findsOneWidget);
      });
    });

    group('value', () {
      testWidgets('shows the selected option label', (tester) async {
        await pumpSelect(
          tester,
          RGSelect<String>(value: 'pt', options: _options, onChanged: (_) {}),
        );
        expect(find.text('Portugues'), findsOneWidget);
      });

      testWidgets('shows the hint while nothing is selected', (tester) async {
        await pumpSelect(
          tester,
          RGSelect<String>(
            value: null,
            hint: 'Choose a language',
            options: _options,
            onChanged: (_) {},
          ),
        );
        expect(find.text('Choose a language'), findsOneWidget);
      });
    });

    group('disabled', () {
      testWidgets('null onChanged blocks opening', (tester) async {
        await pumpSelect(
          tester,
          const RGSelect<String>(
            value: 'en',
            options: _options,
            onChanged: null,
          ),
        );
        await tester.tap(find.byType(RGSelect<String>));
        await tester.pumpAndSettle();
        expect(find.text('Portugues'), findsNothing);
      });
    });

    group('label', () {
      testWidgets('renders the copy above the trigger', (tester) async {
        await pumpSelect(
          tester,
          RGSelect<String>(
            value: 'en',
            label: 'Language',
            options: _options,
            onChanged: (_) {},
          ),
        );
        expect(find.text('Language'), findsOneWidget);
        final labelY = tester.getCenter(find.text('Language')).dy;
        final triggerY = tester.getCenter(find.text('English')).dy;
        expect(labelY, lessThan(triggerY));
      });
    });

    group('accessibility', () {
      testWidgets('collapses the trigger into a single node', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpSelect(
          tester,
          RGSelect<String>(value: 'en', options: _options, onChanged: (_) {}),
        );
        expect(find.byType(MergeSemantics), findsOneWidget);
        handle.dispose();
      });
    });
  });
}
