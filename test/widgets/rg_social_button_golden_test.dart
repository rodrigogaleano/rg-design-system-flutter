import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';

import '../support/golden_harness.dart';

void _noop() {}

Widget _stack(List<Widget> sections) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: sections,
);

void main() {
  goldenTest(
    'rg_social_button',
    builder: (context) => _stack([
      gallerySection(
        'Providers',
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            specimen(
              'google',
              const RGSocialButton.google(
                label: 'Continuar com Google',
                onPressed: _noop,
              ),
            ),
            const SizedBox(height: RGSpacing.md),
            specimen(
              'apple',
              const RGSocialButton.apple(
                label: 'Continuar com Apple',
                onPressed: _noop,
              ),
            ),
          ],
        ),
      ),
      gallerySection(
        'Disabled',
        const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RGSocialButton.google(label: 'Continuar com Google'),
            SizedBox(height: RGSpacing.md),
            RGSocialButton.apple(label: 'Continuar com Apple'),
          ],
        ),
      ),
    ]),
  );
}
