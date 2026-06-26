import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rg_design_system/rg_design_system.dart';

void main() {
  // Pumps [child] inside a themed scaffold.
  Future<void> pumpField(
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

  // The effective decoration handed to the underlying Material TextField.
  InputDecoration decorationOf(WidgetTester tester) {
    final field = tester.widget<TextField>(find.byType(TextField));
    return field.decoration!;
  }

  // The resolved border side color for a given InputBorder.
  Color colorOf(InputBorder? border) => border!.borderSide.color;

  group('RGTextField', () {
    group('content', () {
      testWidgets('renders label, hint, and helper', (tester) async {
        await pumpField(
          tester,
          const RGTextField.outlined(
            label: 'Email',
            hint: 'you@example.com',
            helperText: 'We never share it',
          ),
        );
        expect(find.text('Email'), findsOneWidget);
        expect(find.text('you@example.com'), findsOneWidget);
        expect(find.text('We never share it'), findsOneWidget);
      });
    });

    group('variants', () {
      testWidgets('outlined inherits the themed outline border', (
        tester,
      ) async {
        await pumpField(tester, const RGTextField.outlined());
        final decoration = decorationOf(tester);
        expect(decoration.filled, isFalse);
        expect(decoration.enabledBorder, isA<OutlineInputBorder>());
        expect(
          colorOf(decoration.enabledBorder),
          RGTheme.light.colorScheme.outline,
        );
      });

      testWidgets('filled layers its own fill and underline', (tester) async {
        await pumpField(tester, const RGTextField.filled());
        final decoration = decorationOf(tester);
        expect(decoration.filled, isTrue);
        expect(
          decoration.fillColor,
          RGTheme.light.colorScheme.surfaceContainerLow,
        );
        expect(decoration.enabledBorder, isA<UnderlineInputBorder>());
        expect(
          colorOf(decoration.enabledBorder),
          RGTheme.light.colorScheme.outline,
        );
      });
    });

    group('errors', () {
      testWidgets('errorText renders its message', (tester) async {
        await pumpField(
          tester,
          const RGTextField.outlined(errorText: 'Required'),
        );
        expect(find.text('Required'), findsOneWidget);
      });
    });

    group('dark mode', () {
      testWidgets('inverts the input ink', (tester) async {
        await pumpField(
          tester,
          const RGTextField.outlined(),
          theme: RGTheme.dark,
        );
        final field = tester.widget<TextField>(find.byType(TextField));
        expect(field.style?.color, RGColors.white);
      });
    });

    group('form integration', () {
      testWidgets('validator failure shows the message and fails validate', (
        tester,
      ) async {
        final formKey = GlobalKey<FormState>();
        await pumpField(
          tester,
          Form(
            key: formKey,
            child: RGTextField.outlined(
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Required' : null,
            ),
          ),
        );

        expect(formKey.currentState!.validate(), isFalse);
        await tester.pump();
        expect(find.text('Required'), findsOneWidget);
      });
    });

    group('interaction', () {
      testWidgets('onChanged fires with the typed value', (tester) async {
        String? captured;
        await pumpField(
          tester,
          RGTextField.outlined(onChanged: (value) => captured = value),
        );
        await tester.enterText(find.byType(TextField), 'hello');
        expect(captured, 'hello');
      });

      testWidgets('obscureText masks the input', (tester) async {
        await pumpField(
          tester,
          const RGTextField.outlined(obscureText: true),
        );
        final field = tester.widget<TextField>(find.byType(TextField));
        expect(field.obscureText, isTrue);
      });

      testWidgets('disabled blocks editing', (tester) async {
        await pumpField(
          tester,
          const RGTextField.outlined(enabled: false),
        );
        final field = tester.widget<TextField>(find.byType(TextField));
        expect(field.enabled, isFalse);
      });

      testWidgets('suffix tap fires and exposes its tooltip', (tester) async {
        var taps = 0;
        await pumpField(
          tester,
          RGTextField.outlined(
            suffixIcon: Icons.close,
            suffixTooltip: 'Clear',
            onSuffixTap: () => taps++,
          ),
        );
        await tester.tap(find.byIcon(Icons.close));
        expect(taps, 1);
        final button = tester.widget<IconButton>(find.byType(IconButton));
        expect(button.tooltip, 'Clear');
      });
    });

    group('accessibility', () {
      testWidgets('exposes a text field semantics node', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpField(tester, const RGTextField.outlined(label: 'Name'));
        expect(
          tester.getSemantics(find.byType(TextField)),
          isSemantics(
            isTextField: true,
            isEnabled: true,
            label: 'Name',
          ),
        );
        handle.dispose();
      });
    });
  });
}
