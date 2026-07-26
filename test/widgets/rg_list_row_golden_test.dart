import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';

import '../support/golden_harness.dart';

// The pin kicker from the weather app: the reason [RGListRow.overline] takes a
// widget instead of a string.
Widget _pin() => Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    const Icon(Icons.place_outlined, size: 10),
    const SizedBox(width: RGSpacing.xs),
    RGText.overline('MY LOCATION'),
  ],
);

void main() {
  goldenTest(
    'rg_list_row',
    builder: (context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gallerySection(
          'Complete',
          RGListRow(
            title: 'São Paulo',
            overline: _pin(),
            subtitle: 'Partly cloudy, feels like 24 degrees',
            caption: 'Updated 2 minutes ago',
            trailing: const Icon(Icons.chevron_right),
          ),
        ),
        gallerySection('Title only', const RGListRow(title: 'Laundry')),
        gallerySection(
          'Secondary',
          const RGListRow.secondary(
            title: 'Rio de Janeiro',
            subtitle: 'Brazil',
          ),
        ),
        gallerySection(
          'Truncation',
          const RGListRow(
            title: 'Buy groceries for the week and pick up the dry cleaning',
            trailing: Icon(Icons.chevron_right),
          ),
        ),
        gallerySection(
          'Stacked',
          const Column(
            children: [
              RGListRow(title: 'Groceries', subtitle: 'Due today'),
              RGListRow(title: 'Laundry'),
              RGListRow(
                title: 'Call the dentist',
                caption: 'Added last week',
                trailing: Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
