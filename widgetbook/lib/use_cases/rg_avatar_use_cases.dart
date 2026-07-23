import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// Single use case driven by knobs for the initials and the size.

@widgetbook.UseCase(name: 'Default', type: RGAvatar, path: 'Display')
Widget buildRGAvatar(BuildContext context) => RGAvatar(
  context.knobs.string(label: 'Initials', initialValue: 'RG'),
  size: context.knobs.double.slider(
    label: 'Size',
    initialValue: 40,
    min: 24,
    max: 96,
  ),
);
