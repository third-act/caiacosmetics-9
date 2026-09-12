import 'package:flutter/material.dart';

import '../common/app_colors.dart';
import '../common/app_haptics.dart';
import '../common/app_motion.dart';
import '../common/app_radius.dart';
import '../common/app_shadows.dart';

/// Card that scales to 0.98 on press with light haptic.
class PressableCard extends StatefulWidget {
  const PressableCard({
    super.key,
    required this.child,
    this.onTap,
    this.entrance = false,
    this.entranceIndex = 0,
    this.padding,
    this.borderRadius,
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool entrance;
  final int entranceIndex;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  @override
  State<PressableCard> createState() => _PressableCardState();
}

class _PressableCardState extends State<PressableCard>
    with TickerProviderStateMixin {
  late final AnimationController _press;
  late final AnimationController _enter;
  bool _showEntrance = false;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: AppMotion.micro,
      value: 0,
    );
    _enter = AnimationController(
      vsync: this,
      duration: AppMotion.enter,
    );
    if (widget.entrance) {
      _showEntrance = true;
      final delay =
          AppMotion.stagger * widget.entranceIndex.clamp(0, 8);
      Future<void>.delayed(delay, () {
        if (mounted) _enter.forward();
      });
    }
  }

  @override
  void dispose() {
    _press.dispose();
    _enter.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    if (widget.onTap == null) return;
    _press.forward();
  }

  void _onTapUp(TapUpDetails _) => _press.reverse();

  void _onTapCancel() => _press.reverse();

  Future<void> _onTap() async {
    if (widget.onTap == null) return;
    AppHaptics.light(); // never await before action
    widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    final radius =
        widget.borderRadius ?? BorderRadius.circular(AppRadius.card);

    Widget card = AnimatedBuilder(
      animation: _press,
      builder: (context, child) {
        final t = Curves.easeOut.transform(_press.value);
        return Transform.scale(scale: 1.0 - (0.02 * t), child: child);
      },
      child: Container(
        padding: widget.padding,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: radius,
          boxShadow: AppShadows.cardShadow,
        ),
        child: widget.child,
      ),
    );

    card = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap == null ? null : _onTap,
      child: card,
    );

    if (!_showEntrance) return card;

    return AnimatedBuilder(
      animation: _enter,
      builder: (context, child) {
        final value = AppMotion.curve.transform(_enter.value);
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 14 * (1 - value)),
            child: child,
          ),
        );
      },
      child: card,
    );
  }
}
