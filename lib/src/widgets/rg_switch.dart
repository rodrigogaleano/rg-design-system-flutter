import 'package:flutter/material.dart';

import 'package:rg_design_system/src/theme/token_extensions.dart';
import 'package:rg_design_system/src/tokens/spacing.dart';
import 'package:rg_design_system/src/widgets/rg_text.dart';

/// Where the label sits relative to the switch.
enum RGSwitchLabelPosition {
  /// Label before the switch; the switch trails at the end of the row.
  start,

  /// Label after the switch.
  end,
}

/// Boolean on/off toggle for the RG Design System.
///
/// Wraps Material's [Switch] so interaction, focus, and accessibility come for
/// free, with colors resolved from the active [ColorScheme] to stay
/// monochromatic. With a [label] the whole row becomes the tap target; without
/// one it renders the bare control. A null [onChanged] or `enabled: false`
/// disables it.
class RGSwitch extends StatelessWidget {
  // MARK: - Constructor

  /// Creates a switch reflecting [value]; pass a [label] to attach copy.
  const RGSwitch({
    required this.value,
    required this.onChanged,
    super.key,
    this.label,
    this.labelPosition = RGSwitchLabelPosition.start,
    this.enabled = true,
  });

  // MARK: - Properties

  /// Whether the switch is on.
  final bool value;

  /// Called with the new value on toggle. Null disables the switch.
  final ValueChanged<bool>? onChanged;

  /// Optional copy shown beside the control.
  final String? label;

  /// Side the [label] sits on; defaults to [RGSwitchLabelPosition.start].
  final RGSwitchLabelPosition labelPosition;

  /// When false, dims the control and blocks toggling.
  final bool enabled;

  // MARK: - Build

  @override
  Widget build(BuildContext context) {
    final isDisabled = !enabled || onChanged == null;
    final control = Switch(
      value: value,
      onChanged: isDisabled ? null : onChanged,
    );

    if (label == null) return control;

    final scheme = Theme.of(context).colorScheme;
    final ink = isDisabled
        ? scheme.onSurface.withValues(alpha: 0.38)
        : scheme.onSurface;
    final text = Expanded(child: RGText.body(label!, color: ink));

    final children = labelPosition == RGSwitchLabelPosition.start
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
