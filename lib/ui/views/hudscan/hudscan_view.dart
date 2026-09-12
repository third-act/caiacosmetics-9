import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../kit.dart';
import '../scan_resultat/scan_resultat_view.dart';

/// Signaturmomentet: ansiktsfoto i oval ram — aldrig pensel/produkt.
class HudscanView extends StatefulWidget {
  const HudscanView({super.key, this.pushad = false});

  final bool pushad;

  @override
  State<HudscanView> createState() => _HudscanViewState();
}

class _HudscanViewState extends State<HudscanView> {
  bool _scannar = false;

  Future<void> _scanna() async {
    setState(() => _scannar = true);
    await Future<void>.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    setState(() => _scannar = false);
    final route = MaterialPageRoute<void>(
      builder: (_) => const ScanResultatView(),
    );
    if (widget.pushad) {
      Navigator.of(context).pushReplacement(route);
    } else {
      Navigator.of(context).push(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final pad = tabContentPadding(context);
    final bottenLuft = widget.pushad
        ? AppSpace.xxl + MediaQuery.paddingOf(context).bottom
        : pad.bottom - AppSpace.xl;

    return ColoredBox(
      color: AppColors.bg,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/ansikte-lifestyle.jpg',
            fit: BoxFit.cover,
            alignment: const Alignment(0, -0.25),
            errorBuilder: (context, error, stack) =>
                const ColoredBox(color: AppColors.plateHigh),
          ),
          _Ansiktsram(scannar: _scannar),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: pad.top + 120,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.bg.withValues(alpha: 0.92),
                    AppColors.bg.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpace.screen,
              pad.top,
              AppSpace.screen,
              bottenLuft,
            ),
            child: Column(
              children: [
                if (widget.pushad)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        AppHaptics.light();
                        Navigator.of(context).maybePop();
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(right: AppSpace.lg),
                        child: Icon(
                          Icons.chevron_left,
                          size: 30,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpace.sm),
                Text('HUDSCAN', style: t.labelSmall),
                const SizedBox(height: AppSpace.sm),
                Text(
                  'Skanna ditt ansikte',
                  textAlign: TextAlign.center,
                  style: t.displayMedium,
                ),
                const SizedBox(height: AppSpace.sm),
                Text(
                  'Håll telefonen i ögonhöjd med jämnt ljus.',
                  textAlign: TextAlign.center,
                  style: t.bodyMedium,
                ),
                const Spacer(),
                SizedBox(
                  height: 22,
                  child: AnimatedOpacity(
                    opacity: _scannar ? 1 : 0,
                    duration: AppMotion.micro,
                    child: Text(
                      'Analyserar hudton och fukt…',
                      style:
                          t.bodySmall?.copyWith(color: AppColors.accentStrong),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpace.lg),
                _Utlosare(scannar: _scannar, onTap: _scannar ? null : _scanna),
                const SizedBox(height: AppSpace.md),
                Text(
                  _scannar ? 'Håll stilla' : 'Skanna min hud',
                  style: t.titleMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Utlosare extends StatelessWidget {
  const _Utlosare({required this.scannar, required this.onTap});

  final bool scannar;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: scannar
          ? null
          : () {
              AppHaptics.medium();
              onTap?.call();
            },
      child: AnimatedScale(
        scale: scannar ? 0.92 : 1,
        duration: AppMotion.page,
        curve: AppMotion.curve,
        child: Container(
          width: 92,
          height: 92,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.accent,
            boxShadow: AppShadows.liftShadow,
          ),
          child: Center(
            child: Container(
              width: 68,
              height: 68,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface,
              ),
              child: Center(
                child: scannar
                    ? AppAsync.spinner(radius: 11, color: AppColors.ink)
                    : const Icon(
                        LucideIcons.scanFace,
                        size: 30,
                        color: AppColors.ink,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Ansiktsram extends StatefulWidget {
  const _Ansiktsram({required this.scannar});

  final bool scannar;

  @override
  State<_Ansiktsram> createState() => _AnsiktsramState();
}

class _AnsiktsramState extends State<_Ansiktsram>
    with TickerProviderStateMixin {
  late final AnimationController _puls = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat(reverse: true);

  late final AnimationController _svep = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3000),
  );

  @override
  void didUpdateWidget(_Ansiktsram old) {
    super.didUpdateWidget(old);
    if (widget.scannar && !old.scannar) {
      _svep.forward(from: 0);
    } else if (!widget.scannar && old.scannar) {
      _svep.stop();
      _svep.value = 0;
    }
  }

  @override
  void dispose() {
    _puls.dispose();
    _svep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_puls, _svep]),
      builder: (context, _) => CustomPaint(
        size: Size.infinite,
        painter: _RamPainter(
          puls: Curves.easeInOut.transform(_puls.value),
          svep: widget.scannar ? _svep.value : null,
        ),
      ),
    );
  }
}

class _RamPainter extends CustomPainter {
  _RamPainter({required this.puls, required this.svep});

  final double puls;
  final double? svep;

  @override
  void paint(Canvas canvas, Size size) {
    final bredd = size.width * 0.66;
    final oval = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.42),
      width: bredd,
      height: bredd * 1.34,
    );

    final helaYtan = Path()..addRect(Offset.zero & size);
    final fonstret = Path()..addOval(oval);

    canvas.drawPath(
      Path.combine(PathOperation.difference, helaYtan, fonstret),
      Paint()..color = AppColors.ink.withValues(alpha: 0.45),
    );

    canvas.drawOval(
      oval,
      Paint()
        ..color = AppColors.accent.withValues(alpha: 0.55 + 0.35 * puls)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    final ram = oval.inflate(14);
    const langd = 24.0;
    final penna = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    for (final (hx, vx) in [
      (1.0, 1.0),
      (-1.0, 1.0),
      (1.0, -1.0),
      (-1.0, -1.0),
    ]) {
      final x = hx > 0 ? ram.left : ram.right;
      final y = vx > 0 ? ram.top : ram.bottom;
      canvas.drawLine(Offset(x, y), Offset(x + langd * hx, y), penna);
      canvas.drawLine(Offset(x, y), Offset(x, y + langd * vx), penna);
    }

    final s = svep;
    if (s == null) return;

    canvas.save();
    canvas.clipPath(fonstret);
    final y = oval.top + oval.height * s;
    final slap = Rect.fromLTRB(oval.left, y - 70, oval.right, y);
    canvas.drawRect(
      slap,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.accent.withValues(alpha: 0.0),
            AppColors.accent.withValues(alpha: 0.34),
          ],
        ).createShader(slap),
    );
    canvas.drawLine(
      Offset(oval.left, y),
      Offset(oval.right, y),
      Paint()
        ..color = AppColors.accent
        ..strokeWidth = 2,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_RamPainter old) => old.puls != puls || old.svep != svep;
}
