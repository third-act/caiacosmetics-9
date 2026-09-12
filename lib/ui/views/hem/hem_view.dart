import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../kit.dart';
import '../hudscan/hudscan_view.dart';
import '../scan_resultat/scan_resultat_view.dart';

/// Hem: tight first fold — hero + CTA + secondary row visible without air gaps.
class HemView extends StatelessWidget {
  const HemView({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final pad = tabContentPadding(context);

    return CustomScrollView(
      primary: true,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(pad.left, pad.top, pad.right, 0),
          sliver: SliverList.list(
            children: [
              const Row(
                children: [
                  BrandMark(height: 24),
                  Spacer(),
                  Icon(LucideIcons.bell, size: 22, color: AppColors.ink),
                ],
              ),
              const SizedBox(height: AppSpace.lg),
              Text('Hej, Emma', style: t.displayLarge),
              const SizedBox(height: AppSpace.sm),
              Text(
                'Senaste scanningen · igår · normal hud, neutral underton',
                style: t.bodySmall,
              ),
              const SizedBox(height: AppSpace.lg),
              _HudprofilKort(),
              const SizedBox(height: AppSpace.lg),
              Text('Nästa steg nu', style: t.titleLarge),
              const SizedBox(height: AppSpace.md),
              const _NastaStegKort(),
              const SizedBox(height: AppSpace.lg),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: 'Matchat för din hud'),
              const SizedBox(height: AppSpace.xs),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.screen),
                child: Text(
                  'Produkter som passar din senaste hudprofil.',
                  style: t.bodySmall,
                ),
              ),
              const SizedBox(height: AppSpace.md),
              SnapCarousel(
                itemCount: 3,
                height: 280,
                viewportFraction: 0.76,
                itemBuilder: (context, i) => _ProduktRailKort(index: i),
              ),
            ],
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            pad.left,
            AppSpace.lg,
            pad.right,
            pad.bottom,
          ),
          sliver: SliverList.list(
            children: [
              Text('Signature store', style: t.titleLarge),
              const SizedBox(height: AppSpace.md),
              Transform.translate(
                offset: const Offset(0, -4),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    boxShadow: AppShadows.liftShadow,
                  ),
                  child: ScrimImage(
                    asset: 'assets/images/hero-butik.jpg',
                    aspectRatio: 2.2,
                    alignment: const Alignment(0, -0.15),
                    overlay: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Købmagergade 32',
                          style: t.titleLarge?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'København',
                          style: t.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.78),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpace.md),
              Text(
                'Besök vår nya flagship store i hjärtat av Köpenhamn.',
                style: t.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HudprofilKort extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return PressableCard(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const ScanResultatView(),
        ),
      ),
      child: Column(
        children: [
          ScrimImage(
            asset: 'assets/images/hem-editorial.jpg',
            aspectRatio: 2.15,
            alignment: const Alignment(0, -0.1),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.card),
            ),
            overlay: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Glow-index',
                  style: t.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: AppSpace.xs),
                Text(
                  '82',
                  style: t.displayLarge?.copyWith(
                    fontSize: 52,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpace.lg,
              AppSpace.md,
              AppSpace.lg,
              AppSpace.lg,
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    _MiniVarde(etikett: 'Fukt', varde: '74'),
                    _Skiljelinje(),
                    _MiniVarde(etikett: 'Jämnhet', varde: '81'),
                    _Skiljelinje(),
                    _MiniVarde(etikett: 'Röda toner', varde: '68'),
                  ],
                ),
                const SizedBox(height: AppSpace.md),
                BrandButton(
                  label: 'Skanna igen',
                  icon: LucideIcons.scanFace,
                  style: BrandButtonStyle.secondary,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const HudscanView(pushad: true),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniVarde extends StatelessWidget {
  const _MiniVarde({required this.etikett, required this.varde});

  final String etikett;
  final String varde;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        children: [
          Text(varde, style: t.titleLarge),
          const SizedBox(height: 2),
          Text(etikett, style: t.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _Skiljelinje extends StatelessWidget {
  const _Skiljelinje();

  @override
  Widget build(BuildContext context) => const SizedBox(
        height: 34,
        child: VerticalDivider(width: 1, color: AppColors.hairline),
      );
}

class _NastaStegKort extends StatelessWidget {
  const _NastaStegKort();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return PressableCard(
      padding: const EdgeInsets.all(AppSpace.md),
      child: Row(
        children: [
          const SizedBox(
            width: 58,
            child: PlateImage(
              asset: 'assets/images/produkt-wake-me-up.jpg',
              aspectRatio: 1,
              inset: 6,
            ),
          ),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Wake Me Up Cream', style: t.titleMedium),
                const SizedBox(height: 2),
                Text('Steg 2 av 4 · morgon', style: t.bodySmall),
              ],
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accentSoft,
            ),
            child: const Icon(
              LucideIcons.check,
              size: 20,
              color: AppColors.accentStrong,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProduktRailKort extends StatelessWidget {
  const _ProduktRailKort({required this.index});

  final int index;

  static const _data = [
    ('Dewy Drops Serum Concealer', 'assets/images/produkt-dewy-concealer.jpg'),
    ('Glow Blush', 'assets/images/produkt-glow-blush.jpg'),
    ('Dewy Drops', 'assets/images/produkt-dewy-drops.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final (namn, bild) = _data[index];

    return Container(
      padding: const EdgeInsets.all(AppSpace.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PlateImage(asset: bild, aspectRatio: 1.15, inset: 8),
          const SizedBox(height: AppSpace.md),
          Text(namn, style: t.titleMedium, maxLines: 2),
          const SizedBox(height: AppSpace.xs),
          Text('92 % match', style: t.bodySmall),
        ],
      ),
    );
  }
}
