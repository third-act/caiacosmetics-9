import 'package:flutter/material.dart';

import '../common/app_colors.dart';
import '../common/app_haptics.dart';
import '../common/app_radius.dart';
import '../common/app_shadows.dart';
import '../common/app_space.dart';

/// Selection chip with [AppShadows.cardShadow]; selected = accentSoft fill.
class BrandChip extends StatelessWidget {
  const BrandChip({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap == null
          ? null
          : () async {
              AppHaptics.selection();
              onTap!();
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpace.lg,
          vertical: AppSpace.sm + 2,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentSoft : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.chip),
          boxShadow: AppShadows.cardShadow,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: AppColors.ink,
            fontSize: 14,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
