import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../kit.dart';

class _Produkt {
  const _Produkt({
    required this.namn,
    required this.bild,
    required this.match,
    required this.pris,
  });

  final String namn;
  final String bild;
  final int match;
  final String pris;
}

const _produkter = [
  _Produkt(
    namn: 'Dewy Drops Serum Concealer',
    bild: 'assets/images/produkt-dewy-concealer.jpg',
    match: 94,
    pris: '295 kr',
  ),
  _Produkt(
    namn: 'Wake Me Up Cream',
    bild: 'assets/images/produkt-wake-me-up.jpg',
    match: 91,
    pris: '295 kr',
  ),
  _Produkt(
    namn: 'Glow Blush',
    bild: 'assets/images/produkt-glow-blush.jpg',
    match: 88,
    pris: '295 kr',
  ),
  _Produkt(
    namn: 'Dewy Drops',
    bild: 'assets/images/produkt-dewy-drops.jpg',
    match: 86,
    pris: '375 kr',
  ),
];

/// Rekommendationer rankade mot hudprofil — accent-owned banner + bild↔label.
class ForDigView extends StatelessWidget {
  const ForDigView({super.key});

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
                  Icon(LucideIcons.heart, size: 22, color: AppColors.ink),
                ],
              ),
              const SizedBox(height: AppSpace.lg),
              Text('För dig', style: t.displayMedium),
              const SizedBox(height: AppSpace.sm),
              Text(
                'Rankat mot din senaste scanning · igår',
                style: t.bodySmall,
              ),
              const SizedBox(height: AppSpace.lg),
              Transform.translate(
                offset: const Offset(-6, 0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpace.lg),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    boxShadow: AppShadows.cardShadow,
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.image),
                        child: Image.asset(
                          'assets/images/ansikte-scan.jpg',
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                          alignment: const Alignment(0, -0.2),
                        ),
                      ),
                      const SizedBox(width: AppSpace.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Din hudprofil',
                              style: t.titleMedium?.copyWith(
                                color: AppColors.onAccent,
                              ),
                            ),
                            Text(
                              'Normal · neutral underton · Glow 82',
                              style: t.bodySmall?.copyWith(
                                color: AppColors.onAccent.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpace.lg),
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  boxShadow: AppShadows.cardShadow,
                ),
                child: const Row(
                  children: [
                    Icon(LucideIcons.search, size: 18, color: AppColors.inkMuted),
                    SizedBox(width: AppSpace.md),
                    Text(
                      'Sök produkter',
                      style: TextStyle(color: AppColors.inkFaint),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpace.md),
              const Wrap(
                spacing: AppSpace.sm,
                runSpacing: AppSpace.sm,
                children: [
                  _FilterChip(label: 'Alla', selected: true),
                  _FilterChip(label: 'Foundation'),
                  _FilterChip(label: 'Blush'),
                  _FilterChip(label: 'Concealer'),
                ],
              ),
              const SizedBox(height: AppSpace.lg),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.card),
                child: Image.asset(
                  'assets/images/kategori-lifestyle.jpg',
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  alignment: const Alignment(0, -0.1),
                ),
              ),
              const SizedBox(height: AppSpace.sm),
              Text('Utvalt för din hudton', style: t.titleSmall),
            ],
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            pad.left,
            AppSpace.md,
            pad.right,
            pad.bottom,
          ),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpace.lg,
              crossAxisSpacing: AppSpace.lg,
              childAspectRatio: 0.62,
            ),
            itemCount: _produkter.length,
            itemBuilder: (context, i) => _ProduktKort(produkt: _produkter[i]),
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpace.lg,
        vertical: AppSpace.sm,
      ),
      decoration: BoxDecoration(
        color: selected ? AppColors.accentSoft : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? AppColors.ink : AppColors.inkMuted,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _ProduktKort extends StatelessWidget {
  const _ProduktKort({required this.produkt});

  final _Produkt produkt;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return PressableCard(
      padding: const EdgeInsets.all(AppSpace.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: PlateImage(
              asset: produkt.bild,
              aspectRatio: 0.85,
              inset: 6,
            ),
          ),
          const SizedBox(height: AppSpace.md),
          Text(produkt.namn, style: t.titleSmall, maxLines: 2),
          const SizedBox(height: AppSpace.xs),
          Text('${produkt.match} % match', style: t.bodySmall),
          const SizedBox(height: 2),
          Text(produkt.pris, style: t.titleMedium),
        ],
      ),
    );
  }
}
