import 'package:flutter/material.dart';

import '../common/app_colors.dart';
import '../common/app_haptics.dart';
import '../common/app_space.dart';

/// PageView carousel with peek, snap, dots, and selection haptic.
///
/// Bottom padding inside the track keeps [AppShadows] from clipping over
/// the dots (Ekerö Hem rails). Prefer this over relying on Clip.none alone.
class SnapCarousel extends StatefulWidget {
  const SnapCarousel({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.viewportFraction = 0.82,
    this.height = 220,
    this.shadowClearance = 16,
    this.onPageChanged,
  });

  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;
  final double viewportFraction;
  /// Card track height (shadow clearance is added below, above the dots).
  final double height;
  /// Extra space under cards inside the clip so ambient shadow is not cut.
  final double shadowClearance;
  final ValueChanged<int>? onPageChanged;

  @override
  State<SnapCarousel> createState() => _SnapCarouselState();
}

class _SnapCarouselState extends State<SnapCarousel> {
  late final PageController _controller;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: widget.viewportFraction);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPageChanged(int i) {
    setState(() => _index = i);
    AppHaptics.selection(); // never await
    widget.onPageChanged?.call(i);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount <= 0) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.height + widget.shadowClearance,
          child: PageView.builder(
            controller: _controller,
            padEnds: true,
            clipBehavior: Clip.none,
            itemCount: widget.itemCount,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, i) {
              return Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpace.sm,
                  0,
                  AppSpace.sm,
                  widget.shadowClearance,
                ),
                child: ColoredBox(
                  color: AppColors.bg,
                  child: widget.itemBuilder(context, i) ??
                      const SizedBox.shrink(),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpace.md),
        _Dots(count: widget.itemCount, index: _index),
      ],
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 10 : 6,
          height: active ? 10 : 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? AppColors.accent : AppColors.ink.withValues(alpha: 0.28),
          ),
        );
      }),
    );
  }
}
