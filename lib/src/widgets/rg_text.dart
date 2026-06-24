import 'package:flutter/material.dart';

import 'package:rg_design_system/src/tokens/typography.dart';

/// Semantic text widget for the RG Design System.
///
/// Wraps [Text] and binds each named constructor to a single token from
/// [RGTextStyles], so call sites read as intent (`RGText.h1`) instead of
/// reaching into `Theme.of(context).textTheme`. The token styles bake in black
/// ink; [RGText] resolves the color from the active [ColorScheme] instead, so
/// text follows the surface in light and dark without per-call wiring.
class RGText extends StatelessWidget {
  // MARK: - Display

  /// Hero numbers and oversized statement headlines. Use once per view.
  RGText.display(
    this.data, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _baseStyle = RGTextStyles.display;

  // MARK: - Headings

  /// Primary page title; the largest heading in normal content flow.
  RGText.h1(
    this.data, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _baseStyle = RGTextStyles.h1;

  /// Major section heading.
  RGText.h2(
    this.data, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _baseStyle = RGTextStyles.h2;

  /// Subsection heading.
  RGText.h3(
    this.data, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _baseStyle = RGTextStyles.h3;

  /// Smallest heading; card titles and list-group labels.
  RGText.h4(
    this.data, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _baseStyle = RGTextStyles.h4;

  // MARK: - Body

  /// Large body copy; lead paragraphs and comfortable reading contexts.
  RGText.bodyL(
    this.data, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _baseStyle = RGTextStyles.bodyL;

  /// Default body text for most UI.
  RGText.body(
    this.data, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _baseStyle = RGTextStyles.body;

  /// Small body copy; secondary descriptions and dense layouts.
  RGText.bodyS(
    this.data, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _baseStyle = RGTextStyles.bodyS;

  // MARK: - Supporting

  /// Captions, metadata, and timestamps beneath content.
  RGText.caption(
    this.data, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _baseStyle = RGTextStyles.caption;

  /// Uppercase eyebrow labels and section kickers; tracked wide for legibility.
  RGText.overline(
    this.data, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _baseStyle = RGTextStyles.overline;

  /// Smallest token; legal lines, fine print, and dense annotations.
  RGText.micro(
    this.data, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
  }) : _baseStyle = RGTextStyles.micro;

  // MARK: - Properties

  /// The string to display.
  final String data;

  /// Overrides the resolved ink; defaults to [ColorScheme.onSurface].
  final Color? color;

  /// How the text is aligned horizontally. See [Text.textAlign].
  final TextAlign? textAlign;

  /// The maximum number of lines before truncation. See [Text.maxLines].
  final int? maxLines;

  /// How overflowing text is handled. See [Text.overflow].
  final TextOverflow? overflow;

  /// Merged over the token style for one-off tweaks without losing the base.
  final TextStyle? style;

  /// The token style backing the chosen constructor.
  final TextStyle _baseStyle;

  // MARK: - Build

  @override
  Widget build(BuildContext context) {
    final merged = _baseStyle.merge(style);

    // Resolve ink explicitly so the token's baked-in black never leaks through:
    // an explicit [color] wins, then any color from [style], then the surface.
    final ink =
        color ?? style?.color ?? Theme.of(context).colorScheme.onSurface;

    return Text(
      data,
      style: merged.copyWith(color: ink),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
