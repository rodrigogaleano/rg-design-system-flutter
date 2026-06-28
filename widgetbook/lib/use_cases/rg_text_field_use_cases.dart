import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// One use case per variant. Knobs cover the label/hint/helper copy, the error
// state, prefix/suffix icons, obscure, multiline, and the disabled state so each
// variant can be exercised end to end from the toolbar.

// MARK: - Shared knobs

String? _label(BuildContext context) =>
    context.knobs.stringOrNull(label: 'Label', initialValue: 'Email');

String? _hint(BuildContext context) =>
    context.knobs.stringOrNull(label: 'Hint', initialValue: 'you@example.com');

String? _helper(BuildContext context) => context.knobs.stringOrNull(
  label: 'Helper',
  initialValue: 'We never share it',
);

String? _error(BuildContext context) =>
    context.knobs.stringOrNull(label: 'Error text');

bool _obscure(BuildContext context) => context.knobs.boolean(label: 'Obscure');

bool _multiline(BuildContext context) =>
    context.knobs.boolean(label: 'Multiline');

bool _enabled(BuildContext context) =>
    context.knobs.boolean(label: 'Enabled', initialValue: true);

IconData? _prefix(BuildContext context) =>
    context.knobs.boolean(label: 'Prefix icon') ? Icons.mail_outline : null;

IconData? _suffix(BuildContext context) =>
    context.knobs.boolean(label: 'Suffix icon') ? Icons.close : null;

// MARK: - Outlined

@widgetbook.UseCase(name: 'Outlined', type: RGTextField)
Widget buildRGTextFieldOutlined(BuildContext context) {
  final multiline = _multiline(context);
  final suffix = _suffix(context);
  return Padding(
    padding: const EdgeInsets.all(16),
    child: RGTextField.outlined(
      label: _label(context),
      hint: _hint(context),
      helperText: _helper(context),
      errorText: _error(context),
      obscureText: _obscure(context),
      maxLines: multiline ? 4 : 1,
      minLines: multiline ? 4 : null,
      enabled: _enabled(context),
      prefixIcon: _prefix(context),
      suffixIcon: suffix,
      onSuffixTap: suffix == null ? null : () {},
      suffixTooltip: suffix == null ? null : 'Clear',
    ),
  );
}

// MARK: - Filled

@widgetbook.UseCase(name: 'Filled', type: RGTextField)
Widget buildRGTextFieldFilled(BuildContext context) {
  final multiline = _multiline(context);
  final suffix = _suffix(context);
  return Padding(
    padding: const EdgeInsets.all(16),
    child: RGTextField.filled(
      label: _label(context),
      hint: _hint(context),
      helperText: _helper(context),
      errorText: _error(context),
      obscureText: _obscure(context),
      maxLines: multiline ? 4 : 1,
      minLines: multiline ? 4 : null,
      enabled: _enabled(context),
      prefixIcon: _prefix(context),
      suffixIcon: suffix,
      onSuffixTap: suffix == null ? null : () {},
      suffixTooltip: suffix == null ? null : 'Clear',
    ),
  );
}
