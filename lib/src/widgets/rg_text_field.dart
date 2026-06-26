import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:rg_design_system/src/theme/token_extensions.dart';
import 'package:rg_design_system/src/tokens/typography.dart';

/// Visual treatment of an [RGTextField].
enum RGTextFieldVariant {
  /// Outlined box with a transparent fill; the default, rectangular look.
  outlined,

  /// Soft container fill with a bottom underline; lower-emphasis surface.
  filled,
}

/// Text input for the RG Design System.
///
/// Wraps [TextFormField] so it drops into a [Form] and validates, with every
/// visual resolved from the [ColorScheme] and tokens. Error is the only
/// non-mono color. Pick the look via [RGTextField.outlined] or
/// [RGTextField.filled].
class RGTextField extends StatelessWidget {
  // MARK: - Variants

  /// Outlined box with a transparent fill; the default field.
  const RGTextField.outlined({
    super.key,
    this.controller,
    this.initialValue,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.validator,
    this.autovalidateMode,
    this.onChanged,
    this.onFieldSubmitted,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.suffixTooltip,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
  }) : variant = RGTextFieldVariant.outlined,
       assert(
         onSuffixTap == null || suffixIcon != null,
         'onSuffixTap needs a suffixIcon to attach to',
       ),
       assert(
         onSuffixTap == null || suffixTooltip != null,
         'A tappable suffix needs a suffixTooltip for screen readers',
       );

  /// Soft container fill with a bottom underline.
  const RGTextField.filled({
    super.key,
    this.controller,
    this.initialValue,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.validator,
    this.autovalidateMode,
    this.onChanged,
    this.onFieldSubmitted,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.suffixTooltip,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
  }) : variant = RGTextFieldVariant.filled,
       assert(
         onSuffixTap == null || suffixIcon != null,
         'onSuffixTap needs a suffixIcon to attach to',
       ),
       assert(
         onSuffixTap == null || suffixTooltip != null,
         'A tappable suffix needs a suffixTooltip for screen readers',
       );

  // MARK: - Properties

  /// The visual variant; set by the chosen constructor.
  final RGTextFieldVariant variant;

  /// Controls the text being edited. Mutually exclusive with [initialValue].
  final TextEditingController? controller;

  /// Seeds the field when no [controller] is supplied.
  final String? initialValue;

  /// Floating label shown inside the field and lifted on focus or input.
  final String? label;

  /// Placeholder shown while the field is empty.
  final String? hint;

  /// Supporting copy beneath the field; hidden while an error shows.
  final String? helperText;

  /// Shows an error directly; a failing [validator] overrides it.
  final String? errorText;

  /// Validates the value within a [Form]; return null when valid.
  final FormFieldValidator<String>? validator;

  /// When the field revalidates. Defaults to [AutovalidateMode.disabled].
  final AutovalidateMode? autovalidateMode;

  /// Called on every keystroke with the current value.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits from the keyboard.
  final ValueChanged<String>? onFieldSubmitted;

  /// Masks the input for passwords and secrets.
  final bool obscureText;

  /// Keyboard layout hint (email, number, and so on).
  final TextInputType? keyboardType;

  /// The keyboard action button (next, done, search).
  final TextInputAction? textInputAction;

  /// Auto-capitalization behavior for the keyboard.
  final TextCapitalization textCapitalization;

  /// Filters and transforms input as the user types.
  final List<TextInputFormatter>? inputFormatters;

  /// Maximum visible lines; raise it (with [minLines]) for multiline fields.
  final int? maxLines;

  /// Minimum visible lines for multiline fields.
  final int? minLines;

  /// Caps the character count and shows a counter.
  final int? maxLength;

  /// Glyph shown before the input.
  final IconData? prefixIcon;

  /// Glyph shown after the input; pair with [onSuffixTap] to make it tappable.
  final IconData? suffixIcon;

  /// Tap handler for [suffixIcon], for clear or reveal affordances.
  final VoidCallback? onSuffixTap;

  /// Accessibility label and hover hint for a tappable [suffixIcon].
  final String? suffixTooltip;

  /// When false, dims the field and blocks editing and focus.
  final bool enabled;

  /// When true, shows the value but blocks editing while keeping focus.
  final bool readOnly;

  /// Requests focus as soon as the field mounts.
  final bool autofocus;

  /// An external focus node, when the caller needs to drive focus.
  final FocusNode? focusNode;

  // MARK: - Build

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      maxLines: obscureText ? 1 : maxLines,
      minLines: minLines,
      maxLength: maxLength,
      validator: validator,
      autovalidateMode: autovalidateMode,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      style: RGTextStyles.body.copyWith(color: scheme.onSurface),
      cursorColor: scheme.onSurface,
      decoration: _decoration(context, scheme),
    );
  }

  // MARK: - Decoration

  /// Content only; borders, colors, padding and styles come from the theme's
  /// [InputDecorationThemeData]. The filled variant layers on its fill and
  /// underline, which deviate from the themed outlined default.
  InputDecoration _decoration(BuildContext context, ColorScheme scheme) {
    final content = InputDecoration(
      labelText: label,
      hintText: hint,
      helperText: helperText,
      errorText: errorText,
      prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
      suffixIcon: _suffix(),
    );

    if (variant == RGTextFieldVariant.outlined) return content;

    final radius = BorderRadius.vertical(
      top: Radius.circular(context.radius.sm),
    );
    return content.copyWith(
      filled: true,
      fillColor: scheme.surfaceContainerLow,
      enabledBorder: _filledBorder(radius, scheme.outline),
      focusedBorder: _filledBorder(radius, scheme.onSurface, width: 2),
      errorBorder: _filledBorder(radius, scheme.error),
      focusedErrorBorder: _filledBorder(radius, scheme.error, width: 2),
      disabledBorder: _filledBorder(
        radius,
        scheme.onSurface.withValues(alpha: 0.12),
      ),
      border: _filledBorder(radius, scheme.outline),
    );
  }

  Widget? _suffix() {
    if (suffixIcon == null) return null;
    if (onSuffixTap == null) return Icon(suffixIcon);
    return IconButton(
      icon: Icon(suffixIcon),
      onPressed: enabled ? onSuffixTap : null,
      tooltip: suffixTooltip,
    );
  }

  UnderlineInputBorder _filledBorder(
    BorderRadius radius,
    Color color, {
    double width = 1,
  }) => UnderlineInputBorder(
    borderRadius: radius,
    borderSide: BorderSide(color: color, width: width),
  );
}
