import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// The title knob is a plain string rather than nullable: clearing every copy
// slot trips the widget's assert, so one of them has to stay filled for the
// catalog to keep rendering.

@widgetbook.UseCase(name: 'Default', type: RGEmptyState, path: 'Feedback')
Widget buildRGEmptyState(BuildContext context) {
  final hasAction = context.knobs.boolean(label: 'Action', initialValue: true);

  return Padding(
    padding: const EdgeInsets.all(16),
    child: RGEmptyState(
      overline: context.knobs.stringOrNull(
        label: 'Overline',
        initialValue: 'No results',
      ),
      title: context.knobs.string(
        label: 'Title',
        initialValue: 'Nothing found',
      ),
      message: context.knobs.stringOrNull(
        label: 'Message',
        initialValue: 'Try a different search term or check the spelling.',
      ),
      action: hasAction ? RGButton.filled('Try again', onPressed: () {}) : null,
      footnote: context.knobs.stringOrNull(
        label: 'Footnote',
        initialValue: 'Filters may be narrowing the results.',
      ),
    ),
  );
}
