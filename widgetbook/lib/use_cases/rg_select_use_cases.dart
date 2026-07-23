import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// Single use case driven by knobs for the label, hint, and the disabled state.
// Backed by a stateful preview so the panel opens and the value changes live.

const _options = <RGSelectOption<String>>[
  RGSelectOption(value: 'en', label: 'English'),
  RGSelectOption(value: 'pt', label: 'Português'),
  RGSelectOption(value: 'es', label: 'Español'),
  RGSelectOption(value: 'fr', label: 'Français'),
];

@widgetbook.UseCase(name: 'Default', type: RGSelect, path: 'Inputs')
Widget buildRGSelect(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: _SelectPreview(
      label: context.knobs.stringOrNull(label: 'Label', initialValue: 'Idioma'),
      hint: context.knobs.string(label: 'Hint', initialValue: 'Selecione...'),
      enabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
    ),
  );
}

class _SelectPreview extends StatefulWidget {
  const _SelectPreview({
    required this.label,
    required this.hint,
    required this.enabled,
  });

  final String? label;
  final String hint;
  final bool enabled;

  @override
  State<_SelectPreview> createState() => _SelectPreviewState();
}

class _SelectPreviewState extends State<_SelectPreview> {
  String? _value;

  @override
  Widget build(BuildContext context) => RGSelect<String>(
    value: _value,
    label: widget.label,
    hint: widget.hint,
    options: _options,
    onChanged: widget.enabled
        ? (next) => setState(() => _value = next)
        : null,
  );
}
