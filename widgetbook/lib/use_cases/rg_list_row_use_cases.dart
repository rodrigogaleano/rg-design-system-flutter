import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// Overline and trailing are booleans rather than knobs of their own: both are
// widget slots, so the knob only decides whether a stand-in fills them.

@widgetbook.UseCase(name: 'Default', type: RGListRow, path: 'Display')
Widget buildRGListRow(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'São Paulo',
  );
  final subtitle = context.knobs.stringOrNull(
    label: 'Subtitle',
    initialValue: 'Partly cloudy, feels like 24 degrees',
  );
  final caption = context.knobs.stringOrNull(
    label: 'Caption',
    initialValue: 'Updated 2 minutes ago',
  );
  final hasOverline = context.knobs.boolean(label: 'Overline');
  final hasTrailing = context.knobs.boolean(
    label: 'Trailing',
    initialValue: true,
  );

  return Padding(
    padding: const EdgeInsets.all(16),
    child: RGListRow(
      title: title,
      overline: hasOverline ? RGText.overline('MY LOCATION') : null,
      subtitle: subtitle,
      caption: caption,
      trailing: hasTrailing ? const Icon(Icons.chevron_right) : null,
      onTap: () {},
    ),
  );
}
