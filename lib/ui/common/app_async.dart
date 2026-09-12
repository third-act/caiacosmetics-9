import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Latency floor + busy UX for write-shaped CTAs (book, join, send, confirm).
///
/// Mock / instant seed: always wait at least [floor] before success.
/// Live Firebase/Functions: pass the real [Future] — no extra delay on top of
/// a slow network; [run] still enforces the floor when the future resolves too fast.
class AppAsync {
  AppAsync._();

  /// Default floor for write CTAs (~400–700 ms). Midpoint 550 ms.
  static const Duration floor = Duration(milliseconds: 550);

  /// Runs [action], never resolving faster than [min] (default [floor]).
  static Future<T> run<T>(
    Future<T> Function() action, {
    Duration min = floor,
  }) async {
    final started = DateTime.now();
    final result = await action();
    final elapsed = DateTime.now().difference(started);
    if (elapsed < min) {
      await Future<void>.delayed(min - elapsed);
    }
    return result;
  }

  /// Cupertino spinner tinted to brand ink — not Material [CircularProgressIndicator].
  static Widget spinner({double radius = 12, Color? color}) {
    return CupertinoActivityIndicator(
      radius: radius,
      color: color ?? AppColors.ink,
    );
  }
}
