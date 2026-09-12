import 'package:flutter/material.dart';

import '../common/app_colors.dart';
import '../common/app_haptics.dart';
import '../common/app_radius.dart';
import '../common/app_space.dart';

/// Tab item — icon + label. Filled active / transparent muted inactive (no border).
///
/// Wrap each [TabPill] in [Expanded] so cells are equal width. Use [axis]
/// `Axis.vertical` when the bar has ≥4 tabs (icon over label). Keep
/// `Axis.horizontal` for 3 tabs.
///
/// Never set [alignment] on the cell container — under Scaffold's loose
/// bottomNavigationBar maxHeight that expands every cell to full screen
/// (stpaul + caiacosmetics).
class TabPill extends StatelessWidget {
  TabPill({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    this.onTap,
    this.axis = Axis.horizontal,
  }) : assert(label.isNotEmpty, 'TabPill requires icon and non-empty label');

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.onAccent : AppColors.inkMuted;
    final bg = selected ? AppColors.accent : Colors.transparent;

    final labelStyle = TextStyle(
      color: color,
      fontSize: axis == Axis.vertical ? 11 : 13,
      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
      height: 1.1,
    );

    final inner = axis == Axis.vertical
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: labelStyle,
              ),
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: AppSpace.sm),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: labelStyle,
                ),
              ),
            ],
          );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap == null
          ? null
          : () {
              AppHaptics.selection(); // never await — web gesture swallow (CAIA)
              onTap!();
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: axis == Axis.vertical ? AppSpace.sm : AppSpace.md,
          vertical: 12,
        ),
        constraints: const BoxConstraints(maxHeight: 64),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: inner,
      ),
    );
  }
}
