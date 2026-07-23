import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';

import '../support/golden_harness.dart';

void _onChanged(String _) {}

const _options = <RGSelectOption<String>>[
  RGSelectOption(value: 'en', label: 'English'),
  RGSelectOption(value: 'pt', label: 'Portugues'),
  RGSelectOption(value: 'es', label: 'Espanol'),
];

void main() {
  goldenTest(
    'rg_select',
    // The panel renders in the root overlay, outside the captured boundary, so
    // the gallery covers the trigger states; the open panel is exercised in the
    // widget tests instead.
    builder: (context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gallerySection(
          'Trigger',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final entry in <String, RGSelect<String>>{
                'placeholder': const RGSelect(
                  value: null,
                  hint: 'Selecione um idioma',
                  options: _options,
                  onChanged: _onChanged,
                ),
                'selected': const RGSelect(
                  value: 'pt',
                  options: _options,
                  onChanged: _onChanged,
                ),
                'with label': const RGSelect(
                  value: 'en',
                  label: 'Idioma',
                  options: _options,
                  onChanged: _onChanged,
                ),
              }.entries)
                Padding(
                  padding: const EdgeInsets.only(bottom: RGSpacing.md),
                  child: specimen(entry.key, entry.value),
                ),
            ],
          ),
        ),
        gallerySection(
          'Disabled',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final entry in <String, RGSelect<String>>{
                'placeholder': const RGSelect(
                  value: null,
                  hint: 'Selecione um idioma',
                  options: _options,
                  onChanged: null,
                ),
                'selected': const RGSelect(
                  value: 'pt',
                  options: _options,
                  onChanged: null,
                ),
              }.entries)
                Padding(
                  padding: const EdgeInsets.only(bottom: RGSpacing.md),
                  child: specimen(entry.key, entry.value),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}
