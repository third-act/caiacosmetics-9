import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_space.dart';
import 'brand_tokens.dart';

/// ThemeData from generated brand tokens. Light or dark follows
/// [BrandTokens.isDark] (art direction). Locked — the build agent never edits.
class AppTheme {
  AppTheme._();

  static ThemeData build() {
    const dark = BrandTokens.isDark;
    final base = ThemeData(
      useMaterial3: true,
      brightness: dark ? Brightness.dark : Brightness.light,
      fontFamily: BrandTokens.bodyFamily,
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.accent,
        onPrimary: AppColors.onAccent,
        secondary: AppColors.accent,
        onSecondary: AppColors.onAccent,
        surface: AppColors.surface,
        onSurface: AppColors.ink,
        error: AppColors.danger,
        onError: AppColors.onAccent,
      ),
      textTheme: _textTheme(base.textTheme),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
        },
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.ink,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.hairline,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: _pill(BorderSide.none),
        enabledBorder: _pill(BorderSide.none),
        focusedBorder: _pill(const BorderSide(color: AppColors.accent, width: 1.5)),
        errorBorder: _pill(const BorderSide(color: AppColors.danger)),
        focusedErrorBorder:
            _pill(const BorderSide(color: AppColors.danger, width: 1.5)),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpace.lg,
          vertical: AppSpace.md,
        ),
        hintStyle: const TextStyle(color: AppColors.inkFaint, fontSize: 15),
        labelStyle: const TextStyle(color: AppColors.inkMuted, fontSize: 13),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.accentSoft,
        labelStyle: const TextStyle(color: AppColors.ink, fontSize: 14),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpace.md,
          vertical: AppSpace.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.chip),
        ),
        side: BorderSide.none,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.sheet),
          ),
        ),
      ),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
    );
  }

  static OutlineInputBorder _pill(BorderSide side) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        borderSide: side,
      );

  static TextStyle _s({
    required double size,
    required FontWeight weight,
    required double height,
    double spacing = 0,
    Color color = AppColors.ink,
    bool display = false,
    bool tabular = false,
  }) =>
      TextStyle(
        fontFamily: display ? BrandTokens.displayFamily : BrandTokens.bodyFamily,
        color: color,
        fontSize: size,
        fontWeight: weight,
        height: height,
        letterSpacing: spacing,
        fontFeatures: tabular ? const [FontFeature.tabularFigures()] : null,
      );

  static TextTheme _textTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: _s(size: 38, weight: FontWeight.w700, height: 1.05, spacing: -1.0, display: true),
      displayMedium: _s(size: 32, weight: FontWeight.w700, height: 1.1, spacing: -0.7, display: true),
      displaySmall: _s(size: 26, weight: FontWeight.w700, height: 1.15, spacing: -0.5, display: true),
      headlineMedium: _s(size: 24, weight: FontWeight.w600, height: 1.2, spacing: -0.4, display: true),
      titleLarge: _s(size: 22, weight: FontWeight.w600, height: 1.2, spacing: -0.3, display: true),
      titleMedium: _s(size: 17, weight: FontWeight.w600, height: 1.25, spacing: -0.2),
      titleSmall: _s(size: 15, weight: FontWeight.w600, height: 1.3, spacing: -0.1),
      bodyLarge: _s(size: 16, weight: FontWeight.w400, height: 1.5, tabular: true),
      bodyMedium: _s(size: 15, weight: FontWeight.w400, height: 1.5, tabular: true),
      bodySmall: _s(size: 13, weight: FontWeight.w500, height: 1.3, spacing: 0.2, color: AppColors.inkMuted, tabular: true),
      labelLarge: _s(size: 15, weight: FontWeight.w600, height: 1.2),
      labelSmall: _s(size: 11, weight: FontWeight.w600, height: 1.2, spacing: 1.2, color: AppColors.inkMuted),
    );
  }
}
