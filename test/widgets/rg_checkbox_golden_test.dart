import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';

import '../support/golden_harness.dart';

void _onChanged(bool _) {}

void main() {
  goldenTest(
    'rg_checkbox',
    builder: (context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gallerySection(
          'With label',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final entry in <String, RGCheckbox>{
                'checked': const RGCheckbox(
                  value: true,
                  label: 'Accept terms',
                  onChanged: _onChanged,
                ),
                'unchecked': const RGCheckbox(
                  value: false,
                  label: 'Accept terms',
                  onChanged: _onChanged,
                ),
                'label start': const RGCheckbox(
                  value: true,
                  label: 'Accept terms',
                  labelPosition: RGCheckboxLabelPosition.start,
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
          'Bare control',
          const Wrap(
            spacing: RGSpacing.lg,
            children: [
              RGCheckbox(value: true, onChanged: _onChanged),
              RGCheckbox(value: false, onChanged: _onChanged),
            ],
          ),
        ),
        gallerySection(
          'Disabled',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final entry in <String, RGCheckbox>{
                'checked': const RGCheckbox(
                  value: true,
                  label: 'Accept terms',
                  enabled: false,
                  onChanged: _onChanged,
                ),
                'unchecked': const RGCheckbox(
                  value: false,
                  label: 'Accept terms',
                  enabled: false,
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
      ],
    ),
  );
}
