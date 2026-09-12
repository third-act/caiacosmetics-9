// dart:html is the supported iframe/postMessage path for Flutter web today.
// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:html' as html;

import 'package:flutter/foundation.dart';

/// True when Flutter web runs inside the thirdact.no demo iframe (not top-level).
bool phonePreviewHost() => html.window.self != html.window.top;

/// How the thirdact.no embed hosts this iframe.
enum DemoHostMode { mockup, mobileFullscreen }

DemoHostMode _demoHostMode = DemoHostMode.mockup;
bool _modeListenerAttached = false;

/// Notifies shell/layout when the embed toggles mockup vs mobile fullscreen.
final ValueNotifier<DemoHostMode> demoHostModeListenable =
    ValueNotifier(DemoHostMode.mockup);

void _attachDemoModeListener() {
  if (_modeListenerAttached) return;
  _modeListenerAttached = true;
  html.window.onMessage.listen((event) {
    final data = event.data;
    if (data is! Map) return;
    if (data['type'] != 'ta-demo-mode') return;
    final mode = data['mode'];
    if (mode == 'mobile-fs') {
      _demoHostMode = DemoHostMode.mobileFullscreen;
    } else if (mode == 'mockup') {
      _demoHostMode = DemoHostMode.mockup;
    }
    demoHostModeListenable.value = _demoHostMode;
  });
}

/// Mockup = scaled phone preview on desktop or mobile before "Öppna appen".
/// Mobile fullscreen = after tapping Öppna appen on a phone.
DemoHostMode demoHostMode() {
  if (!phonePreviewHost()) return DemoHostMode.mockup;
  _attachDemoModeListener();
  return _demoHostMode;
}
