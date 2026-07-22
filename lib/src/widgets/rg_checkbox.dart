import 'package:flutter/material.dart';

import 'package:rg_design_system/src/theme/token_extensions.dart';
import 'package:rg_design_system/src/tokens/spacing.dart';
import 'package:rg_design_system/src/widgets/rg_text.dart';

/// Where the label sits relative to the checkbox.
enum RGCheckboxLabelPosition {
  /// Label before the box; the box trails at the end of the row.
  start,

  /// Label after the box.
  end,
}

/// Boolean checkbox for the RG Design System.
///
/// Wraps Material's [Checkbox] so interaction, focus, and accessibility come
/// for free, with colors resolved from the active [ColorScheme] to stay
/// monochromatic: a selected box fills with [ColorScheme.primary] and checks in
/// [ColorScheme.onPrimary]; an empty box is a hairline [ColorScheme.outline].
/// With a [label] the whole row becomes the tap target; without one it renders
/// the bare control. A null [onChanged] or `enabled: false` disables it.
class RGCheckbox extends StatelessWidget {
  // MARK: - Constructor

  /// Creates a checkbox reflecting [value]; pass a [label] to attach copy.
  const RGCheckbox({
    required this.value,
    required this.onChanged,
    super.key,
    this.label,
    this.labelPosition = RGCheckboxLabelPosition.end,
    this.enabled = true,
  });

  // MARK: - Properties

  /// Whether the box is checked.
  final bool value;

  /// Called with the new value on tap. Null disables the checkbox.
  final ValueChanged<bool>? onChanged;

  /// Optional copy shown beside the control.
  final String? label;

  /// Side the [label] sits on; defaults to [RGCheckboxLabelPosition.end].
  final RGCheckboxLabelPosition labelPosition;

  /// When false, dims the control and blocks toggling.
  final bool enabled;

  // MARK: - Build

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDisabled = !enabled || onChanged == null;

    final control = Checkbox(
      value: value,
      // Material hands back a nullable value even with tristate off.
      onChanged: isDisabled ? null : (next) => onChanged!(next ?? false),
      // Rectangular, matching the system default; a subtle radius softens it.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.radius.sm),
      ),
      side: WidgetStateBorderSide.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(
            color: scheme.onSurface.withValues(alpha: 0.38),
            width: 2,
          );
        }
        // Matches the fill so no outline rings the checked box.
        if (states.contains(WidgetState.selected)) {
          return BorderSide(color: scheme.primary, width: 2);
        }
        return BorderSide(color: scheme.outline, width: 2);
      }),
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (!states.contains(WidgetState.selected)) return Colors.transparent;
        if (states.contains(WidgetState.disabled)) {
          return scheme.onSurface.withValues(alpha: 0.38);
        }
        return scheme.primary;
      }),
      checkColor: scheme.onPrimary,
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return scheme.onSurface.withValues(alpha: 0.12);
        }
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return scheme.onSurface.withValues(alpha: 0.08);
        }
        return null;
      }),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    if (label == null) return control;

    final ink = isDisabled
        ? scheme.onSurface.withValues(alpha: 0.38)
        : scheme.onSurface;
    final text = Expanded(child: RGText.body(label!, color: ink));

    final children = labelPosition == RGCheckboxLabelPosition.start
        ? [text, const SizedBox(width: RGSpacing.sm), control]
        : [control, const SizedBox(width: RGSpacing.sm), text];

    return MergeSemantics(
      child: InkWell(
        onTap: isDisabled ? null : () => onChanged!(!value),
        borderRadius: BorderRadius.circular(context.radius.sm),
        child: Row(children: children),
      ),
    );
  }
}
