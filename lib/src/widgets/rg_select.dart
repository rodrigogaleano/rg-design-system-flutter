import 'package:flutter/material.dart';

import 'package:rg_design_system/src/theme/token_extensions.dart';
import 'package:rg_design_system/src/tokens/spacing.dart';
import 'package:rg_design_system/src/tokens/typography.dart';
import 'package:rg_design_system/src/widgets/rg_text.dart';

/// A single choice within an [RGSelect].
///
/// Pairs the typed [value] returned on selection with the [label] shown to the
/// user, so callers keep working with their own type instead of strings.
class RGSelectOption<T> {
  /// Creates an option mapping [value] to its display [label].
  const RGSelectOption({required this.value, required this.label});

  /// The value handed back through [RGSelect.onChanged] when picked.
  final T value;

  /// The copy shown for this option in the trigger and the panel.
  final String label;
}

/// Single-select dropdown for the RG Design System.
///
/// Wraps Material's [MenuAnchor] so tap-outside dismissal, keyboard traversal,
/// and focus come for free, with every visual resolved from the active
/// [ColorScheme] to stay monochromatic. The trigger shows the selected option
/// (or [hint] when [value] is null) with a chevron that flips while open; the
/// panel drops directly beneath it, the selected row bold and checked. A null
/// [onChanged] disables the control.
class RGSelect<T> extends StatefulWidget {
  // MARK: - Constructor

  /// Creates a select reflecting [value] over [options].
  const RGSelect({
    required this.value,
    required this.options,
    required this.onChanged,
    super.key,
    this.label,
    this.hint,
  });

  // MARK: - Properties

  /// The currently selected value; null shows the [hint] placeholder.
  final T? value;

  /// The choices offered in the panel.
  final List<RGSelectOption<T>> options;

  /// Called with the picked value. Null disables the select.
  final ValueChanged<T>? onChanged;

  /// Optional caption shown above the trigger.
  final String? label;

  /// Placeholder shown in the trigger while nothing is selected.
  final String? hint;

  @override
  State<RGSelect<T>> createState() => _RGSelectState<T>();
}

class _RGSelectState<T> extends State<RGSelect<T>> {
  // Fixed trigger and row height; Material's default minimum touch target.
  static const double _rowHeight = 44;

  final MenuController _controller = MenuController();
  bool _open = false;

  bool get _isDisabled => widget.onChanged == null;

  // The option matching the current value, or null when unmatched or empty.
  RGSelectOption<T>? get _selected {
    for (final option in widget.options) {
      if (option.value == widget.value) return option;
    }
    return null;
  }

  void _toggle() {
    if (_controller.isOpen) {
      _controller.close();
    } else {
      _controller.open();
    }
  }

  void _pick(T value) {
    widget.onChanged!(value);
    _controller.close();
  }

  // MARK: - Build

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // The panel matches the trigger width, so read the available width and feed
    // it to the menu's min and max size.
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final trigger = MergeSemantics(
          child: MenuAnchor(
            controller: _controller,
            onOpen: () => setState(() => _open = true),
            onClose: () => setState(() => _open = false),
            alignmentOffset: const Offset(0, RGSpacing.xs),
            style: _panelStyle(scheme, width),
            menuChildren: [
              for (final option in widget.options)
                _optionItem(scheme, option, width),
            ],
            builder: (context, controller, child) => _trigger(context, scheme),
          ),
        );

        if (widget.label == null) return trigger;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RGText.caption(widget.label!, color: scheme.onSurfaceVariant),
            const SizedBox(height: RGSpacing.xs),
            trigger,
          ],
        );
      },
    );
  }

  // MARK: - Trigger

  Widget _trigger(BuildContext context, ColorScheme scheme) {
    final selected = _selected;
    final hasValue = selected != null;

    final Color ink;
    if (_isDisabled) {
      ink = scheme.onSurface.withValues(alpha: 0.38);
    } else if (hasValue) {
      ink = scheme.onSurface;
    } else {
      ink = scheme.onSurfaceVariant;
    }

    final Color border;
    if (_isDisabled) {
      border = scheme.onSurface.withValues(alpha: 0.12);
    } else if (_open) {
      border = scheme.onSurface;
    } else {
      border = scheme.outline;
    }

    return InkWell(
      onTap: _isDisabled ? null : _toggle,
      borderRadius: BorderRadius.circular(context.radius.none),
      child: Container(
        height: _rowHeight,
        padding: const EdgeInsets.symmetric(horizontal: RGSpacing.md),
        decoration: BoxDecoration(
          color: scheme.surface,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(context.radius.none),
        ),
        child: Row(
          children: [
            Expanded(
              child: RGText.body(
                selected?.label ?? widget.hint ?? '',
                color: ink,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: RGSpacing.sm),
            AnimatedRotation(
              turns: _open ? 0.5 : 0,
              duration: const Duration(milliseconds: 120),
              child: Icon(Icons.keyboard_arrow_down, size: 20, color: ink),
            ),
          ],
        ),
      ),
    );
  }

  // MARK: - Panel

  MenuStyle _panelStyle(ColorScheme scheme, double width) => MenuStyle(
    backgroundColor: WidgetStatePropertyAll(scheme.surface),
    // Flat and editorial: the border carries the edge, not a shadow.
    elevation: const WidgetStatePropertyAll(0),
    padding: const WidgetStatePropertyAll(EdgeInsets.zero),
    minimumSize: WidgetStatePropertyAll(Size(width, 0)),
    maximumSize: WidgetStatePropertyAll(Size(width, double.infinity)),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.radius.none),
        side: BorderSide(color: scheme.outline),
      ),
    ),
  );

  Widget _optionItem(
    ColorScheme scheme,
    RGSelectOption<T> option,
    double width,
  ) {
    final isSelected = option.value == widget.value;
    final weight = isSelected ? FontWeight.w700 : FontWeight.w400;
    final ink = isSelected ? scheme.onSurface : scheme.onSurfaceVariant;

    return MenuItemButton(
      onPressed: () => _pick(option.value),
      trailingIcon: isSelected
          ? Icon(Icons.check, size: 20, color: scheme.onSurface)
          : null,
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size(width, _rowHeight)),
        backgroundColor: WidgetStatePropertyAll(
          isSelected ? scheme.surfaceContainer : Colors.transparent,
        ),
        foregroundColor: WidgetStatePropertyAll(ink),
        textStyle: WidgetStatePropertyAll(
          RGTextStyles.body.copyWith(fontWeight: weight),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: RGSpacing.md),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.radius.none),
          ),
        ),
      ),
      child: Text(option.label),
    );
  }
}
