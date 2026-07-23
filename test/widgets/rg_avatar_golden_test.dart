import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';

import '../support/golden_harness.dart';

void main() {
  goldenTest(
    'rg_avatar',
    builder: (context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gallerySection(
          'Sizes',
          const Wrap(
            spacing: RGSpacing.lg,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              RGAvatar('RG', size: 32),
              RGAvatar('RG'),
              RGAvatar('RG', size: 56),
            ],
          ),
        ),
        gallerySection(
          'Single letter',
          const Wrap(
            spacing: RGSpacing.lg,
            children: [
              RGAvatar('R', size: 56),
            ],
          ),
        ),
      ],
    ),
  );
}
