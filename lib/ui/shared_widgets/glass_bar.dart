import 'dart:ui';

import 'package:flutter/material.dart';

import '../common/app_colors.dart';
import '../common/app_radius.dart';

/// Floating chrome: ClipRRect + BackdropFilter + translucent fill.
class GlassBar extends StatelessWidget {
  const GlassBar({
    super.key,
    required this.child,
    this.borderRadius,
    this.blurSigma = 24,
    this.fillOpacity = 0.82,
    this.fillColor,
    this.padding,
  });

  final Widget child;
  final BorderRadius? borderRadius;
  final double blurSigma;
  final double fillOpacity;
  final Color? fillColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final radius =
        borderRadius ?? BorderRadius.circular(AppRadius.sheet);

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          color: (fillColor ?? AppColors.surface).withValues(alpha: fillOpacity),
          child: child,
        ),
      ),
    );
  }
}
