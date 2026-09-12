import 'package:flutter/material.dart';

import '../common/app_colors.dart';
import '../common/app_radius.dart';

/// Bundled photo with rounded corners and a four-stop bottom scrim so text
/// on it always reads. [overlay] sits bottom-left inside the padding.
class ScrimImage extends StatelessWidget {
  const ScrimImage({
    super.key,
    required this.asset,
    this.aspectRatio = 16 / 10,
    this.overlay,
    this.borderRadius,
    this.scrim = true,
    this.padding = const EdgeInsets.all(18),
    this.alignment = Alignment.center,
  });

  final String asset;
  final double aspectRatio;
  final Widget? overlay;
  final BorderRadius? borderRadius;
  final bool scrim;
  final EdgeInsetsGeometry padding;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.image),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              asset,
              fit: BoxFit.cover,
              alignment: alignment,
              errorBuilder: (context, error, stackTrace) =>
                  const ColoredBox(color: AppColors.surfaceRaised),
            ),
            if (scrim)
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x00000000),
                      Color(0x00000000),
                      Color(0x40000000),
                      Color(0x99000000),
                      Color(0xCC000000),
                    ],
                    stops: [0.0, 0.35, 0.6, 0.85, 1.0],
                  ),
                ),
              ),
            if (overlay != null)
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(padding: padding, child: overlay),
              ),
          ],
        ),
      ),
    );
  }
}
