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

  // The current obscure flag on the underlying Material TextField.
  bool obscureOf(WidgetTester tester) =>
      tester.widget<TextField>(find.byType(TextField)).obscureText;

  group('RGPasswordField', () {
    group('content', () {
      testWidgets('renders label, hint, and helper', (tester) async {
        await pumpField(
          tester,
          const RGPasswordField.outlined(
            label: 'Password',
            hint: 'Your secret',
            helperText: 'At least 8 characters',
          ),
        );
        expect(find.text('Password'), findsOneWidget);
        expect(find.text('Your secret'), findsOneWidget);
        expect(find.text('At least 8 characters'), findsOneWidget);
      });
    });

    group('visibility toggle', () {
      testWidgets('starts masked with a reveal icon', (tester) async {
        await pumpField(tester, const RGPasswordField.outlined());
        expect(obscureOf(tester), isTrue);
        expect(find.byIcon(Icons.visibility_off), findsOneWidget);

        final button = tester.widget<IconButton>(find.byType(IconButton));
        expect(button.tooltip, 'Show password');
      });

      testWidgets('tap reveals the value and swaps icon and tooltip', (
        tester,
      ) async {
        await pumpField(tester, const RGPasswordField.outlined());

        await tester.tap(find.byIcon(Icons.visibility_off));
        await tester.pump();

        expect(obscureOf(tester), isFalse);
        expect(find.byIcon(Icons.visibility), findsOneWidget);

        final button = tester.widget<IconButton>(find.byType(IconButton));
        expect(button.tooltip, 'Hide password');
      });
    });

    group('variants', () {
      testWidgets('outlined inherits the themed outline border', (
        tester,
      ) async {
        await pumpField(tester, const RGPasswordField.outlined());
        final decoration = decorationOf(tester);
        expect(decoration.filled, isFalse);
        expect(decoration.enabledBorder, isA<OutlineInputBorder>());
        expect(
          colorOf(decoration.enabledBorder),
          RGTheme.light.colorScheme.outline,
        );
      });

      testWidgets('filled layers its own fill and underline', (tester) async {
        await pumpField(tester, const RGPasswordField.filled());
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

    group('form integration', () {
      testWidgets('validator failure shows the message and fails validate', (
        tester,
      ) async {
        final formKey = GlobalKey<FormState>();
        await pumpField(
          tester,
          Form(
            key: formKey,
            child: RGPasswordField.outlined(
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
  });
}
