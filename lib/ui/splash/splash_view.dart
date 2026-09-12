import 'package:flutter/material.dart';

import '../common/app_colors.dart';
import '../common/app_motion.dart';
import '../common/brand_tokens.dart';
import '../main_shell/main_shell_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  late final Animation<double> _mark = CurvedAnimation(
    parent: _c,
    curve: const Interval(0.0, 0.45, curve: Curves.easeOutCubic),
  );
  late final Animation<double> _tag = CurvedAnimation(
    parent: _c,
    curve: const Interval(0.35, 0.75, curve: Curves.easeOutCubic),
  );
  late final Animation<double> _hero = CurvedAnimation(
    parent: _c,
    curve: const Interval(0.0, 0.85, curve: Curves.easeOutCubic),
  );

  @override
  void initState() {
    super.initState();
    _c.forward();
    _c.addStatusListener((s) {
      if (s == AnimationStatus.completed) _enter();
    });
  }

  void _enter() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: AppMotion.page,
        pageBuilder: (context, animation, secondary) => const MainShellView(),
        transitionsBuilder: (context, anim, secondary, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.disableAnimationsOf(context);
    const hero = BrandTokens.splashHero;
    const onHero = Colors.white;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (hero != null)
            AnimatedBuilder(
              animation: _c,
              builder: (context, child) {
                final h = reduce ? 1.0 : _hero.value;
                return Opacity(
                  opacity: h,
                  child: Transform.scale(
                    scale: 1.06 - 0.06 * h,
                    child: child,
                  ),
                );
              },
              child: Image.asset(
                hero,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) =>
                    const ColoredBox(color: AppColors.bg),
              ),
            ),
          if (hero != null)
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.42, 0.72, 1.0],
                  colors: [
                    Color(0x1A000000),
                    Color(0x00000000),
                    Color(0xA6000000),
                    Color(0xF2000000),
                  ],
                ),
              ),
            ),
          _Frame(
            atFoot: hero != null,
            child: AnimatedBuilder(
              animation: _c,
              builder: (context, _) {
                final m = reduce ? 1.0 : _mark.value;
                final t = reduce ? 1.0 : _tag.value;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: hero != null
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  children: [
                    Opacity(
                      opacity: m,
                      child: Transform.scale(
                        scale: 0.94 + 0.06 * m,
                        child: hero != null
                            ? const BrandMark(height: 44, tint: onHero)
                            : const BrandMark(height: 44),
                      ),
                    ),
                    if (BrandTokens.tagline.isNotEmpty) ...[
                      const SizedBox(height: 18),
                      Opacity(
                        opacity: t,
                        child: Transform.translate(
                          offset: Offset(0, 8 * (1 - t)),
                          child: Text(
                            BrandTokens.tagline,
                            textAlign: hero != null
                                ? TextAlign.start
                                : TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: hero != null ? onHero : null),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Frame extends StatelessWidget {
  const _Frame({required this.atFoot, required this.child});

  final bool atFoot;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!atFoot) return Center(child: child);
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 28, 44),
          child: child,
        ),
      ),
    );
  }
}

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.height = 24, this.tint});

  final double height;
  final Color? tint;

  @override
  Widget build(BuildContext context) {
    final mark = Image.asset(
      BrandTokens.logoAsset,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stack) => Text(
        BrandTokens.name,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: height * 0.8,
              color: tint ?? AppColors.ink,
            ),
      ),
    );
    if (tint == null) return mark;
    return ColorFiltered(
      colorFilter: ColorFilter.mode(tint!, BlendMode.srcIn),
      child: mark,
    );
  }
}
