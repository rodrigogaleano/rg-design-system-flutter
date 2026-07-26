import 'package:flutter/material.dart';

import 'package:rg_design_system/src/theme/token_extensions.dart';
import 'package:rg_design_system/src/tokens/spacing.dart';
import 'package:rg_design_system/src/widgets/rg_text.dart';

/// List row for the RG Design System.
///
/// One entry in a vertical list: a stack of copy on the left, an optional
/// trailing slot on the right, and a hairline rule closing the row. The rule
/// tracks the scheme's subtle outline in both themes and is always drawn, so a
/// list chains rows without a separator builder. Supporting copy sits in the
/// muted ink, leaving the title as the only strong voice in the row.
///
/// Carries no horizontal padding; the list's margin belongs to whoever lays it
/// out. A null [onTap] leaves the row inert, with no ink and no tap target.
class RGListRow extends StatelessWidget {
  // MARK: - Constructors

  /// Creates a row titled [title] at the default scale.
  const RGListRow({
    required this.title,
    super.key,
    this.overline,
    this.subtitle,
    this.caption,
    this.trailing,
    this.onTap,
  }) : _isSecondary = false;

  /// Creates a row whose title sits a step below the default in the hierarchy.
  ///
  /// Only the title's scale changes; the row keeps the same padding, so mixed
  /// lists stay on one rhythm.
  const RGListRow.secondary({
    required this.title,
    super.key,
    this.overline,
    this.subtitle,
    this.caption,
    this.trailing,
    this.onTap,
  }) : _isSecondary = true;

  // MARK: - Properties

  /// The row's headline; truncates with an ellipsis rather than wrapping.
  final String title;

  /// Free block above the title, e.g. an icon paired with a kicker.
  final Widget? overline;

  /// Supporting copy under the title, in the muted ink.
  final String? subtitle;

  /// Fine print under the subtitle, in the muted ink.
  final String? caption;

  /// Slot pinned to the row's end, e.g. a chevron, a switch, or a value.
  final Widget? trailing;

  /// Called when the row is tapped; null leaves the row inert.
  final VoidCallback? onTap;

  /// Whether the title renders at the secondary scale.
  final bool _isSecondary;

  // MARK: - Build

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // Container pads inside its decoration, so the rule closes the row below
    // the padding rather than hugging the copy.
    final row = Container(
      padding: const EdgeInsets.symmetric(vertical: RGSpacing.md),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: scheme.outlineVariant)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _copy(scheme)),
          if (trailing != null) ...[
            const SizedBox(width: RGSpacing.md),
            trailing!,
          ],
        ],
      ),
    );

    if (onTap == null) return MergeSemantics(child: row);

    return MergeSemantics(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.radius.none),
        child: row,
      ),
    );
  }

  // MARK: - Copy

  /// The stacked text block; sized to its content so an unbounded list height
  /// never forces the column to grow.
  Widget _copy(ColorScheme scheme) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (overline != null) ...[
        overline!,
        const SizedBox(height: RGSpacing.xs),
      ],
      _title(),
      if (subtitle != null) ...[
        const SizedBox(height: RGSpacing.xs),
        RGText.caption(subtitle!, color: scheme.onSurfaceVariant),
      ],
      if (caption != null) ...[
        const SizedBox(height: RGSpacing.xs),
        RGText.micro(caption!, color: scheme.onSurfaceVariant),
      ],
    ],
  );

  /// The headline at the scale the chosen constructor set. The secondary title
  /// borrows the body token, which is regular, so the weight is merged back in.
  Widget _title() => _isSecondary
      ? RGText.bodyL(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700),
        )
      : RGText.h4(title, maxLines: 1, overflow: TextOverflow.ellipsis);
}
