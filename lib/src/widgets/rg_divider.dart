import 'package:flutter/material.dart';

import 'package:rg_design_system/src/tokens/spacing.dart';
import 'package:rg_design_system/src/tokens/typography.dart';
import 'package:rg_design_system/src/widgets/rg_text.dart';

/// Thin horizontal separator for the RG Design System.
///
/// Draws a 1px full-width line in the scheme's outline color, so it reads as a
/// quiet boundary in both light and dark. The [RGDivider.labeled] variant
/// splits the line around a centered muted label, the classic "or" between
/// alternative actions.
class RGDivider extends StatelessWidget {
  // MARK: - Constructors

  /// Creates a plain full-width divider line.
  const RGDivider({super.key}) : label = null;

  /// Creates a divider with [label] centered between two line segments.
  const RGDivider.labeled({required String this.label, super.key});

  // MARK: - Properties

  /// Copy shown between the line segments; null renders a plain line.
  final String? label;

  // MARK: - Build

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final line = Container(height: 1, color: scheme.outline);

    if (label == null) return line;

    // Centering the 1px line against the label's line box lands on a half
    // pixel and anti-aliases into a fatter, fainter stroke. Inset from the
    // top by a whole pixel instead so it renders like the plain variant.
    final labelStyle = RGTextStyles.bodyS;
    final labelHeight = labelStyle.fontSize! * labelStyle.height!;
    final segment = Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: ((labelHeight - 1) / 2).floorToDouble()),
        child: line,
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        segment,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: RGSpacing.md),
          child: RGText.bodyS(label!, color: scheme.onSurfaceVariant),
        ),
        segment,
      ],
    );
  }
}
