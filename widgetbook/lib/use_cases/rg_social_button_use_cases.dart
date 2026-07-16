import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// One use case per provider. Knobs cover the label and the disabled state.

// MARK: - Shared knobs

VoidCallback? _onPressed(BuildContext context) =>
    context.knobs.boolean(label: 'Enabled', initialValue: true) ? () {} : null;

String _label(BuildContext context, String initial) =>
    context.knobs.string(label: 'Text', initialValue: initial);

// MARK: - Google

@widgetbook.UseCase(name: 'Google', type: RGSocialButton, path: 'Actions')
Widget buildRGSocialButtonGoogle(BuildContext context) => RGSocialButton.google(
  label: _label(context, 'Continuar com Google'),
  onPressed: _onPressed(context),
);

// MARK: - Apple

@widgetbook.UseCase(name: 'Apple', type: RGSocialButton, path: 'Actions')
Widget buildRGSocialButtonApple(BuildContext context) => RGSocialButton.apple(
  label: _label(context, 'Continuar com Apple'),
  onPressed: _onPressed(context),
);
