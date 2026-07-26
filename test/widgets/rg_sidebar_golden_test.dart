import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';

import '../support/golden_harness.dart';

void _onTap() {}

// The sidebar takes its height from the parent, which the gallery does not
// bound, so every specimen fixes one.
Widget _framed(Widget sidebar, {double height = 320}) => SizedBox(
  height: height,
  child: Row(children: [sidebar]),
);

Widget _sidebar({Widget? footer, String thirdLabel = 'Archive'}) => RGSidebar(
  header: RGText.h3('Todo'),
  items: [
    const RGNavItem(label: 'Tasks', active: true, onTap: _onTap),
    const RGNavItem(label: 'Settings', active: false, onTap: _onTap),
    RGNavItem(label: thirdLabel, active: false, onTap: _onTap),
  ],
  footer: footer,
);

void main() {
  goldenTest(
    'rg_sidebar',
    builder: (context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gallerySection(
          'With footer',
          _framed(_sidebar(footer: RGText.caption('Version 1.0.0'))),
        ),
        gallerySection('Without footer', _framed(_sidebar())),
        gallerySection(
          'Truncated label',
          _framed(_sidebar(thirdLabel: 'Archived and completed tasks')),
        ),
      ],
    ),
  );
}
