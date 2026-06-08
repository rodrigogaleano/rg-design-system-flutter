# RG Design System

Personal Flutter design system by Rodrigo Galeano. A single source of truth
for the design tokens, themes, and UI components I use across my Flutter portfolio.

## Philosophy

Editorial minimalism. Typography-first. Hierarchy through size and weight, never colour.
Inspired by Gil Huybrecht, Dieter Rams, and Swiss International Style.

Palette: `#000000` and `#FFFFFF`. Font: Helvetica Neue. Base unit: 4pt.

## What's inside

- **Tokens:** colors, typography scale, spacing, and border radius
- **Theme:** light and dark `ThemeData`
- **Components:** reusable widgets built on top of the tokens

## Usage

Add to your `pubspec.yaml`:

```yaml
dependencies:
  rg_design_system:
    git:
      url: https://github.com/rodrigogaleano/rg-design-system-flutter.git
      ref: main
```

Import:

```dart
import 'package:rg_design_system/rg_design_system.dart';
```
