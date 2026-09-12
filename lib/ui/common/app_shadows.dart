import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Two-level shadows: contact + ambient (never Material elevation alone).
class AppShadows {
  AppShadows._();

  static const cardShadow = <BoxShadow>[
    BoxShadow(color: Color(0x0D070A12), blurRadius: 2, offset: Offset(0, 1)),
    BoxShadow(color: AppColors.shadow, blurRadius: 24, offset: Offset(0, 8)),
  ];

  static const liftShadow = <BoxShadow>[
    BoxShadow(color: Color(0x0F070A12), blurRadius: 3, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x1A070A12), blurRadius: 40, offset: Offset(0, 16)),
  ];
}
