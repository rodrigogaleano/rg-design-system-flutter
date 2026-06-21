import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';
import 'package:rg_design_system_widgetbook/main.directories.g.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

void main() {
  runApp(const WidgetbookApp());
}

/// Catalog host for the RG Design System components.
///
/// The component tree (`directories`) is generated from the `@UseCase`
/// annotations across `lib/`. The theme addon binds the system's real
/// [RGTheme.light] and [RGTheme.dark], so toggling it exercises every widget's
/// color resolution exactly as the consuming app would.
@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: directories,
      addons: [
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(name: 'Light', data: RGTheme.light),
            WidgetbookTheme(name: 'Dark', data: RGTheme.dark),
          ],
        ),
      ],
    );
  }
}
