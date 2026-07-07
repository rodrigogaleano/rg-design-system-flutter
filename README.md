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
- **Widgetbook:** visual catalog of every component, see [`widgetbook/`](widgetbook/README.md)

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

## Testing

Behaviour is covered by widget tests, and appearance is locked down with
**golden tests**: each component is rendered into a reference PNG (in light and
dark) that the suite compares against on every run, so a stray padding or a
broken state is caught as a visual regression.

```bash
flutter test    # behaviour tests everywhere; goldens only on Linux (see below)
```

Golden images are pixel-sensitive to the environment that renders them: font
anti-aliasing differs between macOS and the Linux CI, which would make goldens
authored on one fail on the other. Rather than loosen the comparison until it
stops catching real regressions, the reference PNGs are generated **and**
verified inside a single pinned Flutter image (`ghcr.io/cirruslabs/flutter`,
same tag in the `Makefile` and the CI workflow). Same environment on both ends,
so the diff is deterministic and the goldens stay readable.

Because of that, the golden tests **skip automatically off Linux**, so
`flutter test` stays green on any machine; they are enforced in CI. Whenever a
visual change is intentional, regenerate the PNGs in the pinned image and review
them in the diff before pushing:

```bash
make goldens    # regenerate inside the pinned Docker image (needs Docker)
```

