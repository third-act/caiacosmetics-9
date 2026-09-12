import 'package:flutter/foundation.dart';

/// Non-web: never inside the thirdact.no phone iframe.
bool phonePreviewHost() => false;

enum DemoHostMode { mockup, mobileFullscreen }

final ValueNotifier<DemoHostMode> demoHostModeListenable =
    ValueNotifier(DemoHostMode.mockup);

DemoHostMode demoHostMode() => DemoHostMode.mockup;
