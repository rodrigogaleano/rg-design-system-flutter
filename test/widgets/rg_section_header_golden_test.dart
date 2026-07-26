import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';

import '../support/golden_harness.dart';

void main() {
  goldenTest(
    'rg_section_header',
    builder: (context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gallerySection('Short label', const RGSectionHeader('Appearance')),
        gallerySection(
          'Wrapping label',
          const RGSectionHeader(
            'Notifications, sounds and haptics for every alert we raise',
          ),
        ),
        gallerySection('Already uppercase', const RGSectionHeader('UNITS')),
      ],
    ),
  );
}
