import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// Single use case driven by knobs for the label, label position, and the
// disabled state. Backed by a stateful preview so the toggle flips live.

@widgetbook.UseCase(name: 'Default', type: RGSwitch, path: 'Selection')
Widget buildRGSwitch(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: _SwitchPreview(
      label: context.knobs.stringOrNull(
        label: 'Label',
        initialValue: 'Enable notifications',
      ),
      enabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
      position: context.knobs.object.dropdown(
        label: 'Label position',
        options: RGSwitchLabelPosition.values,
        initialOption: RGSwitchLabelPosition.start,
        labelBuilder: (position) => position.name,
      ),
    ),
  );
}

class _SwitchPreview extends StatefulWidget {
  const _SwitchPreview({
    required this.label,
    required this.enabled,
    required this.position,
  });

  final String? label;
  final bool enabled;
  final RGSwitchLabelPosition position;

  @override
  State<_SwitchPreview> createState() => _SwitchPreviewState();
}

class _SwitchPreviewState extends State<_SwitchPreview> {
  bool _value = false;

  @override
  Widget build(BuildContext context) => RGSwitch(
    value: _value,
    label: widget.label,
    labelPosition: widget.position,
    enabled: widget.enabled,
    onChanged: (next) => setState(() => _value = next),
  );
}
