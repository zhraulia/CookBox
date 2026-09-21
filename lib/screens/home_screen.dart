import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../widgets/cookbox_logo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _heroImage =
      'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=85';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth > 600
                ? constraints.maxWidth * 0.2
                : AppSpacing.page;
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                AppSpacing.top,
                horizontalPadding,
                AppSpacing.page,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _HomeHeader(),
                    const SizedBox(height: AppSpacing.section),
                    const _CategoryChip(),
                    const SizedBox(height: AppSpacing.field),
                    const _TodayHero(imageUrl: _heroImage),
                    const SizedBox(height: AppSpacing.section),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Keunggulan CookBox',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text('Anti Ribet'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.small),
                    const _AdvantageTile(
                      icon: Icons.hourglass_bottom_rounded,
                      iconBackground: Color(0xFFFFDAD0),
                      iconColor: AppColors.accent,
                      title: 'Bahan Sudah Ditakar',
                      description:
                          'Takaran sesuai resep dan jumlah porsi. Noli sia...',
                    ),
                    const SizedBox(height: AppSpacing.small),
                    const _AdvantageTile(
                      icon: Icons.account_balance_wallet_outlined,
                      iconBackground: Color(0xFFC7FFD4),
                      iconColor: Color(0xFF28B957),
                      title: 'Praktis & Hemat',
                      description:
                          'Tidak perlu belanja bahan satu per satu ke pasar.',
                    ),
                    const SizedBox(height: AppSpacing.small),
                    const _AdvantageTile(
                      icon: Icons.storefront_outlined,
                      iconBackground: Color(0xFFFFD9D1),
                      iconColor: AppColors.accent,
                      title: 'Dukung UMKM Lokal',
                      description:
                          'Pesan paket bahan secara langsung dari pedagang.',
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CookBoxLogo(compact: true),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE1D7),
            borderRadius: BorderRadius.circular(AppSpacing.compactRadius),
          ),
          child: Text(
            'Masak Praktis, Bahan Pas',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.primaryDark,
              fontSize: 8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Spacer(),
        Container(
          width: AppSpacing.backButton,
          height: AppSpacing.backButton,
          decoration: const BoxDecoration(
            color: Color(0xFFE8F0FF),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.help_outline, size: 16),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE4DB),
        borderRadius: BorderRadius.circular(AppSpacing.compactRadius),
      ),
      child: const Text(
        'Masak Praktis, Bahan Pas',
        style: TextStyle(
          color: AppColors.primaryDark,
          fontSize: 8,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _TodayHero extends StatelessWidget {
  const _TodayHero({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radius),
      child: Container(
        color: AppColors.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 172,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const _HeroFallback(),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.72),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.compactRadius,
                        ),
                      ),
                      child: const Text(
                        '✓ 100% Porsi Tepat',
                        style: TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 12,
                    bottom: 12,
                    child: Text(
                      'SOLUSI KOST & KAMPUS\nMau masak hari ini?',
                      style: TextStyle(
                        color: AppColors.surface,
                        fontSize: 18,
                        height: 1.12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              child: Text(
                'Pilih menu favoritmu, kami siapkan bahan segar yang sudah dipotong & ditakar pas untuk porsi kamu. Tinggal olah!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.muted,
                  fontSize: 10,
                  height: 1.45,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 4),
              child: SizedBox(
                width: double.infinity,
                height: 42,
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward, size: 14),
                  label: const Text('Mulai Sekarang'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radius),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text.rich(
                  TextSpan(
                    text: 'Sudah punya akun? ',
                    style: TextStyle(color: AppColors.muted, fontSize: 9),
                    children: [
                      TextSpan(
                        text: 'Masuk di sini',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _HeroFallback extends StatelessWidget {
  const _HeroFallback();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF9A6C43),
      child: Center(
        child: Icon(
          Icons.restaurant_menu,
          size: 60,
          color: Colors.white.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}

class _AdvantageTile extends StatelessWidget {
  const _AdvantageTile({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: AppColors.infoBackground,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 17),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.muted, fontSize: 8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
