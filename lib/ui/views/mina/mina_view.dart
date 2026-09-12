import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../kit.dart';

/// Mina: profil + favoritter med riktiga sektionsavstånd (inga zero-gap-kort).
class MinaView extends StatelessWidget {
  const MinaView({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final pad = tabContentPadding(context);

    return CustomScrollView(
      primary: true,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding:
              EdgeInsets.fromLTRB(pad.left, pad.top, pad.right, pad.bottom),
          sliver: SliverList.list(
            children: [
              Text('Mina', style: t.displayMedium),
              const SizedBox(height: AppSpace.lg),
              Transform.translate(
                offset: const Offset(0, 4),
                child: const _ProfilKort(),
              ),
              const SizedBox(height: AppSpace.section),
              const SectionHeader(title: 'Favoriter'),
              const SizedBox(height: AppSpace.lg),
              const _FavoritKort(
                namn: 'Dewy Drops Serum Concealer',
                bild: 'assets/images/produkt-dewy-concealer.jpg',
              ),
              const SizedBox(height: AppSpace.lg),
              const _FavoritKort(
                namn: 'Glow Blush',
                bild: 'assets/images/produkt-glow-blush.jpg',
              ),
              const SizedBox(height: AppSpace.section),
              const SectionHeader(title: 'Inställningar'),
              const SizedBox(height: AppSpace.lg),
              const _InstallningRad(
                ikon: LucideIcons.bell,
                titel: 'Notiser',
                undertext: 'Produktnyheter och tips',
              ),
              const SizedBox(height: AppSpace.lg),
              const _InstallningRad(
                ikon: LucideIcons.shield,
                titel: 'Integritet',
                undertext: 'Hur vi hanterar din huddata',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfilKort extends StatelessWidget {
  const _ProfilKort();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return PressableCard(
      padding: const EdgeInsets.all(AppSpace.lg),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.plateHigh,
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              'assets/images/ansikte-scan.jpg',
              fit: BoxFit.cover,
              alignment: const Alignment(0, -0.2),
            ),
          ),
          const SizedBox(width: AppSpace.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Emma Lindström', style: t.titleLarge),
                const SizedBox(height: 2),
                Text('Normal hud · neutral underton', style: t.bodySmall),
              ],
            ),
          ),
          const Icon(
            LucideIcons.chevronRight,
            size: 18,
            color: AppColors.inkMuted,
          ),
        ],
      ),
    );
  }
}

class _FavoritKort extends StatelessWidget {
  const _FavoritKort({required this.namn, required this.bild});

  final String namn;
  final String bild;

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
          Expanded(child: Text(namn, style: t.titleMedium)),
          const Icon(
            LucideIcons.heart,
            size: 18,
            color: AppColors.accentStrong,
          ),
        ],
      ),
    );
  }
}

class _InstallningRad extends StatelessWidget {
  const _InstallningRad({
    required this.ikon,
    required this.titel,
    required this.undertext,
  });

  final IconData ikon;
  final String titel;
  final String undertext;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return PressableCard(
      padding: const EdgeInsets.all(AppSpace.lg),
      child: Row(
        children: [
          Icon(ikon, size: 20, color: AppColors.ink),
          const SizedBox(width: AppSpace.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titel, style: t.titleMedium),
                const SizedBox(height: 2),
                Text(undertext, style: t.bodySmall),
              ],
            ),
          ),
          const Icon(
            LucideIcons.chevronRight,
            size: 18,
            color: AppColors.inkMuted,
          ),
        ],
      ),
    );
  }
}
