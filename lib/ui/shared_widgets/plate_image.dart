import 'package:flutter/material.dart';

import '../common/app_colors.dart';
import '../common/app_radius.dart';

/// Product cut-out on a tinted plate — never a grey box. The plate takes its
/// hue from the brand accent; the photo sits inside [inset] with `contain`.
class PlateImage extends StatelessWidget {
  const PlateImage({
    super.key,
    required this.asset,
    this.aspectRatio = 4 / 5,
    this.inset = 14,
    this.borderRadius,
    this.fit = BoxFit.contain,
  });

  final String asset;
  final double aspectRatio;
  final double inset;
  final BorderRadius? borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.image),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(-0.4, -0.5),
              radius: 1.2,
              colors: [AppColors.plateHigh, AppColors.plateLow],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(inset),
            child: Image.asset(
              asset,
              fit: fit,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}
