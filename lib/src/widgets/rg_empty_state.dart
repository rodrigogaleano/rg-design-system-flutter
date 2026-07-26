import 'package:flutter/material.dart';

import 'package:rg_design_system/src/tokens/spacing.dart';
import 'package:rg_design_system/src/widgets/rg_text.dart';

/// Empty state for the RG Design System.
///
/// The copy shown when a view has nothing to display: an uppercase kicker, a
/// headline, a line of explanation, an action, and a closing footnote, all
/// optional. Supporting copy sits in the muted ink, leaving the headline as
/// the only strong voice in the block.
///
/// Lays out as a plain left-aligned block: no padding, no maximum width, no
/// vertical centering. Placing and constraining it belongs to the call site.
class RGEmptyState extends StatelessWidget {
  // MARK: - Constructor

  /// Creates an empty state from whichever slots are given.
  ///
  /// At least one of [overline], [title], [message], or [footnote] must be
  /// non-null; [action] alone does not make an empty state.
  const RGEmptyState({
    super.key,
    this.overline,
    this.title,
    this.message,
    this.action,
    this.footnote,
  }) : assert(
         overline != null ||
             title != null ||
             message != null ||
             footnote != null,
         'An empty state needs at least one of overline, title, message or '
         'footnote',
       );

  // MARK: - Properties

  /// Kicker above the headline; uppercased on render, so pass localized
  /// strings in their natural case.
  final String? overline;

  /// The headline; wraps across as many lines as it needs.
  final String? title;

  /// The explanation under the headline, in the muted ink.
  final String? message;

  /// Slot for the way out of the empty state, e.g. a button.
  final Widget? action;

  /// Closing fine print, in the muted ink.
  final String? footnote;

  // MARK: - Build

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // Each block carries the space that goes above it, dropped when the block
    // lands first. That is what keeps a null slot from leaving a hole.
    final blocks = <({double gap, Widget child})>[
      if (overline != null)
        (
          gap: 0,
          child: RGText.overline(
            overline!.toUpperCase(),
            color: scheme.onSurfaceVariant,
          ),
        ),
      // The headline is left unbounded on purpose: here it is the content, so
      // it wraps instead of truncating.
      if (title != null) (gap: RGSpacing.md, child: RGText.h2(title!)),
      if (message != null)
        (
          gap: RGSpacing.md,
          child: RGText.body(message!, color: scheme.onSurfaceVariant),
        ),
      if (action != null) (gap: RGSpacing.xl, child: action!),
      if (footnote != null)
        (
          gap: RGSpacing.md,
          child: RGText.caption(footnote!, color: scheme.onSurfaceVariant),
        ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (index, block) in blocks.indexed) ...[
          if (index > 0) SizedBox(height: block.gap),
          block.child,
        ],
      ],
    );
  }
}
