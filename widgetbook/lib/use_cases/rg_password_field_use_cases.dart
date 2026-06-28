import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// One use case per variant. Knobs cover the label/hint/helper copy, the error
// state, the prefix icon, and the disabled state so each variant can be
// exercised end to end from the toolbar. The reveal toggle is owned by the
// widget, so flip it directly in the preview.

// MARK: - Shared knobs

String? _label(BuildContext context) =>
    context.knobs.stringOrNull(label: 'Label', initialValue: 'Password');

String? _hint(BuildContext context) =>
    context.knobs.stringOrNull(label: 'Hint', initialValue: 'Your secret');

String? _helper(BuildContext context) => context.knobs.stringOrNull(
  label: 'Helper',
  initialValue: 'At least 8 characters',
);

String? _error(BuildContext context) =>
    context.knobs.stringOrNull(label: 'Error text');

bool _enabled(BuildContext context) =>
    context.knobs.boolean(label: 'Enabled', initialValue: true);

IconData? _prefix(BuildContext context) =>
    context.knobs.boolean(label: 'Prefix icon') ? Icons.lock_outline : null;

// MARK: - Outlined

@widgetbook.UseCase(name: 'Outlined', type: RGPasswordField, path: 'Inputs')
Widget buildRGPasswordFieldOutlined(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: RGPasswordField.outlined(
      label: _label(context),
      hint: _hint(context),
      helperText: _helper(context),
      errorText: _error(context),
      enabled: _enabled(context),
      prefixIcon: _prefix(context),
    ),
  );
}

// MARK: - Filled

@widgetbook.UseCase(name: 'Filled', type: RGPasswordField, path: 'Inputs')
Widget buildRGPasswordFieldFilled(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: RGPasswordField.filled(
      label: _label(context),
      hint: _hint(context),
      helperText: _helper(context),
      errorText: _error(context),
      enabled: _enabled(context),
      prefixIcon: _prefix(context),
    ),
  );
}
