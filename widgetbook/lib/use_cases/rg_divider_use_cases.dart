import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// Single use case driven by a label knob: null renders the plain line, any
// string switches to the labeled variant.

@widgetbook.UseCase(name: 'Default', type: RGDivider, path: 'Layout')
Widget buildRGDivider(BuildContext context) {
  final label = context.knobs.stringOrNull(label: 'Label', initialValue: 'ou');

  return Padding(
    padding: const EdgeInsets.all(16),
    child: label == null ? const RGDivider() : RGDivider.labeled(label: label),
  );
}
