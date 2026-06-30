import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';

import '../support/golden_harness.dart';

void _onChanged(bool _) {}

void main() {
  goldenTest(
    'rg_switch',
    builder: (context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gallerySection(
          'With label',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final entry in <String, RGSwitch>{
                'on': const RGSwitch(
                  value: true,
                  label: 'Wi-Fi',
                  onChanged: _onChanged,
                ),
                'off': const RGSwitch(
                  value: false,
                  label: 'Wi-Fi',
                  onChanged: _onChanged,
                ),
                'label end': const RGSwitch(
                  value: true,
                  label: 'Wi-Fi',
                  labelPosition: RGSwitchLabelPosition.end,
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
              RGSwitch(value: true, onChanged: _onChanged),
              RGSwitch(value: false, onChanged: _onChanged),
            ],
          ),
        ),
        gallerySection(
          'Disabled',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final entry in <String, RGSwitch>{
                'on': const RGSwitch(
                  value: true,
                  label: 'Wi-Fi',
                  enabled: false,
                  onChanged: _onChanged,
                ),
                'off': const RGSwitch(
                  value: false,
                  label: 'Wi-Fi',
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
