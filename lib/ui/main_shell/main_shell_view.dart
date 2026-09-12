import 'package:flutter/material.dart';

import '../common/app_colors.dart';
import '../common/app_motion.dart';
import '../common/app_preview_insets.dart';
import '../common/app_preview_insets_detect_stub.dart'
    if (dart.library.html) '../common/app_preview_insets_detect_web.dart';
import '../common/app_shadows.dart';
import '../common/app_space.dart';
import '../shared_widgets/glass_bar.dart';
import '../shared_widgets/tab_pill.dart';
import 'tabs.dart';

class MainShellView extends StatefulWidget {
  const MainShellView({super.key});

  @override
  State<MainShellView> createState() => _MainShellViewState();
}

class _MainShellViewState extends State<MainShellView> {
  late final List<DemoTab> _tabs = demoTabs();
  late final List<ScrollController> _scroll =
      List.generate(_tabs.length, (_) => ScrollController());
  int _index = 0;

  @override
  void dispose() {
    for (final c in _scroll) {
      c.dispose();
    }
    super.dispose();
  }

  void _select(int i) {
    if (i == _index) {
      final c = _scroll[i];
      if (c.hasClients && c.offset > 0) {
        c.animateTo(0, duration: AppMotion.page, curve: AppMotion.curve);
      }
      return;
    }
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DemoHostMode>(
      valueListenable: demoHostModeListenable,
      builder: (context, _, __) {
        final bottomPad = AppPreviewInsets.floatingNavBottomPadding(context);
        return Scaffold(
          extendBody: true,
          backgroundColor: AppColors.bg,
          body: IndexedStack(
            index: _index,
            children: [
              for (var i = 0; i < _tabs.length; i++)
                PrimaryScrollController(
                  controller: _scroll[i],
                  child: ColoredBox(
                    color: AppColors.bg,
                    child: Builder(builder: _tabs[i].builder),
                  ),
                ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpace.lg,
              0,
              AppSpace.lg,
              bottomPad,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                boxShadow: AppShadows.liftShadow,
              ),
              child: GlassBar(
                borderRadius: BorderRadius.circular(28),
                fillOpacity: 0.86,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpace.sm,
                  vertical: AppSpace.sm,
                ),
                child: Row(
                  children: [
                    for (var i = 0; i < _tabs.length; i++)
                      Expanded(
                        child: TabPill(
                          icon: i == _index
                              ? _tabs[i].activeIcon
                              : _tabs[i].icon,
                          label: _tabs[i].label,
                          selected: i == _index,
                          axis: Axis.vertical,
                          onTap: () => _select(i),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
