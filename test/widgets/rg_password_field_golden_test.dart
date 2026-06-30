import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rg_design_system/rg_design_system.dart';

import '../support/golden_harness.dart';

RGPasswordField _password(
  RGTextFieldVariant variant, {
  String? initialValue,
  String? errorText,
  bool enabled = true,
}) {
  switch (variant) {
    case RGTextFieldVariant.outlined:
      return RGPasswordField.outlined(
        label: 'Password',
        initialValue: initialValue,
        errorText: errorText,
        enabled: enabled,
      );
    case RGTextFieldVariant.filled:
      return RGPasswordField.filled(
        label: 'Password',
        initialValue: initialValue,
        errorText: errorText,
        enabled: enabled,
      );
  }
}

Widget _states(RGTextFieldVariant variant) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    for (final entry in <String, RGPasswordField>{
      'masked': _password(variant, initialValue: 's3cret-pass'),
      'error': _password(
        variant,
        initialValue: 'short',
        errorText: 'At least 8 characters.',
      ),
      'disabled': _password(
        variant,
        initialValue: 's3cret-pass',
        enabled: false,
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
    'rg_password_field',
    builder: (context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final variant in RGTextFieldVariant.values)
          gallerySection(variant.name, _states(variant)),
      ],
    ),
  );

  // The reveal affordance: same fields with the value unmasked. Tapping each
  // toggle exercises the real state the widget owns rather than faking it.
  goldenTest(
    'rg_password_field_revealed',
    builder: (context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final variant in RGTextFieldVariant.values)
          gallerySection(
            variant.name,
            specimen(
              'revealed',
              _password(variant, initialValue: 's3cret-pass'),
            ),
          ),
      ],
    ),
    interact: (tester) async {
      final count = find.byIcon(Icons.visibility_off).evaluate().length;
      for (var i = 0; i < count; i++) {
        await tester.tap(find.byIcon(Icons.visibility_off).first);
        await tester.pump();
      }
    },
  );
}
