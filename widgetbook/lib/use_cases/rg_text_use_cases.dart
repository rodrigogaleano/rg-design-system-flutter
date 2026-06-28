import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// A single specimen stacking every style top to bottom of the scale, each
// labelled with its token name. The sample text is editable through a knob and
// the ink follows the theme selected in the toolbar.

@widgetbook.UseCase(name: 'Type scale', type: RGText, path: 'Typography')
Widget buildRGTextScale(BuildContext context) {
  final sample = context.knobs.string(
    label: 'Sample',
    initialValue: 'Rodrigo Galeano',
  );
  final labelInk = Theme.of(context).colorScheme.onSurfaceVariant;

  final styles = <(String, Widget)>[
    ('Display', RGText.display(sample)),
    ('H1', RGText.h1(sample)),
    ('H2', RGText.h2(sample)),
    ('H3', RGText.h3(sample)),
    ('H4', RGText.h4(sample)),
    ('BodyL', RGText.bodyL(sample)),
    ('Body', RGText.body(sample)),
    ('BodyS', RGText.bodyS(sample)),
    ('Caption', RGText.caption(sample)),
    ('Overline', RGText.overline(sample)),
    ('Micro', RGText.micro(sample)),
  ];

  return SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (name, text) in styles)
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RGText.caption(name, color: labelInk),
                const SizedBox(height: 4),
                text,
              ],
            ),
          ),
      ],
    ),
  );
}
