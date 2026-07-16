import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';

import '../support/golden_harness.dart';

void main() {
  goldenTest(
    'rg_divider',
    builder: (context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gallerySection('Plain', const RGDivider()),
        gallerySection(
          'Labeled',
          const Column(
            children: [
              RGDivider.labeled(label: 'ou'),
              SizedBox(height: RGSpacing.md),
              RGDivider.labeled(label: 'ou continue com'),
            ],
          ),
        ),
      ],
    ),
  );
}
