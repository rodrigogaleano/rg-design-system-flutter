import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Global test setup, picked up automatically for every test under `test/`.
///
/// Installs a golden comparator with a small pixel tolerance. Goldens are
/// authored and verified in one pinned Linux image (see the `Makefile` and
/// the CI workflow) and only run there, so their rendering is deterministic.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final local = goldenFileComparator as LocalFileComparator;
  goldenFileComparator = _TolerantGoldenComparator(local.basedir);
  await testMain();
}

/// Share of pixels (0..1) allowed to differ before a golden counts as a
/// regression. Same environment on both ends makes the real diff ~zero; this
/// only absorbs sub-pixel rasterization noise, not a genuine change.
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
