import 'dart:ui';

import 'package:flutter/material.dart';

import '../common/app_colors.dart';
import '../common/app_haptics.dart';
import '../common/app_preview_insets.dart';
import '../common/app_space.dart';

/// Content padding for tab roots: clears the frosted header and the floating
/// tab pill. Use on every tab's scroll view.
EdgeInsets tabContentPadding(BuildContext context) {
  final preview = AppPreviewInsets.overlay(context);
  final safeTop = MediaQuery.paddingOf(context).top;
  return EdgeInsets.fromLTRB(
    AppSpace.screen,
    (safeTop > 0 ? safeTop : preview.top) + AppSpace.md,
    AppSpace.screen,
    120,
  );
}

/// Push-screen scaffold: frosted, graded header with chevron back, content
/// scrolling underneath, optional pinned [bottom] CTA (no tab bar).
class DemoPage extends StatelessWidget {
  const DemoPage({
    super.key,
    required this.body,
    this.title,
    this.titleWidget,
    this.actions = const [],
    this.bottom,
    this.showBack = true,
  });

  final Widget body;
  final String? title;
  final Widget? titleWidget;
  final List<Widget> actions;
  final Widget? bottom;
  final bool showBack;

  static double headerHeight(BuildContext context) =>
      MediaQuery.paddingOf(context).top + kToolbarHeight;

  /// Padding for a scroll view inside [DemoPage]: clears header and [bottom].
  static EdgeInsets contentPadding(BuildContext context,
          {bool hasBottom = false}) =>
      EdgeInsets.fromLTRB(
        AppSpace.screen,
        headerHeight(context) + AppSpace.md,
        AppSpace.screen,
        hasBottom ? 140 : 40 + MediaQuery.paddingOf(context).bottom,
      );

  @override
  Widget build(BuildContext context) {
    final canPop = showBack && Navigator.of(context).canPop();
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        leading: canPop
            ? IconButton(
                icon: const Icon(Icons.chevron_left, size: 30),
                color: AppColors.ink,
                onPressed: () {
                  AppHaptics.light();
                  Navigator.of(context).maybePop();
                },
              )
            : null,
        title: titleWidget ??
            (title == null
                ? null
                : Text(title!, style: Theme.of(context).textTheme.titleMedium)),
        actions: actions,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              height: headerHeight(context),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.bg.withValues(alpha: 0.94),
                    AppColors.bg.withValues(alpha: 0.72),
                    AppColors.bg.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.65, 1.0],
                ),
              ),
            ),
          ),
        ),
      ),
      body: body,
      bottomNavigationBar: bottom == null
          ? null
          : Container(
              padding: EdgeInsets.fromLTRB(
                AppSpace.screen,
                AppSpace.md,
                AppSpace.screen,
                AppPreviewInsets.pinnedBarBottomPadding(context),
              ),
              decoration: BoxDecoration(
                color: AppColors.bg.withValues(alpha: 0.96),
                border: const Border(top: BorderSide(color: AppColors.hairline)),
              ),
              child: bottom,
            ),
    );
  }
}
