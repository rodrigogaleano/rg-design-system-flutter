import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// The sidebar sizes to its parent's height, so the case pins one instead of
// letting the catalog's viewport decide.

const List<String> _labels = ['Tasks', 'Settings', 'Archive'];

@widgetbook.UseCase(name: 'Default', type: RGSidebar, path: 'Layout')
Widget buildRGSidebar(BuildContext context) {
  final active = context.knobs.int.slider(
    label: 'Active item',
    initialValue: 0,
    max: _labels.length - 1,
    divisions: _labels.length - 1,
  );
  final hasFooter = context.knobs.boolean(label: 'Footer', initialValue: true);

  return SizedBox(
    height: 480,
    child: Row(
      children: [
        RGSidebar(
          header: RGText.h3('Todo'),
          items: [
            for (final (index, label) in _labels.indexed)
              RGNavItem(label: label, active: index == active, onTap: () {}),
          ],
          footer: hasFooter ? RGText.caption('Version 1.0.0') : null,
        ),
      ],
    ),
  );
}
