import 'package:flutter/material.dart';

import '../common/app_colors.dart';
import '../common/app_haptics.dart';
import '../common/app_radius.dart';
import '../common/app_space.dart';

/// Branded success panel (not AlertDialog). Call [show] to present.
class SuccessOverlay extends StatelessWidget {
  const SuccessOverlay({
    super.key,
    required this.title,
    this.message,
    this.actionLabel = 'Done',
    this.onAction,
    this.icon = Icons.check_circle_rounded,
  });

  final String title;
  final String? message;
  final String actionLabel;
  final VoidCallback? onAction;
  final IconData icon;

  static Future<void> show(
    BuildContext context, {
    required String title,
    String? message,
    String actionLabel = 'Done',
    VoidCallback? onAction,
  }) async {
    AppHaptics.medium();
    if (!context.mounted) return;
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: AppColors.ink.withValues(alpha: 0.45),
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (ctx, anim, _) {
        return Center(
          child: SuccessOverlay(
            title: title,
            message: message,
            actionLabel: actionLabel,
            onAction: onAction ?? () => Navigator.of(ctx).pop(),
          ),
        );
      },
      transitionBuilder: (ctx, anim, _, child) {
        final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween(begin: 0.96, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpace.xl),
        padding: const EdgeInsets.fromLTRB(
          AppSpace.xl,
          AppSpace.xxl,
          AppSpace.xl,
          AppSpace.xl,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.sheet),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColors.accent),
            const SizedBox(height: AppSpace.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 22,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
                height: 1.2,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: AppSpace.sm),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.inkMuted,
                  fontSize: 15,
                  height: 1.45,
                ),
              ),
            ],
            const SizedBox(height: AppSpace.xl),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onAction,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.onAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
                child: Text(
                  actionLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
