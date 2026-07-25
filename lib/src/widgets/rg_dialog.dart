import 'package:flutter/material.dart';

import 'package:rg_design_system/src/theme/token_extensions.dart';
import 'package:rg_design_system/src/tokens/spacing.dart';
import 'package:rg_design_system/src/widgets/rg_button.dart';
import 'package:rg_design_system/src/widgets/rg_text.dart';

/// Width the dialog stops growing at, keeping the copy in a readable measure.
const double _maxWidth = 460;

/// Modal dialog for the RG Design System.
///
/// Provides the shared shell (constrained width, padding, title, body, and a
/// trailing action row) and leaves [content] and [actions] to the caller, so a
/// confirmation and a form dialog read the same. Built on Material's [Dialog],
/// so the barrier, dismissal, and focus trap come for free, but flat instead of
/// elevated: the surface is [ColorScheme.surface] with an [ColorScheme.outline]
/// border and square corners, matching the rest of the system.
///
/// Every string arrives by parameter; the component holds no copy of its own.
/// Open it with [showRGDialog].
class RGDialog extends StatelessWidget {
  // MARK: - Constructors

  /// Dialog with an arbitrary body and action row.
  const RGDialog({
    required this.title,
    required Widget this.content,
    required List<Widget> this.actions,
    super.key,
    this.maxWidth = _maxWidth,
  }) : message = null,
       confirmLabel = null,
       cancelLabel = null,
       isDestructive = false;

  /// Confirmation dialog: a line of body copy over a cancel and a confirm
  /// button.
  ///
  /// Pops `true` on confirm and `false` on cancel; dismissing through the
  /// barrier pops `null`. Set [isDestructive] to color the confirm button from
  /// the theme's error token.
  const RGDialog.confirm({
    required this.title,
    required String this.message,
    required String this.confirmLabel,
    required String this.cancelLabel,
    super.key,
    this.isDestructive = false,
    this.maxWidth = _maxWidth,
  }) : content = null,
       actions = null;

  // MARK: - Properties

  /// The heading shown at the top of the dialog.
  final String title;

  /// The body. Null for the confirm constructor, which builds it from
  /// [message].
  final Widget? content;

  /// The buttons in the trailing action row. Null for the confirm constructor,
  /// which builds the cancel and confirm pair itself.
  final List<Widget>? actions;

  /// The body copy for [RGDialog.confirm]; null for the default constructor.
  final String? message;

  /// The confirm button label for [RGDialog.confirm].
  final String? confirmLabel;

  /// The cancel button label for [RGDialog.confirm].
  final String? cancelLabel;

  /// When true, the confirm button reads as destructive.
  final bool isDestructive;

  /// The width the dialog stops growing at.
  final double maxWidth;

  // MARK: - Build

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final body =
        content ?? RGText.body(message!, color: scheme.onSurfaceVariant);
    final buttons = actions ?? _confirmActions(context);

    return Dialog(
      backgroundColor: scheme.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.radius.none),
        side: BorderSide(color: scheme.outline),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: const EdgeInsets.all(RGSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RGText.h4(title),
              const SizedBox(height: RGSpacing.md),
              body,
              const SizedBox(height: RGSpacing.lg),
              // Wraps to a second row when the labels are too long to sit side
              // by side at [maxWidth].
              Wrap(
                alignment: WrapAlignment.end,
                spacing: RGSpacing.sm,
                runSpacing: RGSpacing.sm,
                children: buttons,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // MARK: - Confirm actions

  List<Widget> _confirmActions(BuildContext context) => [
    RGButton.text(
      cancelLabel,
      onPressed: () => Navigator.of(context).pop(false),
    ),
    RGButton.filled(
      confirmLabel,
      onPressed: () => Navigator.of(context).pop(true),
      isDestructive: isDestructive,
    ),
  ];
}

/// Opens [dialog] as a modal route and resolves with the value it pops.
Future<T?> showRGDialog<T>(BuildContext context, {required Widget dialog}) =>
    showDialog<T>(context: context, builder: (_) => dialog);
