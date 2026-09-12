import 'package:flutter/animation.dart';

/// Motion tokens — durations for system-driven motion; [spring] for finger-driven.
class AppMotion {
  AppMotion._();

  static const micro = Duration(milliseconds: 180);
  static const enter = Duration(milliseconds: 420);
  static const page = Duration(milliseconds: 320);
  static const stagger = Duration(milliseconds: 70);

  static const curve = Curves.easeOutCubic;

  static const spring = SpringDescription(mass: 1, stiffness: 380, damping: 30);
}
