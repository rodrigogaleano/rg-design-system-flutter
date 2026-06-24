import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// One use case per variant, plus an icon-only case. Knobs cover size, loading,
// icons, full width, the disabled state, and an optional accent color so the
// destructive (red) button can be exercised from the toolbar.

// MARK: - Shared knobs

RGButtonSize _sizeKnob(BuildContext context) => context.knobs.object.dropdown(
  label: 'Size',
  options: RGButtonSize.values,
  initialOption: RGButtonSize.medium,
  labelBuilder: (size) => size.name,
);

VoidCallback? _onPressed(BuildContext context) =>
    context.knobs.boolean(label: 'Enabled', initialValue: true) ? () {} : null;

bool _loading(BuildContext context) => context.knobs.boolean(label: 'Loading');

bool _fullWidth(BuildContext context) =>
    context.knobs.boolean(label: 'Full width');

IconData? _leading(BuildContext context) =>
    context.knobs.boolean(label: 'Leading icon') ? Icons.add : null;

IconData? _trailing(BuildContext context) =>
    context.knobs.boolean(label: 'Trailing icon') ? Icons.arrow_forward : null;

bool _destructive(BuildContext context) =>
    context.knobs.boolean(label: 'Destructive');

String _label(BuildContext context) =>
    context.knobs.string(label: 'Text', initialValue: 'Button');

// MARK: - Filled

@widgetbook.UseCase(name: 'Filled', type: RGButton)
Widget buildRGButtonFilled(BuildContext context) => RGButton.filled(
  _label(context),
  onPressed: _onPressed(context),
  size: _sizeKnob(context),
  isDestructive: _destructive(context),
  leadingIcon: _leading(context),
  trailingIcon: _trailing(context),
  isLoading: _loading(context),
  fullWidth: _fullWidth(context),
);

// MARK: - Tonal

@widgetbook.UseCase(name: 'Tonal', type: RGButton)
Widget buildRGButtonTonal(BuildContext context) => RGButton.tonal(
  _label(context),
  onPressed: _onPressed(context),
  size: _sizeKnob(context),
  isDestructive: _destructive(context),
  leadingIcon: _leading(context),
  trailingIcon: _trailing(context),
  isLoading: _loading(context),
  fullWidth: _fullWidth(context),
);

// MARK: - Outline

@widgetbook.UseCase(name: 'Outline', type: RGButton)
Widget buildRGButtonOutline(BuildContext context) => RGButton.outline(
  _label(context),
  onPressed: _onPressed(context),
  size: _sizeKnob(context),
  isDestructive: _destructive(context),
  leadingIcon: _leading(context),
  trailingIcon: _trailing(context),
  isLoading: _loading(context),
  fullWidth: _fullWidth(context),
);

// MARK: - Text

@widgetbook.UseCase(name: 'Text', type: RGButton)
Widget buildRGButtonText(BuildContext context) => RGButton.text(
  _label(context),
  onPressed: _onPressed(context),
  size: _sizeKnob(context),
  isDestructive: _destructive(context),
  leadingIcon: _leading(context),
  trailingIcon: _trailing(context),
  isLoading: _loading(context),
  fullWidth: _fullWidth(context),
);

// MARK: - Icon-only

@widgetbook.UseCase(name: 'Icon', type: RGButton)
Widget buildRGButtonIcon(BuildContext context) => RGButton.icon(
  icon: Icons.favorite,
  tooltip: context.knobs.string(label: 'Tooltip', initialValue: 'Like'),
  onPressed: _onPressed(context),
  variant: context.knobs.object.dropdown(
    label: 'Variant',
    options: RGButtonVariant.values,
    initialOption: RGButtonVariant.filled,
    labelBuilder: (variant) => variant.name,
  ),
  size: _sizeKnob(context),
  isDestructive: _destructive(context),
  isLoading: _loading(context),
);
