# RG Design System — Widgetbook

Visual catalog for the design system. Browse every component in isolation,
toggle between light and dark, and tweak content live through knobs.

This is a standalone Flutter app that depends on `rg_design_system` via a local
path, so the catalog tooling never leaks into the published package.

## Setup

The catalog targets the web, so it runs straight after a clone:

```bash
cd widgetbook
flutter pub get
```

## Run

```bash
flutter run -d chrome
```

Note on fonts: `Helvetica Neue` is declared by name only, so on Chrome the text
falls back to the system sans-serif. Layout, size, weight, and spacing are
faithful; to check the actual typeface, run the catalog on an Apple target where
the font resolves natively.

## Adding components

Use cases are generated from `@widgetbook.UseCase` annotations under `lib/`.
After adding or editing one, regenerate the directory tree:

```bash
dart run build_runner build      # one-off
dart run build_runner watch      # while iterating
```
