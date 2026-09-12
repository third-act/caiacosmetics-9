import 'dart:async';

import 'package:flutter/services.dart';

/// Safe haptic wrappers — fire-and-forget.
///
/// **Never `await` these before `onPressed` / `onTap`.** On Flutter web a
/// hanging [HapticFeedback] Future can swallow the gesture (CAIA Fortsätt +
/// TabPill). Call, then run the action immediately.
class AppHaptics {
  AppHaptics._();

  static void selection() => unawaited(_safe(HapticFeedback.selectionClick));

  static void light() => unawaited(_safe(HapticFeedback.lightImpact));

  static void medium() => unawaited(_safe(HapticFeedback.mediumImpact));

  static Future<void> _safe(Future<void> Function() fn) async {
    try {
      await fn();
    } catch (_) {}
  }
}
