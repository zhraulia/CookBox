import 'package:flutter/material.dart';

import '../data/item_repository.dart';
import '../models/item.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';

typedef AddToCartCallback = void Function(Item item);

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.item, this.onAddToCart});

  final Item item;
  final AddToCartCallback? onAddToCart;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String? _catatan;
  bool _isFavorite = false;

  Future<void> _bukaFormCatatan() async {
    final hasil = await Navigator.pushNamed<String>(
      context,
      AppRoutes.catatanForm,
    );
    if (!mounted || hasil == null) return;

    setState(() => _catatan = hasil);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Catatan berhasil disimpan')));
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final rating = item.rating;
    final reviewCount = item.reviewCount;
    final recommendedItem = ItemRepository.findById(item.recommendedItemId);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Detail Menu',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          key: const ValueKey('detail-back'),
          tooltip: 'Kembali',
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        actions: [
          IconButton(
            tooltip: _isFavorite ? 'Hapus favorit' : 'Tambah favorit',
            onPressed: () => setState(() => _isFavorite = !_isFavorite),
            icon: Icon(
              _isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: _isFavorite ? AppColors.accent : null,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 245,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFB83B00).withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: SizedBox(
                    height: 245,
                    width: double.infinity,
                    child: item.imageUrl == null
                        ? const _DetailImageFallback()
                        : Image.network(
                            item.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const _DetailImageFallback(),
                          ),
                  ),
                ),
              ),
              Positioned(
                left: 14,
                right: 14,
                bottom: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.94),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: Color(0x1A000000), blurRadius: 10),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.priceLabel,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: Color(0xFFF2A900),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            rating == null ? '—' : rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.border),
              boxShadow: const [
                BoxShadow(color: Color(0x11000000), blurRadius: 12),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontSize: 21,
                          height: 1.15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _CategoryLabel(category: item.category),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 17,
                      color: Color(0xFFF2A900),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rating == null
                          ? 'Rating belum tersedia'
                          : rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (reviewCount != null) ...[
                      const SizedBox(width: 4),
                      Text(
                        '($reviewCount ulasan)',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _MerchantInfo(name: item.merchantName),
          const SizedBox(height: 18),
          const _DetailSectionTitle(title: 'Tentang menu'),
          const SizedBox(height: 6),
          Text(
            item.description.trim().isEmpty
                ? 'Informasi menu belum tersedia.'
                : item.description,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 12,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          const _DetailSectionTitle(title: 'Komposisi'),
          const SizedBox(height: 8),
          if (item.ingredients.isEmpty)
            const Text(
              'Informasi bahan belum tersedia.',
              style: TextStyle(color: AppColors.muted, fontSize: 11),
            )
          else
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: [
                for (final ingredient in item.ingredients)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE9DF),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(
                      ingredient,
                      style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _DetailFact(
                    icon: Icons.scale_outlined,
                    label: 'Berat',
                    value: item.weight ?? 'Belum tersedia',
                  ),
                ),
                Container(width: 1, height: 32, color: AppColors.border),
                Expanded(
                  child: _DetailFact(
                    icon: Icons.inventory_2_outlined,
                    label: 'Stok',
                    value: item.stock == null
                        ? 'Belum tersedia'
                        : '${item.stock} paket',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const _DetailSectionTitle(title: 'Informasi tambahan'),
          const SizedBox(height: 8),
          _InfoFeatureCard(
            icon: Icons.timer_outlined,
            title: 'Durasi memasak',
            value: item.cookingDuration ?? 'Belum tersedia',
          ),
          const SizedBox(height: 8),
          _InfoFeatureCard(
            icon: Icons.inventory_outlined,
            title: 'Jangka simpan',
            value: item.storageDuration ?? 'Belum tersedia',
          ),
          const SizedBox(height: 8),
          _InfoFeatureCard(
            icon: Icons.check_circle_outline,
            title: 'Bahan segar & higienis',
            value:
                item.freshnessNote ?? 'Bahan dipilih dengan standar kebersihan',
          ),
          const SizedBox(height: 18),
          const _DetailSectionTitle(title: 'Menu tambahan'),
          const SizedBox(height: 8),
          if (item.additionalMenu.isEmpty)
            Text(
              'Menu tambahan belum tersedia.',
              style: const TextStyle(color: AppColors.muted, fontSize: 11),
            )
          else
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: item.additionalMenu
                  .map(
                    (menu) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE9DF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        menu,
                        style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          const SizedBox(height: 18),
          const _DetailSectionTitle(title: 'Rekomendasi menu'),
          const SizedBox(height: 8),
          recommendedItem == null
              ? Text(
                  'Menu rekomendasi belum tersedia.',
                  style: const TextStyle(color: AppColors.muted, fontSize: 11),
                )
              : _RecommendedMenuCard(item: recommendedItem!),
          const SizedBox(height: 18),
          const _DetailSectionTitle(title: 'Catatan untuk menu'),
          const SizedBox(height: 6),
          Text(
            _catatan ?? 'Belum ada catatan.',
            style: const TextStyle(color: AppColors.muted, fontSize: 11),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _bukaFormCatatan,
            icon: const Icon(Icons.edit_note_rounded, size: 18),
            label: Text(_catatan == null ? 'Tulis Catatan' : 'Ubah Catatan'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.border),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Harga',
                      style: TextStyle(fontSize: 9, color: AppColors.muted),
                    ),
                    Text(
                      item.priceLabel,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                key: const ValueKey('detail-add'),
                onPressed: widget.onAddToCart == null
                    ? null
                    : () => widget.onAddToCart!(item),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Tambah'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(132, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryLabel extends StatelessWidget {
  const _CategoryLabel({required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 110),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE4DB),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        category,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: AppColors.primaryDark,
          fontSize: 8,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _MerchantInfo extends StatelessWidget {
  const _MerchantInfo({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE4DB),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.storefront_outlined,
              color: AppColors.primary,
              size: 19,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'UMKM penyedia',
                  style: TextStyle(fontSize: 9, color: AppColors.muted),
                ),
                Text(
                  name.isEmpty ? 'Informasi UMKM belum tersedia' : name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
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

class _DetailSectionTitle extends StatelessWidget {
  const _DetailSectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.ink,
        fontSize: 13,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _DetailFact extends StatelessWidget {
  const _DetailFact({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: AppColors.accent),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 8, color: AppColors.muted),
              ),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RecommendedMenuCard extends StatelessWidget {
  const _RecommendedMenuCard({required this.item});
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('recommended-menu-card'),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 82,
            height: 68,
            child: ClipRRect(
              key: const ValueKey('recommended-menu-image'),
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                item.imageUrl ?? '',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const _DetailImageFallback(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 3),
                Text(
                  item.merchantName,
                  style: const TextStyle(color: AppColors.muted, fontSize: 9),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 15,
            color: AppColors.muted,
          ),
        ],
      ),
    );
  }
}

class _InfoFeatureCard extends StatelessWidget {
  const _InfoFeatureCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE9DF),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: AppColors.primary, size: 17),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(color: AppColors.muted, fontSize: 9),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailImageFallback extends StatelessWidget {
  const _DetailImageFallback();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFFFFE7D7),
      child: Center(
        child: Icon(
          Icons.restaurant_rounded,
          color: AppColors.accent,
          size: 54,
        ),
      ),
    );
  }
}
