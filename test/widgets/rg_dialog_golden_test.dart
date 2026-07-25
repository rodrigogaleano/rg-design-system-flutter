import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';

import '../support/golden_harness.dart';

void _onPressed() {}

void main() {
  goldenTest(
    'rg_dialog',
    // The dialog is rendered inline instead of through [showRGDialog]: the
    // route would mount in the root overlay, outside the captured boundary.
    builder: (context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gallerySection(
          'Confirm',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final entry in <String, RGDialog>{
                'default': const RGDialog.confirm(
                  title: 'Sair da conta',
                  message: 'Voce precisara entrar de novo para continuar.',
                  confirmLabel: 'Sair',
                  cancelLabel: 'Cancelar',
                ),
                'destructive': const RGDialog.confirm(
                  title: 'Excluir conta',
                  message:
                      'Todos os seus dados serao apagados. '
                      'Esta acao nao pode ser desfeita.',
                  confirmLabel: 'Excluir',
                  cancelLabel: 'Cancelar',
                  isDestructive: true,
                ),
              }.entries)
                Padding(
                  padding: const EdgeInsets.only(bottom: RGSpacing.md),
                  child: specimen(entry.key, entry.value),
                ),
            ],
          ),
        ),
        gallerySection(
          'Custom content',
          specimen(
            'password',
            const RGDialog(
              title: 'Confirme sua senha',
              content: RGPasswordField.outlined(label: 'Senha'),
              actions: [
                RGButton.text('Cancelar', onPressed: _onPressed),
                RGButton.filled(
                  'Excluir',
                  onPressed: _onPressed,
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
