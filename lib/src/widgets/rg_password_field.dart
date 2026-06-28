import 'package:flutter/material.dart';

import 'package:rg_design_system/src/widgets/rg_text_field.dart';

/// Password input for the RG Design System.
///
/// Wraps [RGTextField] and owns the obscure state, swapping a reveal toggle in
/// the suffix so the value can be shown or hidden. Single line and masked by
/// default. Pick the look via [RGPasswordField.outlined] or
/// [RGPasswordField.filled].
class RGPasswordField extends StatefulWidget {
  // MARK: - Variants

  /// Outlined box with a transparent fill; the default field.
  const RGPasswordField.outlined({
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
    this.textInputAction,
    this.prefixIcon,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
  }) : variant = RGTextFieldVariant.outlined;

  /// Soft container fill with a bottom underline.
  const RGPasswordField.filled({
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
    this.textInputAction,
    this.prefixIcon,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
  }) : variant = RGTextFieldVariant.filled;

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

  /// The keyboard action button (next, done, search).
  final TextInputAction? textInputAction;

  /// Glyph shown before the input.
  final IconData? prefixIcon;

  /// Caps the character count and shows a counter.
  final int? maxLength;

  /// When false, dims the field and blocks editing and focus.
  final bool enabled;

  /// When true, shows the value but blocks editing while keeping focus.
  final bool readOnly;

  /// Requests focus as soon as the field mounts.
  final bool autofocus;

  /// An external focus node, when the caller needs to drive focus.
  final FocusNode? focusNode;

  @override
  State<RGPasswordField> createState() => _RGPasswordFieldState();
}

class _RGPasswordFieldState extends State<RGPasswordField> {
  // MARK: - State

  /// Whether the value is masked; toggled by the suffix.
  bool _obscured = true;

  void _toggle() => setState(() => _obscured = !_obscured);

  // MARK: - Build

  @override
  Widget build(BuildContext context) {
    final suffixIcon = _obscured ? Icons.visibility_off : Icons.visibility;
    final suffixTooltip = _obscured ? 'Show password' : 'Hide password';

    switch (widget.variant) {
      case RGTextFieldVariant.outlined:
        return RGTextField.outlined(
          controller: widget.controller,
          initialValue: widget.initialValue,
          label: widget.label,
          hint: widget.hint,
          helperText: widget.helperText,
          errorText: widget.errorText,
          validator: widget.validator,
          autovalidateMode: widget.autovalidateMode,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          obscureText: _obscured,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: widget.textInputAction,
          maxLength: widget.maxLength,
          prefixIcon: widget.prefixIcon,
          suffixIcon: suffixIcon,
          onSuffixTap: _toggle,
          suffixTooltip: suffixTooltip,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          focusNode: widget.focusNode,
        );
      case RGTextFieldVariant.filled:
        return RGTextField.filled(
          controller: widget.controller,
          initialValue: widget.initialValue,
          label: widget.label,
          hint: widget.hint,
          helperText: widget.helperText,
          errorText: widget.errorText,
          validator: widget.validator,
          autovalidateMode: widget.autovalidateMode,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          obscureText: _obscured,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: widget.textInputAction,
          maxLength: widget.maxLength,
          prefixIcon: widget.prefixIcon,
          suffixIcon: suffixIcon,
          onSuffixTap: _toggle,
          suffixTooltip: suffixTooltip,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          focusNode: widget.focusNode,
        );
    }
  }
}
