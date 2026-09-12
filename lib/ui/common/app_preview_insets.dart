import 'package:flutter/material.dart';

import 'app_preview_insets_detect_stub.dart'
    if (dart.library.html) 'app_preview_insets_detect_web.dart';
import 'app_space.dart';

/// Insets for the thirdact.no phone iframe and floating tab pill placement.
///
/// See demofabrikk `docs/DEMO_PREVIEW_CONTRACT.md` for the full rule set.
///
/// **Mockup preview** (desktop iframe, or mobile before "Öppna appen"):
/// mimic iPhone chrome so content clears the PNG bezel (393×852 host).
///
/// **Mobile fullscreen** (after Öppna appen): simulate status bar + home
/// indicator when the iframe reports zero [MediaQuery.padding].
abstract final class AppPreviewInsets {
  /// Logo / header clearance inside the mockup bezel.
  static const mockupTop = 32.0;

  /// Floating tab pill clearance inside the mockup bezel.
  static const mockupBottom = 12.0;

  /// Status-bar clearance in mobile fullscreen (iframe has no SafeArea).
  static const mobileFullscreenTop = 47.0;

  /// Home-indicator clearance for floating pill in mobile fullscreen.
  static const mobileFullscreenBottom = 20.0;

  /// Extra gap when the pill floats on a real phone (not in demo iframe).
  static const mobileFloatingGap = 10.0;

  static bool _mockupPreview(BuildContext context) =>
      phonePreviewHost() && demoHostMode() != DemoHostMode.mobileFullscreen;

  static bool _mobileFullscreen(BuildContext context) =>
      phonePreviewHost() && demoHostMode() == DemoHostMode.mobileFullscreen;

  /// Extra padding when embedded in the phone mockup and SafeArea is zero.
  static EdgeInsets overlay(BuildContext context) {
    final safe = MediaQuery.paddingOf(context);
    if (_mockupPreview(context)) {
      return EdgeInsets.only(
        top: safe.top > 0 ? 0 : mockupTop,
        bottom: safe.bottom > 0 ? 0 : mockupBottom,
      );
    }
    if (_mobileFullscreen(context)) {
      return EdgeInsets.only(
        top: safe.top > 0 ? safe.top : mobileFullscreenTop,
      );
    }
    return EdgeInsets.zero;
  }

  /// Bottom padding for [MainShellView]'s floating tab pill.
  ///
  /// - Mockup preview: sit just above the PNG bezel.
  /// - Mobile fullscreen iframe: clear home indicator (simulated when SafeArea is 0).
  /// - Standalone mobile: float slightly above the bottom with real SafeArea.
  static double floatingNavBottomPadding(BuildContext context) {
    final safe = MediaQuery.paddingOf(context);

    if (_mockupPreview(context)) {
      return AppSpace.sm + mockupBottom;
    }

    if (_mobileFullscreen(context)) {
      if (safe.bottom > 0) {
        return AppSpace.sm + safe.bottom;
      }
      return AppSpace.sm + mobileFullscreenBottom;
    }

    if (safe.bottom > 0) {
      return AppSpace.sm + safe.bottom;
    }
    return AppSpace.md + mobileFloatingGap;
  }

  /// Bottom padding for [DemoPage]'s pinned full-width CTA bar.
  static double pinnedBarBottomPadding(BuildContext context) {
    final safe = MediaQuery.paddingOf(context);

    if (_mockupPreview(context)) {
      return AppSpace.md + mockupBottom;
    }

    if (_mobileFullscreen(context)) {
      if (safe.bottom > 0) {
        return AppSpace.md + safe.bottom;
      }
      return AppSpace.md + mobileFullscreenBottom;
    }

    return AppSpace.md + safe.bottom;
  }
}
