import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';

import '../support/golden_harness.dart';

void _noop() {}

// Builds a button for [variant] so the matrix can be driven by a loop over the
// enum instead of a hardcoded list.
RGButton _button(
  RGButtonVariant variant,
  String label, {
  RGButtonSize size = RGButtonSize.medium,
  VoidCallback? onPressed = _noop,
  bool isDestructive = false,
  bool isLoading = false,
  IconData? leadingIcon,
  IconData? trailingIcon,
}) {
  switch (variant) {
    case RGButtonVariant.filled:
      return RGButton.filled(
        label,
        onPressed: onPressed,
        size: size,
        isDestructive: isDestructive,
        isLoading: isLoading,
        leadingIcon: leadingIcon,
        trailingIcon: trailingIcon,
      );
    case RGButtonVariant.tonal:
      return RGButton.tonal(
        label,
        onPressed: onPressed,
        size: size,
        isDestructive: isDestructive,
        isLoading: isLoading,
        leadingIcon: leadingIcon,
        trailingIcon: trailingIcon,
      );
    case RGButtonVariant.outline:
      return RGButton.outline(
        label,
        onPressed: onPressed,
        size: size,
        isDestructive: isDestructive,
        isLoading: isLoading,
        leadingIcon: leadingIcon,
        trailingIcon: trailingIcon,
      );
    case RGButtonVariant.text:
      return RGButton.text(
        label,
        onPressed: onPressed,
        size: size,
        isDestructive: isDestructive,
        isLoading: isLoading,
        leadingIcon: leadingIcon,
        trailingIcon: trailingIcon,
      );
  }
}

Widget _row(List<Widget> children) => Wrap(
  spacing: RGSpacing.sm,
  runSpacing: RGSpacing.sm,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: children,
);

Widget _stack(List<Widget> sections) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: sections,
);

void main() {
  goldenTest(
    'rg_button',
    builder: (context) => _stack([
      gallerySection(
        'Variants x sizes',
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final variant in RGButtonVariant.values)
              Padding(
                padding: const EdgeInsets.only(bottom: RGSpacing.md),
                child: specimen(
                  variant.name,
                  _row([
                    for (final size in RGButtonSize.values)
                      _button(variant, 'Label', size: size),
                  ]),
                ),
              ),
          ],
        ),
      ),
      gallerySection(
        'States',
        _row([
          for (final variant in RGButtonVariant.values)
            _button(variant, 'Disabled', onPressed: null),
          _button(RGButtonVariant.filled, 'Loading', isLoading: true),
          _button(RGButtonVariant.filled, 'Delete', isDestructive: true),
          _button(RGButtonVariant.outline, 'Delete', isDestructive: true),
        ]),
      ),
      gallerySection(
        'Icons',
        _row([
          _button(RGButtonVariant.filled, 'Leading', leadingIcon: Icons.add),
          _button(
            RGButtonVariant.filled,
            'Trailing',
            trailingIcon: Icons.arrow_forward,
          ),
          const RGButton.icon(
            icon: Icons.delete,
            tooltip: 'Delete',
            onPressed: _noop,
          ),
        ]),
      ),
    ]),
  );
}
