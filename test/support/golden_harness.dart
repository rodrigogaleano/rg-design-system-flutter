import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rg_design_system/rg_design_system.dart';

/// Shared scaffolding for the design system's golden ("specimen") tests.
///
/// Each component is captured as a single tall image per theme: a vertical
/// gallery of labeled sections that cover the full matrix of variants, sizes,
/// and states. The image is cropped to the content via a [RepaintBoundary], so
/// the surrounding test surface never leaks into the golden.

// MARK: - Layout constants

/// Width every gallery is laid out at; fixed so wrapping is deterministic.
const double _contentWidth = 480;

/// Generous surface so the tallest gallery never overflows; only the boundary
/// region is captured, so the slack is harmless.
const Size _surfaceSize = Size(640, 6000);

final GlobalKey _boundaryKey = GlobalKey();

// MARK: - Test registration

/// The reference PNGs are authored in the pinned Linux image (see the
/// `Makefile` and the CI workflow); font anti-aliasing differs on other
/// platforms, so a macOS or Windows run would drift and fail. Skip there
/// instead: goldens are verified in CI and regenerated with `make goldens`.
final bool _goldensSupported = Platform.isLinux;

/// Registers a light and a dark golden for [name], building the gallery body
/// with [builder]. Pass [interact] to drive the tree (taps, reveals) before the
/// frame is captured. Goldens land in `goldens/<name>.<brightness>.png`.
void goldenTest(
  String name, {
  required WidgetBuilder builder,
  Future<void> Function(WidgetTester tester)? interact,
}) {
  for (final brightness in Brightness.values) {
    final suffix = brightness == Brightness.light ? 'light' : 'dark';
    testWidgets(
      '$name ($suffix)',
      (tester) async {
        await _pumpGallery(tester, brightness: brightness, builder: builder);
        await interact?.call(tester);
        await tester.pump(const Duration(seconds: 1));

        await expectLater(
          find.byKey(_boundaryKey),
          matchesGoldenFile('goldens/$name.$suffix.png'),
        );
      },
      tags: 'golden',
      skip: !_goldensSupported,
    );
  }
}

// MARK: - Section helpers

/// A titled block within a gallery: an overline label above [content].
Widget gallerySection(String title, Widget content) => Padding(
  padding: const EdgeInsets.only(bottom: RGSpacing.xl),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: RGSpacing.md),
        child: RGText.overline(title.toUpperCase()),
      ),
      content,
    ],
  ),
);

/// A single specimen with a caption above it; the unit most sections repeat.
Widget specimen(String caption, Widget child) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Padding(
      padding: const EdgeInsets.only(bottom: RGSpacing.xs),
      child: RGText.caption(caption),
    ),
    child,
  ],
);

// MARK: - Pump

Future<void> _pumpGallery(
  WidgetTester tester, {
  required Brightness brightness,
  required WidgetBuilder builder,
}) async {
  await tester.binding.setSurfaceSize(_surfaceSize);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  final theme = brightness == Brightness.light ? RGTheme.light : RGTheme.dark;

  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: Scaffold(
        body: Center(
          child: RepaintBoundary(
            key: _boundaryKey,
            child: Builder(
              builder: (context) => ColoredBox(
                color: Theme.of(context).colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(RGSpacing.xl),
                  child: SizedBox(
                    width: _contentWidth,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [builder(context)],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  // One build frame; the trailing pump in [goldenTest] advances short
  // animations (floating labels) to their end and lands the spinner on a
  // fixed, reproducible frame. Never pumpAndSettle: the loading spinner spins
  // forever and would time out.
  await tester.pump();
}
