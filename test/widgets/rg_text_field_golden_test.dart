import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';

import '../support/golden_harness.dart';

RGTextField _field(
  RGTextFieldVariant variant, {
  String? label,
  String? hint,
  String? initialValue,
  String? helperText,
  String? errorText,
  IconData? prefixIcon,
  IconData? suffixIcon,
  bool enabled = true,
}) {
  switch (variant) {
    case RGTextFieldVariant.outlined:
      return RGTextField.outlined(
        label: label,
        hint: hint,
        initialValue: initialValue,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        enabled: enabled,
      );
    case RGTextFieldVariant.filled:
      return RGTextField.filled(
        label: label,
        hint: hint,
        initialValue: initialValue,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        enabled: enabled,
      );
  }
}

// The full state matrix for one variant, stacked vertically.
Widget _states(RGTextFieldVariant variant) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    for (final entry in <String, RGTextField>{
      'empty': _field(variant, label: 'Email', hint: 'you@example.com'),
      'filled': _field(variant, label: 'Email', initialValue: 'rod@rg.dev'),
      'helper': _field(
        variant,
        label: 'Email',
        initialValue: 'rod@rg.dev',
        helperText: "We'll never share it.",
      ),
      'error': _field(
        variant,
        label: 'Email',
        initialValue: 'not-an-email',
        errorText: 'Enter a valid email.',
      ),
      'disabled': _field(
        variant,
        label: 'Email',
        initialValue: 'rod@rg.dev',
        enabled: false,
      ),
      'icons': _field(
        variant,
        label: 'Search',
        initialValue: 'query',
        prefixIcon: Icons.search,
        suffixIcon: Icons.close,
      ),
    }.entries)
      Padding(
        padding: const EdgeInsets.only(bottom: RGSpacing.md),
        child: specimen(entry.key, entry.value),
      ),
  ],
);

void main() {
  goldenTest(
    'rg_text_field',
    builder: (context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final variant in RGTextFieldVariant.values)
          gallerySection(variant.name, _states(variant)),
      ],
    ),
  );
}
