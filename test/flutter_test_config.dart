import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Global test setup, picked up automatically for every test under `test/`.
///
/// Installs a golden comparator that tolerates a tiny pixel difference. Text is
/// already deterministic across machines because `flutter_test` renders every
/// glyph with its own bundled font; what still drifts between macOS (where the
/// goldens are authored) and the Linux CI is the anti-aliasing of vector shapes
/// (borders, the loading spinner, the switch track). The tolerance absorbs that
/// sub-pixel noise so the build only fails on real visual regressions.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final local = goldenFileComparator as LocalFileComparator;
  goldenFileComparator = _TolerantGoldenComparator(local.basedir);
  await testMain();
}

/// Share of pixels (0..1) allowed to differ before a golden is considered a
/// regression. 0.5% is enough to swallow cross-platform anti-aliasing without
/// hiding a real change.
const double _tolerance = 0.005;

/// A [LocalFileComparator] that passes when the diff stays under [_tolerance].
class _TolerantGoldenComparator extends LocalFileComparator {
  /// [basedir] is the directory of the running test file; the dummy filename
  /// only exists so [LocalFileComparator] can recover it via `dirname`.
  _TolerantGoldenComparator(Uri basedir) : super(Uri.parse('$basedir$_anchor'));

  static const String _anchor = 'flutter_test_config.dart';

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );

    if (result.passed || result.diffPercent <= _tolerance) {
      result.dispose();
      return true;
    }

    final error = await generateFailureOutput(result, golden, basedir);
    result.dispose();
    throw FlutterError(error);
  }
}
