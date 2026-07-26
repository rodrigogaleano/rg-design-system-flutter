import 'package:flutter/material.dart';

import 'package:rg_design_system/src/tokens/spacing.dart';
import 'package:rg_design_system/src/widgets/rg_text.dart';

/// Section heading for the RG Design System.
///
/// Marks where one block of content ends and the next begins: an uppercase
/// overline above a hairline rule that spans the parent's width. The rule
/// tracks the scheme's subtle outline, landing near-white on a light surface
/// and near-black on a dark one, so it separates without competing with the
/// copy. Carries no top margin; the space above a section belongs to whoever
/// stacks them.
class RGSectionHeader extends StatelessWidget {
  // MARK: - Constructor

  /// Creates a section heading titled [label].
  const RGSectionHeader(this.label, {super.key});

  // MARK: - Properties

  /// Copy shown as the heading; uppercased on render, so pass localized
  /// strings in their natural case.
  final String label;

  // MARK: - Build

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // Container pads inside its decoration, so the gap falls between the label
    // and the rule, leaving the rule as the block's last pixel.
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: RGSpacing.sm),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: scheme.outlineVariant)),
      ),
      child: RGText.overline(
        label.toUpperCase(),
        color: scheme.onSurfaceVariant,
      ),
    );
  }
}
