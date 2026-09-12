export 'common/app_async.dart';
export 'common/app_colors.dart';
export 'common/app_haptics.dart';
export 'common/app_motion.dart';
export 'common/app_preview_insets.dart';
export 'common/app_radius.dart';
export 'common/app_shadows.dart';
export 'common/app_space.dart';
export 'common/app_theme.dart';
export 'common/brand_tokens.dart';
export 'shared_widgets/brand_button.dart';
export 'shared_widgets/pressable_card.dart';
export 'shared_widgets/scrim_image.dart';
export 'shared_widgets/section_header.dart';
export 'shared_widgets/snap_carousel.dart';
export 'shared_widgets/plate_image.dart';
export 'shared_widgets/skeleton_box.dart';
export 'splash/splash_view.dart';

import 'package:flutter/material.dart';

import 'common/app_preview_insets.dart';
import 'common/app_space.dart';

/// Tab body padding: screen gutters + preview overlay + pill clearance.
EdgeInsets tabContentPadding(BuildContext context) {
  final overlay = AppPreviewInsets.overlay(context);
  final bottom = AppPreviewInsets.floatingNavBottomPadding(context) + 72;
  return EdgeInsets.fromLTRB(
    AppSpace.screen,
    overlay.top + AppSpace.lg,
    AppSpace.screen,
    bottom,
  );
}
