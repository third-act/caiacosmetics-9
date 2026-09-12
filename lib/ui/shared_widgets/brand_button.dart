import 'package:flutter/material.dart';

import '../common/app_async.dart';
import '../common/app_colors.dart';
import '../common/app_haptics.dart';
import '../common/app_motion.dart';
import '../common/app_radius.dart';
import '../common/app_shadows.dart';

enum BrandButtonStyle { primary, secondary, quiet }

/// The one button. Filled accent pill (primary), accentSoft (secondary),
/// text-only (quiet). Press-scale, light haptic, Cupertino spinner when [busy].
class BrandButton extends StatefulWidget {
  const BrandButton({
    super.key,
    required this.label,
    this.onPressed,
    this.style = BrandButtonStyle.primary,
    this.busy = false,
    this.icon,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final BrandButtonStyle style;
  final bool busy;
  final IconData? icon;
  final bool expand;

  @override
  State<BrandButton> createState() => _BrandButtonState();
}

class _BrandButtonState extends State<BrandButton> {
  bool _down = false;

  bool get _enabled => widget.onPressed != null && !widget.busy;

  @override
  Widget build(BuildContext context) {
    final primary = widget.style == BrandButtonStyle.primary;
    final quiet = widget.style == BrandButtonStyle.quiet;
    final fg = primary ? AppColors.onAccent : AppColors.accentStrong;
    final bg = primary
        ? AppColors.accent
        : quiet
            ? Colors.transparent
            : AppColors.accentSoft;

    final child = Row(
      mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.busy)
          AppAsync.spinner(radius: 9, color: fg)
        else ...[
          if (widget.icon != null) ...[
            Icon(widget.icon, size: 18, color: fg),
            const SizedBox(width: 8),
          ],
          Text(
            widget.label,
            style: TextStyle(
              color: fg,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ],
    );

    return Opacity(
      opacity: _enabled || widget.busy ? 1 : 0.38,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _enabled ? (_) => setState(() => _down = true) : null,
        onTapUp: _enabled ? (_) => setState(() => _down = false) : null,
        onTapCancel: _enabled ? () => setState(() => _down = false) : null,
        onTap: _enabled
            ? () {
                AppHaptics.light(); // never await
                widget.onPressed!();
              }
            : null,
        child: AnimatedScale(
          scale: _down ? 0.97 : 1,
          duration: AppMotion.micro,
          curve: Curves.easeOut,
          child: Container(
            height: 52,
            padding: EdgeInsets.symmetric(horizontal: quiet ? 8 : 22),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              boxShadow: primary && _enabled ? AppShadows.cardShadow : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
