import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../kit.dart';

/// Resultat efter hudscan — rekommendationer och hudprofil.
class ScanResultatView extends StatelessWidget {
  const ScanResultatView({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final safe = MediaQuery.paddingOf(context);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpace.screen,
                safe.top + AppSpace.lg,
                AppSpace.screen,
                AppSpace.section,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      AppHaptics.light();
                      Navigator.of(context).maybePop();
                    },
                    child: const Icon(
                      Icons.chevron_left,
                      size: 30,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: AppSpace.lg),
                  Text('Din hudprofil', style: t.displayMedium),
                  const SizedBox(height: AppSpace.sm),
                  Text('Baserat på din senaste scanning', style: t.bodySmall),
                  const SizedBox(height: AppSpace.lg),
                  PressableCard(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(AppRadius.card),
                          ),
                          child: Image.asset(
                            'assets/images/ansikte-scan.jpg',
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            alignment: const Alignment(0, -0.2),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(AppSpace.lg),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Glow-index', style: t.labelSmall),
                                    Text('82', style: t.displaySmall),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Hudtyp', style: t.labelSmall),
                                    Text('Normal', style: t.titleMedium),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpace.section),
                  Text('Rekommendationer', style: t.titleLarge),
                  const SizedBox(height: AppSpace.lg),
                  const _RekKort(
                    namn: 'Dewy Drops Serum Concealer',
                    bild: 'assets/images/produkt-dewy-concealer.jpg',
                    match: 94,
                  ),
                  const SizedBox(height: AppSpace.lg),
                  const _RekKort(
                    namn: 'Wake Me Up Cream',
                    bild: 'assets/images/produkt-wake-me-up.jpg',
                    match: 91,
                  ),
                  const SizedBox(height: AppSpace.xl),
                  BrandButton(
                    label: 'Se alla rekommendationer',
                    icon: LucideIcons.sparkles,
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  SizedBox(height: safe.bottom + AppSpace.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RekKort extends StatelessWidget {
  const _RekKort({
    required this.namn,
    required this.bild,
    required this.match,
  });

  final String namn;
  final String bild;
  final int match;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return PressableCard(
      padding: const EdgeInsets.all(AppSpace.md),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: PlateImage(asset: bild, aspectRatio: 1, inset: 6),
          ),
          const SizedBox(width: AppSpace.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(namn, style: t.titleMedium),
                const SizedBox(height: 2),
                Text('$match % match', style: t.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
