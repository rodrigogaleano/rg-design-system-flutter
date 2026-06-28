import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rg_design_system/rg_design_system.dart';

void main() {
  // Pumps [child] inside a themed scaffold.
  Future<void> pumpSwitch(
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

  // The underlying Material switch.
  Switch switchOf(WidgetTester tester) =>
      tester.widget<Switch>(find.byType(Switch));

  group('RGSwitch', () {
    group('value', () {
      testWidgets('reflects the on state', (tester) async {
        await pumpSwitch(tester, RGSwitch(value: true, onChanged: (_) {}));
        expect(switchOf(tester).value, isTrue);
      });
    });

    group('interaction', () {
      testWidgets('tapping the control toggles', (tester) async {
        bool? captured;
        await pumpSwitch(
          tester,
          RGSwitch(value: false, onChanged: (value) => captured = value),
        );
        await tester.tap(find.byType(Switch));
        expect(captured, isTrue);
      });

      testWidgets('tapping the label row toggles', (tester) async {
        bool? captured;
        await pumpSwitch(
          tester,
          RGSwitch(
            value: true,
            label: 'Wifi',
            onChanged: (value) => captured = value,
          ),
        );
        await tester.tap(find.text('Wifi'));
        expect(captured, isFalse);
      });

      testWidgets('null onChanged disables the control', (tester) async {
        await pumpSwitch(tester, const RGSwitch(value: false, onChanged: null));
        expect(switchOf(tester).onChanged, isNull);
      });

      testWidgets('enabled false disables the control', (tester) async {
        await pumpSwitch(
          tester,
          RGSwitch(value: false, enabled: false, onChanged: (_) {}),
        );
        expect(switchOf(tester).onChanged, isNull);
      });
    });

    group('label', () {
      testWidgets('renders the copy', (tester) async {
        await pumpSwitch(
          tester,
          RGSwitch(value: false, label: 'Notifications', onChanged: (_) {}),
        );
        expect(find.text('Notifications'), findsOneWidget);
      });

      testWidgets('start keeps the label left of the control', (tester) async {
        await pumpSwitch(
          tester,
          RGSwitch(value: false, label: 'Wifi', onChanged: (_) {}),
        );
        final labelX = tester.getCenter(find.text('Wifi')).dx;
        final controlX = tester.getCenter(find.byType(Switch)).dx;
        expect(labelX, lessThan(controlX));
      });

      testWidgets('end puts the label right of the control', (tester) async {
        await pumpSwitch(
          tester,
          RGSwitch(
            value: false,
            label: 'Wifi',
            labelPosition: RGSwitchLabelPosition.end,
            onChanged: (_) {},
          ),
        );
        final labelX = tester.getCenter(find.text('Wifi')).dx;
        final controlX = tester.getCenter(find.byType(Switch)).dx;
        expect(labelX, greaterThan(controlX));
      });

      testWidgets('disabled dims the label ink', (tester) async {
        await pumpSwitch(
          tester,
          RGSwitch(
            value: false,
            label: 'Wifi',
            enabled: false,
            onChanged: (_) {},
          ),
        );
        final text = tester.widget<Text>(find.text('Wifi'));
        expect(
          text.style?.color,
          RGTheme.light.colorScheme.onSurface.withValues(alpha: 0.38),
        );
      });
    });

    group('accessibility', () {
      testWidgets('exposes a single toggle node with the label', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();
        await pumpSwitch(
          tester,
          RGSwitch(value: true, label: 'Wifi', onChanged: (_) {}),
        );
        expect(
          tester.getSemantics(find.byType(RGSwitch)),
          isSemantics(
            label: 'Wifi',
            isToggled: true,
            hasToggledState: true,
          ),
        );
        handle.dispose();
      });
    });
  });
}
