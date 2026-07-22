import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// Single use case driven by knobs for the label, label position, and the
// disabled state. Backed by a stateful preview so the box checks live.

@widgetbook.UseCase(name: 'Default', type: RGCheckbox, path: 'Selection')
Widget buildRGCheckbox(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: _CheckboxPreview(
      label: context.knobs.stringOrNull(
        label: 'Label',
        initialValue: 'Accept terms',
      ),
      enabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
      position: context.knobs.object.dropdown(
        label: 'Label position',
        options: RGCheckboxLabelPosition.values,
        initialOption: RGCheckboxLabelPosition.end,
        labelBuilder: (position) => position.name,
      ),
    ),
  );
}

class _CheckboxPreview extends StatefulWidget {
  const _CheckboxPreview({
    required this.label,
    required this.enabled,
    required this.position,
  });

  final String? label;
  final bool enabled;
  final RGCheckboxLabelPosition position;

  @override
  State<_CheckboxPreview> createState() => _CheckboxPreviewState();
}

class _CheckboxPreviewState extends State<_CheckboxPreview> {
  bool _value = false;

  @override
  Widget build(BuildContext context) => RGCheckbox(
    value: _value,
    label: widget.label,
    labelPosition: widget.position,
    enabled: widget.enabled,
    onChanged: (next) => setState(() => _value = next),
  );
}
