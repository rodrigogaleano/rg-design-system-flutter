import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:rg_design_system/src/widgets/rg_button.dart';

/// Full-width social sign-in button for the RG Design System.
///
/// A thin wrapper over [RGButton.outline]: the outline variant owns every
/// visual (thin border, transparent fill, height, radius, disabled ink, overlay
/// states, and button semantics), while this widget adds the provider glyph on
/// the left and the intent-revealing named constructors. Glyphs inherit the
/// button's foreground through its [IconTheme] to keep the system's single-ink
/// identity, except where a provider's brand guidelines require their own
/// colors (e.g. the Google "G" keeps its standard multicolor mark).
///
/// A `null` [onPressed] disables the button.
class RGSocialButton extends StatelessWidget {
  // MARK: - Generic

  /// Sign-in button for any provider; supply the [icon] glyph yourself.
  const RGSocialButton({
    required this.icon,
    required this.label,
    this.onPressed,
    super.key,
    this.fullWidth = true,
  });

  // MARK: - Providers

  /// Sign-in button for Google, with the Google glyph embedded.
  const RGSocialButton.google({
    required this.label,
    this.onPressed,
    super.key,
    this.fullWidth = true,
  }) : icon = const _SocialGlyph(_kGoogleAsset, preserveColor: true);

  /// Sign-in button for Apple, with the Apple glyph embedded.
  const RGSocialButton.apple({
    required this.label,
    this.onPressed,
    super.key,
    this.fullWidth = true,
  }) : icon = const _SocialGlyph(_kAppleAsset);

  // MARK: - Properties

  /// The provider glyph shown before the label.
  final Widget icon;

  /// The button text, e.g. "Continuar com Google".
  final String label;

  /// Called on tap. Null disables the button.
  final VoidCallback? onPressed;

  /// When true, the button fills the available width; defaults to true.
  final bool fullWidth;

  // MARK: - Build

  @override
  Widget build(BuildContext context) {
    return RGButton.outline(
      label,
      onPressed: onPressed,
      fullWidth: fullWidth,
      leading: icon,
    );
  }
}

// MARK: - Glyph

/// Renders a provider SVG at the glyph size.
///
/// By default the glyph is tinted with the current [IconTheme] color, so it
/// follows the button's enabled and disabled foreground and stays within the
/// system's single-ink identity. Set [preserveColor] for providers whose brand
/// guidelines forbid recoloring (e.g. the Google "G", which must keep its
/// standard multicolor mark); the glyph then renders with its own colors.
class _SocialGlyph extends StatelessWidget {
  const _SocialGlyph(this.asset, {this.preserveColor = false});

  final String asset;

  /// When true, the SVG keeps its own colors instead of the button's ink.
  final bool preserveColor;

  @override
  Widget build(BuildContext context) {
    final color = IconTheme.of(context).color;
    return SvgPicture.asset(
      asset,
      package: 'rg_design_system',
      width: _kGlyphSize,
      height: _kGlyphSize,
      colorFilter: preserveColor || color == null
          ? null
          : ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}

/// Glyph edge; sits between the icon sizes of the medium button (18-20).
const double _kGlyphSize = 18;

const String _kGoogleAsset = 'assets/social/google.svg';
const String _kAppleAsset = 'assets/social/apple.svg';
