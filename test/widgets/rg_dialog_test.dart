import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rg_design_system/rg_design_system.dart';

const _openKey = Key('open');

/// The dialog's own surface: the [Material] [Dialog] paints, whose width is
/// what `maxWidth` caps.
final Finder _surface = find
    .descendant(of: find.byType(RGDialog), matching: find.byType(Material))
    .first;

void main() {
  // Pumps a screen whose only control opens [dialog], and hands back the future
  // the route resolves with, so a test can assert on the popped value.
  Future<Future<T?>> openDialog<T>(WidgetTester tester, Widget dialog) async {
    late Future<T?> result;

    await tester.pumpWidget(
      MaterialApp(
        theme: RGTheme.light,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              key: _openKey,
              onPressed: () =>
                  result = showRGDialog<T>(context, dialog: dialog),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(_openKey));
    await tester.pumpAndSettle();

    return result;
  }

  group('RGDialog', () {
    group('slots', () {
      testWidgets('renders the title, the content, and the actions', (
        tester,
      ) async {
        await openDialog<void>(
          tester,
          RGDialog(
            title: 'Confirmar senha',
            content: const RGPasswordField.outlined(label: 'Senha'),
            actions: [
              RGButton.text('Cancelar', onPressed: () {}),
              RGButton.filled('Excluir', onPressed: () {}),
            ],
          ),
        );

        expect(find.text('Confirmar senha'), findsOneWidget);
        expect(find.byType(RGPasswordField), findsOneWidget);
        expect(find.text('Cancelar'), findsOneWidget);
        expect(find.text('Excluir'), findsOneWidget);
      });

      testWidgets('stops growing at 460 by default', (tester) async {
        await openDialog<void>(
          tester,
          const RGDialog(
            title: 'Um titulo longo o bastante para esticar o dialog inteiro',
            content: Text('Corpo'),
            actions: [],
          ),
        );

        expect(tester.getSize(_surface).width, 460);
      });

      testWidgets('honors a custom maxWidth', (tester) async {
        await openDialog<void>(
          tester,
          const RGDialog(
            title: 'Um titulo longo o bastante para esticar o dialog inteiro',
            content: Text('Corpo'),
            actions: [],
            maxWidth: 320,
          ),
        );

        expect(tester.getSize(_surface).width, 320);
      });
    });

    group('confirm', () {
      testWidgets('renders the message and both labels', (tester) async {
        await openDialog<bool>(
          tester,
          const RGDialog.confirm(
            title: 'Excluir conta',
            message: 'Esta acao nao pode ser desfeita.',
            confirmLabel: 'Excluir',
            cancelLabel: 'Cancelar',
          ),
        );

        expect(find.text('Excluir conta'), findsOneWidget);
        expect(find.text('Esta acao nao pode ser desfeita.'), findsOneWidget);
        expect(find.text('Excluir'), findsOneWidget);
        expect(find.text('Cancelar'), findsOneWidget);
      });

      testWidgets('inks the message in onSurfaceVariant', (tester) async {
        await openDialog<bool>(
          tester,
          const RGDialog.confirm(
            title: 'Excluir conta',
            message: 'Esta acao nao pode ser desfeita.',
            confirmLabel: 'Excluir',
            cancelLabel: 'Cancelar',
          ),
        );

        final text = tester.widget<Text>(
          find.text('Esta acao nao pode ser desfeita.'),
        );
        expect(text.style?.color, RGTheme.light.colorScheme.onSurfaceVariant);
      });

      testWidgets('confirming pops true and closes', (tester) async {
        final result = await openDialog<bool>(
          tester,
          const RGDialog.confirm(
            title: 'Excluir conta',
            message: 'Esta acao nao pode ser desfeita.',
            confirmLabel: 'Excluir',
            cancelLabel: 'Cancelar',
          ),
        );

        await tester.tap(find.text('Excluir'));
        await tester.pumpAndSettle();

        expect(await result, isTrue);
        expect(find.byType(RGDialog), findsNothing);
      });

      testWidgets('canceling pops false and closes', (tester) async {
        final result = await openDialog<bool>(
          tester,
          const RGDialog.confirm(
            title: 'Excluir conta',
            message: 'Esta acao nao pode ser desfeita.',
            confirmLabel: 'Excluir',
            cancelLabel: 'Cancelar',
          ),
        );

        await tester.tap(find.text('Cancelar'));
        await tester.pumpAndSettle();

        expect(await result, isFalse);
        expect(find.byType(RGDialog), findsNothing);
      });

      testWidgets('dismissing through the barrier pops null', (tester) async {
        final result = await openDialog<bool>(
          tester,
          const RGDialog.confirm(
            title: 'Excluir conta',
            message: 'Esta acao nao pode ser desfeita.',
            confirmLabel: 'Excluir',
            cancelLabel: 'Cancelar',
          ),
        );

        await tester.tapAt(Offset.zero);
        await tester.pumpAndSettle();

        expect(await result, isNull);
        expect(find.byType(RGDialog), findsNothing);
      });

      testWidgets('passes isDestructive to the confirm button only', (
        tester,
      ) async {
        await openDialog<bool>(
          tester,
          const RGDialog.confirm(
            title: 'Excluir conta',
            message: 'Esta acao nao pode ser desfeita.',
            confirmLabel: 'Excluir',
            cancelLabel: 'Cancelar',
            isDestructive: true,
          ),
        );

        final cancel = tester.widget<RGButton>(
          find.widgetWithText(RGButton, 'Cancelar'),
        );
        final confirm = tester.widget<RGButton>(
          find.widgetWithText(RGButton, 'Excluir'),
        );
        expect(cancel.isDestructive, isFalse);
        expect(confirm.isDestructive, isTrue);
      });
    });

    group('showRGDialog', () {
      testWidgets('mounts the dialog and resolves with the popped value', (
        tester,
      ) async {
        final result = await openDialog<String>(
          tester,
          Builder(
            builder: (context) => RGDialog(
              title: 'Titulo',
              content: const Text('Corpo'),
              actions: [
                RGButton.text(
                  'Ok',
                  onPressed: () => Navigator.of(context).pop('done'),
                ),
              ],
            ),
          ),
        );

        expect(find.byType(RGDialog), findsOneWidget);

        await tester.tap(find.text('Ok'));
        await tester.pumpAndSettle();

        expect(await result, 'done');
        expect(find.byType(RGDialog), findsNothing);
      });
    });
  });
}
