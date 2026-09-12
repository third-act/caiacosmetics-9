import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../views/for_dig/for_dig_view.dart';
import '../views/hem/hem_view.dart';
import '../views/hudscan/hudscan_view.dart';
import '../views/mina/mina_view.dart';

class DemoTab {
  const DemoTab({
    required this.label,
    required this.icon,
    required this.builder,
    IconData? activeIcon,
  }) : activeIcon = activeIcon ?? icon;

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final WidgetBuilder builder;
}

List<DemoTab> demoTabs() => [
      DemoTab(
        label: 'Hem',
        icon: LucideIcons.house,
        builder: (_) => const HemView(),
      ),
      DemoTab(
        label: 'Hudscan',
        icon: LucideIcons.scanFace,
        builder: (_) => const HudscanView(),
      ),
      DemoTab(
        label: 'För dig',
        icon: LucideIcons.sparkles,
        builder: (_) => const ForDigView(),
      ),
      DemoTab(
        label: 'Mina',
        icon: LucideIcons.user,
        builder: (_) => const MinaView(),
      ),
    ];
