import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// The knob takes natural case: the component uppercases the label itself, the
// way a localized string arrives from the ARB.

@widgetbook.UseCase(name: 'Default', type: RGSectionHeader, path: 'Layout')
Widget buildRGSectionHeader(BuildContext context) {
  final label = context.knobs.string(
    label: 'Label',
    initialValue: 'Appearance',
  );

  return Padding(
    padding: const EdgeInsets.all(16),
    child: RGSectionHeader(label),
  );
}
