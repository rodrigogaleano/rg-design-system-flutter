import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';

import '../support/golden_harness.dart';

void main() {
  goldenTest(
    'rg_text',
    builder: (context) => gallerySection(
      'Type scale',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final entry in <String, Widget>{
            'display': RGText.display('Ag'),
            'h1': RGText.h1('Heading 1'),
            'h2': RGText.h2('Heading 2'),
            'h3': RGText.h3('Heading 3'),
            'h4': RGText.h4('Heading 4'),
            'bodyL': RGText.bodyL('Large body copy'),
            'body': RGText.body('Default body copy'),
            'bodyS': RGText.bodyS('Small body copy'),
            'caption': RGText.caption('Caption text'),
            'overline': RGText.overline('OVERLINE'),
            'micro': RGText.micro('Micro fine print'),
          }.entries)
            Padding(
              padding: const EdgeInsets.only(bottom: RGSpacing.md),
              child: specimen(entry.key, entry.value),
            ),
        ],
      ),
    ),
  );
}
