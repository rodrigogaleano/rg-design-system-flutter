import 'package:flutter/material.dart';

import 'package:rg_design_system/src/tokens/spacing.dart';
import 'package:rg_design_system/src/widgets/rg_text.dart';

/// A single destination within an [RGSidebar].
///
/// A square marker and a label on one tappable row. The active item fills its
/// marker with the surface ink and bolds the label; the inactive one drops the
/// marker to transparent and the label to the muted ink, so the current
/// destination reads without leaning on color. Exposes itself as a selected
/// button, so the state never lives in the visual alone.
class RGNavItem extends StatelessWidget {
  // MARK: - Constructor

  /// Creates a destination titled [label].
  const RGNavItem({
    required this.label,
    required this.active,
    required this.onTap,
    super.key,
  });

  // MARK: - Properties

  /// Copy naming the destination.
  final String label;

  /// Whether this is the destination currently being shown.
  final bool active;

  /// Called when the item is tapped.
  final VoidCallback onTap;

  // MARK: - Build

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return MergeSemantics(
      child: Semantics(
        button: true,
        selected: active,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: RGSpacing.sm),
            child: Row(
              children: [
                // Kept in the layout when inactive so the labels never shift.
                Container(
                  width: _markerSize,
                  height: _markerSize,
                  color: active ? scheme.onSurface : Colors.transparent,
                ),
                const SizedBox(width: RGSpacing.sm),
                // Truncates rather than overflowing: a destination label that
                // outgrows the sidebar must not reflow the navigation.
                Expanded(
                  child: RGText.body(
                    label,
                    color: active ? null : scheme.onSurfaceVariant,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: active
                        ? const TextStyle(fontWeight: FontWeight.w700)
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Side navigation for the RG Design System.
///
/// A fixed-width column for wide layouts: a [header] block, the list of
/// destinations, and an optional [footer] pinned to the bottom. A hairline down
/// the right edge separates it from the content it navigates, tracking the
/// scheme's subtle outline in both themes. The destinations always sit just
/// under the header, whether or not a footer is given.
///
/// Takes its height from the parent, which has to be bounded.
class RGSidebar extends StatelessWidget {
  // MARK: - Constructor

  /// Creates a sidebar showing [items] under [header].
  const RGSidebar({
    required this.header,
    required this.items,
    super.key,
    this.footer,
    this.width = _defaultWidth,
  });

  // MARK: - Properties

  /// Block at the top, e.g. a view title or a wordmark.
  final Widget header;

  /// The destinations, in the order they are shown.
  final List<RGNavItem> items;

  /// Block pinned to the bottom; null leaves the space empty.
  final Widget? footer;

  /// The sidebar's fixed width; defaults to 240.
  final double width;

  // MARK: - Build

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(
        horizontal: RGSpacing.lg,
        vertical: RGSpacing.xl,
      ),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: scheme.outlineVariant)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header,
          const SizedBox(height: RGSpacing.xxl),
          for (final (index, item) in items.indexed) ...[
            if (index > 0) const SizedBox(height: RGSpacing.xs),
            item,
          ],
          // Runs even without a footer, so the destinations stay at the top.
          const Spacer(),
          ?footer,
        ],
      ),
    );
  }
}

/// Default sidebar width; comfortable for a handful of destinations.
const double _defaultWidth = 240;

/// Side of the square marking the active destination.
const double _markerSize = 6;
