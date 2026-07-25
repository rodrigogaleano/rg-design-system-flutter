import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// The dialog is rendered inline so the catalog shows the shell itself instead
// of a button that opens it. In the app it is opened with `showRGDialog`.

// MARK: - Confirm

@widgetbook.UseCase(name: 'Confirm', type: RGDialog, path: 'Feedback')
Widget buildRGDialogConfirm(BuildContext context) => RGDialog.confirm(
  title: context.knobs.string(label: 'Title', initialValue: 'Excluir conta'),
  message: context.knobs.string(
    label: 'Message',
    initialValue:
        'Todos os seus dados serão apagados. '
        'Esta ação não pode ser desfeita.',
  ),
  confirmLabel: context.knobs.string(
    label: 'Confirm label',
    initialValue: 'Excluir',
  ),
  cancelLabel: context.knobs.string(
    label: 'Cancel label',
    initialValue: 'Cancelar',
  ),
  isDestructive: context.knobs.boolean(
    label: 'Destructive',
    initialValue: true,
  ),
);

// MARK: - Custom content

@widgetbook.UseCase(name: 'Custom content', type: RGDialog, path: 'Feedback')
Widget buildRGDialogCustomContent(BuildContext context) => RGDialog(
  title: context.knobs.string(
    label: 'Title',
    initialValue: 'Confirme sua senha',
  ),
  content: const RGPasswordField.outlined(label: 'Senha'),
  actions: [
    RGButton.text('Cancelar', onPressed: () {}),
    RGButton.filled('Excluir', onPressed: () {}, isDestructive: true),
  ],
);
