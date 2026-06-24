import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// One use case per typography style; the text is editable through a knob
// and the ink follows the theme selected in the toolbar.

// MARK: - Display

@widgetbook.UseCase(name: 'Display', type: RGText)
Widget buildRGTextDisplay(BuildContext context) => RGText.display(
  context.knobs.string(label: 'Text', initialValue: 'Display'),
);

// MARK: - Headings

@widgetbook.UseCase(name: 'H1', type: RGText)
Widget buildRGTextH1(BuildContext context) =>
    RGText.h1(context.knobs.string(label: 'Text', initialValue: 'Heading 1'));

@widgetbook.UseCase(name: 'H2', type: RGText)
Widget buildRGTextH2(BuildContext context) =>
    RGText.h2(context.knobs.string(label: 'Text', initialValue: 'Heading 2'));

@widgetbook.UseCase(name: 'H3', type: RGText)
Widget buildRGTextH3(BuildContext context) =>
    RGText.h3(context.knobs.string(label: 'Text', initialValue: 'Heading 3'));

@widgetbook.UseCase(name: 'H4', type: RGText)
Widget buildRGTextH4(BuildContext context) =>
    RGText.h4(context.knobs.string(label: 'Text', initialValue: 'Heading 4'));

// MARK: - Body

@widgetbook.UseCase(name: 'BodyL', type: RGText)
Widget buildRGTextBodyL(BuildContext context) => RGText.bodyL(
  context.knobs.string(label: 'Text', initialValue: 'Large body copy'),
);

@widgetbook.UseCase(name: 'Body', type: RGText)
Widget buildRGTextBody(BuildContext context) => RGText.body(
  context.knobs.string(label: 'Text', initialValue: 'Default body text'),
);

@widgetbook.UseCase(name: 'BodyS', type: RGText)
Widget buildRGTextBodyS(BuildContext context) => RGText.bodyS(
  context.knobs.string(label: 'Text', initialValue: 'Small body copy'),
);

// MARK: - Supporting

@widgetbook.UseCase(name: 'Caption', type: RGText)
Widget buildRGTextCaption(BuildContext context) => RGText.caption(
  context.knobs.string(label: 'Text', initialValue: 'Caption'),
);

@widgetbook.UseCase(name: 'Overline', type: RGText)
Widget buildRGTextOverline(BuildContext context) => RGText.overline(
  context.knobs.string(label: 'Text', initialValue: 'OVERLINE'),
);

@widgetbook.UseCase(name: 'Micro', type: RGText)
Widget buildRGTextMicro(BuildContext context) =>
    RGText.micro(context.knobs.string(label: 'Text', initialValue: 'Micro'));
