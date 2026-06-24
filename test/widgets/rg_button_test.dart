import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rg_design_system/rg_design_system.dart';

void main() {
  // Pumps [child] inside a themed scaffold.
  Future<void> pumpButton(
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

  // Resolves the background painted by the underlying Material button.
  Color? backgroundOf(
    WidgetTester tester, {
    Set<WidgetState> states = const {},
  }) {
    final button = tester.widget<TextButton>(find.byType(TextButton));
    return button.style?.backgroundColor?.resolve(states);
  }

  // Resolves the foreground (text/icon) color.
  Color? foregroundOf(
    WidgetTester tester, {
    Set<WidgetState> states = const {},
  }) {
    final button = tester.widget<TextButton>(find.byType(TextButton));
    return button.style?.foregroundColor?.resolve(states);
  }

  group('RGButton', () {
    group('variant colors (light)', () {
      testWidgets('filled uses primary on onPrimary', (tester) async {
        await pumpButton(
          tester,
          RGButton.filled('x', onPressed: () {}),
        );
        expect(backgroundOf(tester), RGColors.black);
        expect(foregroundOf(tester), RGColors.white);
      });

      testWidgets('tonal uses the secondary container', (tester) async {
        await pumpButton(tester, RGButton.tonal('x', onPressed: () {}));
        final scheme = RGTheme.light.colorScheme;
        expect(backgroundOf(tester), scheme.secondaryContainer);
        expect(foregroundOf(tester), scheme.onSecondaryContainer);
      });

      testWidgets('outline has no fill and a border', (tester) async {
        await pumpButton(tester, RGButton.outline('x', onPressed: () {}));
        expect(backgroundOf(tester), isNull);
        final button = tester.widget<TextButton>(find.byType(TextButton));
        final side = button.style?.side?.resolve(<WidgetState>{});
        expect(side?.color, RGTheme.light.colorScheme.outline);
        expect(foregroundOf(tester), RGColors.black);
      });

      testWidgets('text has no fill and no border', (tester) async {
        await pumpButton(tester, RGButton.text('x', onPressed: () {}));
        expect(backgroundOf(tester), isNull);
        final button = tester.widget<TextButton>(find.byType(TextButton));
        final side = button.style?.side?.resolve(<WidgetState>{});
        expect(side, BorderSide.none);
        expect(foregroundOf(tester), RGColors.black);
      });
    });

    group('dark mode', () {
      testWidgets('filled inverts to white on black', (tester) async {
        await pumpButton(
          tester,
          RGButton.filled('x', onPressed: () {}),
          theme: RGTheme.dark,
        );
        expect(backgroundOf(tester), RGColors.white);
        expect(foregroundOf(tester), RGColors.black);
      });
    });

    group('destructive', () {
      testWidgets('filled uses the error token', (tester) async {
        await pumpButton(
          tester,
          RGButton.filled('x', onPressed: () {}, isDestructive: true),
        );
        final scheme = RGTheme.light.colorScheme;
        expect(backgroundOf(tester), scheme.error);
        expect(foregroundOf(tester), scheme.onError);
      });

      testWidgets('outline tints the border and ink', (tester) async {
        await pumpButton(
          tester,
          RGButton.outline('x', onPressed: () {}, isDestructive: true),
        );
        final button = tester.widget<TextButton>(find.byType(TextButton));
        final side = button.style?.side?.resolve(<WidgetState>{});
        expect(side?.color, RGColors.error);
        expect(foregroundOf(tester), RGColors.error);
      });

      testWidgets('is ignored when disabled', (tester) async {
        await pumpButton(
          tester,
          const RGButton.filled('x', onPressed: null, isDestructive: true),
        );
        final scheme = RGTheme.light.colorScheme;
        const disabled = {WidgetState.disabled};
        expect(
          backgroundOf(tester, states: disabled),
          isNot(scheme.error),
        );
        expect(
          foregroundOf(tester, states: disabled),
          scheme.onSurface.withValues(alpha: 0.38),
        );
      });
    });

    group('sizes', () {
      <RGButtonSize, double>{
        RGButtonSize.small: 36,
        RGButtonSize.medium: 44,
        RGButtonSize.large: 52,
      }.forEach((size, height) {
        testWidgets('$size sets height $height', (tester) async {
          await pumpButton(
            tester,
            RGButton.filled('x', onPressed: () {}, size: size),
          );
          final button = tester.widget<TextButton>(find.byType(TextButton));
          final min = button.style?.minimumSize?.resolve(<WidgetState>{});
          expect(min?.height, height);
        });
      });
    });

    group('interaction', () {
      testWidgets('fires onPressed when tapped', (tester) async {
        var taps = 0;
        await pumpButton(
          tester,
          RGButton.filled('Tap', onPressed: () => taps++),
        );
        await tester.tap(find.byType(RGButton));
        expect(taps, 1);
      });

      testWidgets('is disabled when onPressed is null', (tester) async {
        await pumpButton(tester, const RGButton.filled('x', onPressed: null));
        final button = tester.widget<TextButton>(find.byType(TextButton));
        expect(button.onPressed, isNull);
      });
    });

    group('loading', () {
      testWidgets('shows a spinner', (tester) async {
        await pumpButton(
          tester,
          RGButton.filled('Save', onPressed: () {}, isLoading: true),
        );
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('never fires onPressed, including via keyboard', (
        tester,
      ) async {
        var taps = 0;
        await pumpButton(
          tester,
          RGButton.filled('Save', onPressed: () => taps++, isLoading: true),
        );

        // Pointer route.
        await tester.tap(find.byType(RGButton), warnIfMissed: false);

        // Keyboard/assistive route both reach the button callback; loading
        // swaps it for a no-op, so invoking it must not increment.
        final button = tester.widget<TextButton>(find.byType(TextButton));
        button.onPressed?.call();

        expect(taps, 0);
      });
    });

    group('accessibility', () {
      testWidgets('exposes button role, enabled state, and a tap action', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();
        await pumpButton(
          tester,
          RGButton.filled('Go', onPressed: () {}),
        );

        expect(
          tester.getSemantics(find.byType(RGButton)),
          isSemantics(
            isButton: true,
            isEnabled: true,
            hasEnabledState: true,
            hasTapAction: true,
          ),
        );

        handle.dispose();
      });

      testWidgets('icon-only borrows the tooltip as its label', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpButton(
          tester,
          RGButton.icon(
            icon: Icons.delete,
            tooltip: 'Delete',
            onPressed: () {},
          ),
        );

        final node = tester.getSemantics(find.byType(RGButton));
        expect(node.label, contains('Delete'));

        handle.dispose();
      });
    });

    group('icons', () {
      testWidgets('renders leading and trailing icons', (tester) async {
        await pumpButton(
          tester,
          RGButton.filled(
            'x',
            onPressed: () {},
            leadingIcon: Icons.add,
            trailingIcon: Icons.arrow_forward,
          ),
        );
        expect(find.byIcon(Icons.add), findsOneWidget);
        expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      });

      testWidgets('icon-only renders the glyph and exposes a tooltip', (
        tester,
      ) async {
        await pumpButton(
          tester,
          RGButton.icon(
            icon: Icons.delete,
            tooltip: 'Delete',
            onPressed: () {},
          ),
        );
        expect(find.byIcon(Icons.delete), findsOneWidget);
        expect(find.byType(Tooltip), findsOneWidget);
        final tooltip = tester.widget<Tooltip>(find.byType(Tooltip));
        expect(tooltip.message, 'Delete');
      });
    });

    group('full width', () {
      testWidgets('expands to the available width', (tester) async {
        await pumpButton(
          tester,
          RGButton.filled('x', onPressed: () {}, fullWidth: true),
        );
        final box = tester.getSize(find.byType(TextButton));
        final screen = tester.getSize(find.byType(Scaffold));
        expect(box.width, screen.width);
      });
    });
  });
}
