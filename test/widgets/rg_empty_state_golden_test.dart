import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';

import '../support/golden_harness.dart';

void _onPressed() {}

void main() {
  goldenTest(
    'rg_empty_state',
    builder: (context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gallerySection(
          'Complete',
          const RGEmptyState(
            overline: 'No results',
            title: 'Nothing found',
            message: 'Try a different search term or check the spelling.',
            action: RGButton.filled('Try again', onPressed: _onPressed),
            footnote: 'Filters may be narrowing the results.',
          ),
        ),
        gallerySection(
          'Title and message',
          const RGEmptyState(
            title: 'Nothing found',
            message: 'Try a different search term or check the spelling.',
          ),
        ),
        gallerySection(
          'Message only',
          const RGEmptyState(message: 'Type something to start searching.'),
        ),
        gallerySection(
          'Wrapping title',
          const RGEmptyState(
            title: 'Nothing found here and nothing on the way either',
            message: 'The headline wraps instead of truncating.',
          ),
        ),
      ],
    ),
  );
}
