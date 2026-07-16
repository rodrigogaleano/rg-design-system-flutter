import 'package:flutter/material.dart';

import 'package:rg_design_system/src/theme/token_extensions.dart';
import 'package:rg_design_system/src/tokens/spacing.dart';
import 'package:rg_design_system/src/tokens/typography.dart';

/// Visual emphasis of an [RGButton], named after the Material 3 button types.
enum RGButtonVariant {
  /// Solid fill; the primary action on a view.
  filled,

  /// Soft container fill; a secondary action with less weight.
  tonal,

  /// Outlined with a transparent fill; a tertiary action.
  outline,

  /// No fill or border, label only; the lowest-emphasis action.
  text,
}

/// Size of an [RGButton]; drives height, padding, label style, and icon size.
enum RGButtonSize {
  /// Compact height for dense layouts and action bars.
  small,

  /// Default size for most call sites.
  medium,

  /// Prominent height for hero CTAs.
  large,
}

/// Button for the RG Design System.
///
/// Built on Material's button machinery so interaction states (hover, focus,
/// pressed, disabled), ripple, keyboard focus, and accessibility come for free.
/// Every visual is driven by a [ButtonStyle] derived from the active
/// [ColorScheme] and the spacing/radius tokens, keeping the monochromatic system
/// intact. Set [isDestructive] to recolor the button from the theme's error
/// token for dangerous actions like deleting an account.
///
/// A `null` [onPressed] disables the button.
class RGButton extends StatelessWidget {
  // MARK: - Variants

  /// Solid fill; the primary action on a view.
  const RGButton.filled(
    this.label, {
    required this.onPressed,
    super.key,
    this.size = RGButtonSize.medium,
    this.isDestructive = false,
    this.leading,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.fullWidth = false,
  }) : variant = RGButtonVariant.filled,
       icon = null,
       tooltip = null;

  /// Soft container fill; a secondary action with less weight.
  const RGButton.tonal(
    this.label, {
    required this.onPressed,
    super.key,
    this.size = RGButtonSize.medium,
    this.isDestructive = false,
    this.leading,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.fullWidth = false,
  }) : variant = RGButtonVariant.tonal,
       icon = null,
       tooltip = null;

  /// Outlined with a transparent fill; a tertiary action.
  const RGButton.outline(
    this.label, {
    required this.onPressed,
    super.key,
    this.size = RGButtonSize.medium,
    this.isDestructive = false,
    this.leading,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.fullWidth = false,
  }) : variant = RGButtonVariant.outline,
       icon = null,
       tooltip = null;

  /// No fill or border, label only; the lowest-emphasis action.
  const RGButton.text(
    this.label, {
    required this.onPressed,
    super.key,
    this.size = RGButtonSize.medium,
    this.isDestructive = false,
    this.leading,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.fullWidth = false,
  }) : variant = RGButtonVariant.text,
       icon = null,
       tooltip = null;

  // MARK: - Icon-only

  /// Square button showing a single icon.
  ///
  /// [tooltip] is required: it labels the button for screen readers and shows
  /// on hover/long-press, since there is no visible text. Choose the [variant]
  /// to match the surrounding emphasis.
  const RGButton.icon({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    super.key,
    this.variant = RGButtonVariant.filled,
    this.size = RGButtonSize.medium,
    this.isDestructive = false,
    this.isLoading = false,
  }) : label = null,
       leading = null,
       leadingIcon = null,
       trailingIcon = null,
       fullWidth = false;

  // MARK: - Properties

  /// The button text. Null for the icon-only constructor.
  final String? label;

  /// Called on tap. Null disables the button.
  final VoidCallback? onPressed;

  /// The button size; defaults to [RGButtonSize.medium].
  final RGButtonSize size;

  /// When true, recolors the button from the theme's error token to signal a
  /// dangerous action.
  final bool isDestructive;

  /// Widget shown before the label; takes precedence over [leadingIcon] and
  /// inherits its color from the button's [IconTheme].
  final Widget? leading;

  /// Icon shown before the label.
  final IconData? leadingIcon;

  /// Icon shown after the label.
  final IconData? trailingIcon;

  /// When true, swaps the content for a spinner and blocks taps.
  final bool isLoading;

  /// When true, the button expands to fill the available width.
  final bool fullWidth;

  /// The visual variant; set by the chosen constructor.
  final RGButtonVariant variant;

  /// The glyph for [RGButton.icon]; null for the label variants.
  final IconData? icon;

  /// The accessibility label and hover hint for [RGButton.icon].
  final String? tooltip;

  bool get _isIconOnly => icon != null;

  // MARK: - Build

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final spec = _spec();
    final palette = _palette(scheme);
    final isDisabled = onPressed == null;

    // The spinner follows the disabled ink when the button is disabled, so a
    // disabled-while-loading button reads consistently.
    final spinnerColor = isDisabled
        ? scheme.onSurface.withValues(alpha: 0.38)
        : palette.foreground;

    final style = _buttonStyle(context, spec, scheme, palette);
    final content = _content(spec, spinnerColor);

    // Loading keeps the enabled look but must not fire. Swapping to a no-op
    // blocks both pointer and keyboard activation, which AbsorbPointer alone
    // would miss, while keeping the colors bright.
    final effectiveOnPressed = isLoading && !isDisabled ? () {} : onPressed;

    Widget button = TextButton(
      onPressed: effectiveOnPressed,
      style: style,
      child: content,
    );

    if (_isIconOnly) button = Tooltip(message: tooltip, child: button);

    if (fullWidth) button = SizedBox(width: double.infinity, child: button);

    // Merge into the button's own node so its tap action and role survive while
    // the control reads as one. Icon-only buttons borrow the tooltip as label.
    return MergeSemantics(
      child: Semantics(
        label: _isIconOnly ? tooltip : null,
        child: button,
      ),
    );
  }

  // MARK: - Content

  Widget _content(_SizeSpec spec, Color foreground) {
    final Widget body;
    if (_isIconOnly) {
      body = Icon(icon, size: spec.iconSize);
    } else {
      body = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leading != null) ...[
            leading!,
            SizedBox(width: spec.gap),
          ] else if (leadingIcon != null) ...[
            Icon(leadingIcon, size: spec.iconSize),
            SizedBox(width: spec.gap),
          ],
          Flexible(child: Text(label!, overflow: TextOverflow.ellipsis)),
          if (trailingIcon != null) ...[
            SizedBox(width: spec.gap),
            Icon(trailingIcon, size: spec.iconSize),
          ],
        ],
      );
    }

    if (!isLoading) return body;

    // Keep the resting width by laying the spinner over an invisible copy of
    // the content.
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(opacity: 0, child: body),
        SizedBox(
          width: spec.iconSize,
          height: spec.iconSize,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(foreground),
          ),
        ),
      ],
    );
  }

  // MARK: - Style

  ButtonStyle _buttonStyle(
    BuildContext context,
    _SizeSpec spec,
    ColorScheme scheme,
    _Palette palette,
  ) {
    final disabledForeground = scheme.onSurface.withValues(alpha: 0.38);
    final disabledFill = scheme.onSurface.withValues(alpha: 0.12);
    final radius = BorderRadius.circular(context.radius.md);

    final minimumSize = _isIconOnly
        ? Size(spec.height, spec.height)
        : Size(0, spec.height);
    final padding = _isIconOnly
        ? EdgeInsets.zero
        : EdgeInsets.symmetric(horizontal: spec.padX);

    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return palette.background == null ? null : disabledFill;
        }
        return palette.background;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return disabledForeground;
        return palette.foreground;
      }),
      iconColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return disabledForeground;
        return palette.foreground;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return palette.foreground.withValues(alpha: 0.12);
        }
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return palette.foreground.withValues(alpha: 0.08);
        }
        return null;
      }),
      side: WidgetStateProperty.resolveWith((states) {
        if (palette.border == null) return BorderSide.none;
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(color: disabledFill);
        }
        return BorderSide(color: palette.border!);
      }),
      textStyle: WidgetStatePropertyAll<TextStyle>(spec.textStyle),
      iconSize: WidgetStatePropertyAll<double>(spec.iconSize),
      minimumSize: WidgetStatePropertyAll<Size>(minimumSize),
      padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(padding),
      shape: WidgetStatePropertyAll<OutlinedBorder>(
        RoundedRectangleBorder(borderRadius: radius),
      ),
      elevation: const WidgetStatePropertyAll<double>(0),
      shadowColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      surfaceTintColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  // MARK: - Palette

  _Palette _palette(ColorScheme scheme) {
    if (isDestructive) {
      return switch (variant) {
        RGButtonVariant.filled => _Palette(
          background: scheme.error,
          foreground: scheme.onError,
        ),
        RGButtonVariant.tonal => _Palette(
          background: scheme.error.withValues(alpha: 0.12),
          foreground: scheme.error,
        ),
        RGButtonVariant.outline => _Palette(
          foreground: scheme.error,
          border: scheme.error,
        ),
        RGButtonVariant.text => _Palette(foreground: scheme.error),
      };
    }

    return switch (variant) {
      RGButtonVariant.filled => _Palette(
        background: scheme.primary,
        foreground: scheme.onPrimary,
      ),
      RGButtonVariant.tonal => _Palette(
        background: scheme.secondaryContainer,
        foreground: scheme.onSecondaryContainer,
      ),
      RGButtonVariant.outline => _Palette(
        foreground: scheme.onSurface,
        border: scheme.outline,
      ),
      RGButtonVariant.text => _Palette(foreground: scheme.onSurface),
    };
  }

  // MARK: - Sizing

  _SizeSpec _spec() {
    return switch (size) {
      RGButtonSize.small => _SizeSpec(
        height: 36,
        padX: RGSpacing.md,
        textStyle: RGTextStyles.bodyS,
        iconSize: 16,
        gap: RGSpacing.xs,
      ),
      RGButtonSize.medium => _SizeSpec(
        height: 44,
        padX: RGSpacing.lg,
        textStyle: RGTextStyles.body,
        iconSize: 20,
        gap: RGSpacing.sm,
      ),
      RGButtonSize.large => _SizeSpec(
        height: 52,
        padX: RGSpacing.xl,
        textStyle: RGTextStyles.bodyL,
        iconSize: 24,
        gap: RGSpacing.sm,
      ),
    };
  }
}

/// Resolved colors for a variant in its enabled state.
@immutable
class _Palette {
  const _Palette({required this.foreground, this.background, this.border});

  /// Fill color, or null for transparent variants.
  final Color? background;

  /// Text and icon color.
  final Color foreground;

  /// Border color, or null when the variant has no outline.
  final Color? border;
}

/// Resolved metrics for a [RGButtonSize].
@immutable
class _SizeSpec {
  const _SizeSpec({
    required this.height,
    required this.padX,
    required this.textStyle,
    required this.iconSize,
    required this.gap,
  });

  /// Fixed button height.
  final double height;

  /// Horizontal padding for label buttons.
  final double padX;

  /// Label text style.
  final TextStyle textStyle;

  /// Icon and spinner size.
  final double iconSize;

  /// Space between icon and label.
  final double gap;
}
