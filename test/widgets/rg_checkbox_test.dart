import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rg_design_system/rg_design_system.dart';

void main() {
  // Pumps [child] inside a themed scaffold.
  Future<void> pumpCheckbox(
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

  // The underlying Material checkbox.
  Checkbox checkboxOf(WidgetTester tester) =>
      tester.widget<Checkbox>(find.byType(Checkbox));

  // The border the rendered checkbox resolves for [states].
  BorderSide? sideOf(WidgetTester tester, Set<WidgetState> states) =>
      (checkboxOf(tester).side! as WidgetStateBorderSide).resolve(states);

  group('RGCheckbox', () {
    group('value', () {
      testWidgets('reflects the checked state', (tester) async {
        await pumpCheckbox(tester, RGCheckbox(value: true, onChanged: (_) {}));
        expect(checkboxOf(tester).value, isTrue);
      });

      testWidgets('reflects the unchecked state', (tester) async {
        await pumpCheckbox(tester, RGCheckbox(value: false, onChanged: (_) {}));
        expect(checkboxOf(tester).value, isFalse);
      });
    });

    group('interaction', () {
      testWidgets('tapping the control toggles', (tester) async {
        bool? captured;
        await pumpCheckbox(
          tester,
          RGCheckbox(value: false, onChanged: (value) => captured = value),
        );
        await tester.tap(find.byType(Checkbox));
        expect(captured, isTrue);
      });

      testWidgets('tapping the label row toggles', (tester) async {
        bool? captured;
        await pumpCheckbox(
          tester,
          RGCheckbox(
            value: true,
            label: 'Accept terms',
            onChanged: (value) => captured = value,
          ),
        );
        await tester.tap(find.text('Accept terms'));
        expect(captured, isFalse);
      });

      testWidgets('null onChanged disables the control', (tester) async {
        await pumpCheckbox(
          tester,
          const RGCheckbox(value: false, onChanged: null),
        );
        expect(checkboxOf(tester).onChanged, isNull);
      });

      testWidgets('enabled false disables the control', (tester) async {
        await pumpCheckbox(
          tester,
          RGCheckbox(value: false, enabled: false, onChanged: (_) {}),
        );
        expect(checkboxOf(tester).onChanged, isNull);
      });
    });

    group('label', () {
      testWidgets('renders the copy', (tester) async {
        await pumpCheckbox(
          tester,
          RGCheckbox(value: false, label: 'Remember me', onChanged: (_) {}),
        );
        expect(find.text('Remember me'), findsOneWidget);
      });

      testWidgets('end keeps the label right of the control', (tester) async {
        await pumpCheckbox(
          tester,
          RGCheckbox(value: false, label: 'Terms', onChanged: (_) {}),
        );
        final labelX = tester.getCenter(find.text('Terms')).dx;
        final controlX = tester.getCenter(find.byType(Checkbox)).dx;
        expect(labelX, greaterThan(controlX));
      });

      testWidgets('start puts the label left of the control', (tester) async {
        await pumpCheckbox(
          tester,
          RGCheckbox(
            value: false,
            label: 'Terms',
            labelPosition: RGCheckboxLabelPosition.start,
            onChanged: (_) {},
          ),
        );
        final labelX = tester.getCenter(find.text('Terms')).dx;
        final controlX = tester.getCenter(find.byType(Checkbox)).dx;
        expect(labelX, lessThan(controlX));
      });

      testWidgets('disabled dims the label ink', (tester) async {
        await pumpCheckbox(
          tester,
          RGCheckbox(
            value: false,
            label: 'Terms',
            enabled: false,
            onChanged: (_) {},
          ),
        );
        final text = tester.widget<Text>(find.text('Terms'));
        expect(
          text.style?.color,
          RGTheme.light.colorScheme.onSurface.withValues(alpha: 0.38),
        );
      });
    });

    group('border', () {
      testWidgets('unchecked paints a hairline outline', (tester) async {
        await pumpCheckbox(tester, RGCheckbox(value: false, onChanged: (_) {}));
        expect(sideOf(tester, {})?.color, RGTheme.light.colorScheme.outline);
      });

      testWidgets('checked matches the fill so no outline rings it', (
        tester,
      ) async {
        await pumpCheckbox(tester, RGCheckbox(value: true, onChanged: (_) {}));
        expect(
          sideOf(tester, {WidgetState.selected})?.color,
          RGTheme.light.colorScheme.primary,
        );
      });

      testWidgets('disabled dims the border without thinning it', (
        tester,
      ) async {
        await pumpCheckbox(
          tester,
          RGCheckbox(value: false, enabled: false, onChanged: (_) {}),
        );
        final side = sideOf(tester, {WidgetState.disabled});
        expect(
          side?.color,
          RGTheme.light.colorScheme.onSurface.withValues(alpha: 0.38),
        );
        expect(side?.width, 2);
      });
    });

    group('accessibility', () {
      testWidgets('exposes a single checkbox node with the label', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();
        await pumpCheckbox(
          tester,
          RGCheckbox(value: true, label: 'Terms', onChanged: (_) {}),
        );
        expect(
          tester.getSemantics(find.byType(RGCheckbox)),
          isSemantics(
            label: 'Terms',
            isChecked: true,
            hasCheckedState: true,
          ),
        );
        handle.dispose();
      });
    });
  });
}
