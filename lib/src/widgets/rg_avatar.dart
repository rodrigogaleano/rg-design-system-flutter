import 'package:flutter/material.dart';

import 'package:rg_design_system/src/tokens/radius.dart';
import 'package:rg_design_system/src/widgets/rg_text.dart';

/// Monogram avatar for the RG Design System.
///
/// Shows a person's initials as a bold monogram on a subtle gray circle with a
/// hairline border, staying strictly monochromatic. The ink follows the surface
/// in light and dark through the active [ColorScheme].
class RGAvatar extends StatelessWidget {
  // MARK: - Constructor

  /// Creates a circular avatar showing [initials], e.g. `'RG'`.
  const RGAvatar(this.initials, {super.key, this.size = _defaultSize});

  // MARK: - Properties

  /// The monogram, e.g. `'RG'`.
  final String initials;

  /// The diameter of the circle; defaults to 40.
  final double size;

  // MARK: - Build

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Semantics(
      container: true,
      label: initials,
      child: SizedBox.square(
        dimension: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: scheme.surfaceContainerLow,
            border: Border.all(color: scheme.outline),
            borderRadius: BorderRadius.circular(RGRadius.full),
          ),
          child: Center(
            child: ExcludeSemantics(
              child: RGText.h4(
                initials,
                maxLines: 1,
                style: TextStyle(fontSize: size * _monogramRatio),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Default diameter; comfortable in list rows and headers.
const double _defaultSize = 40;

/// Monogram font size as a fraction of [RGAvatar.size]; keeps the two letters
/// balanced within the circle across every size.
const double _monogramRatio = 0.36;
