import 'package:flutter/material.dart';

import '../data/item_repository.dart';
import '../models/item.dart';
import '../theme/app_colors.dart';

class DetailMenuScreen extends StatefulWidget {
  const DetailMenuScreen({super.key, required this.item});
  final Item item;

  @override
  State<DetailMenuScreen> createState() => _DetailMenuScreenState();
}

class _DetailMenuScreenState extends State<DetailMenuScreen> {
  bool _favorite = false;
  int _quantity = 1;
  String _tab = 'Komposisi Bahan';
  final _tabs = const ['Komposisi Bahan', 'Cara Masak', 'Info UMKM'];

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final recommendedItem = ItemRepository.findById(item.recommendedItemId);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Detail Menu',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () => setState(() => _favorite = !_favorite),
            icon: Icon(
              _favorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: _favorite ? AppColors.accent : null,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 235,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.12),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.network(
                    item.imageUrl ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const _Fallback(),
                  ),
                ),
              ),
              Positioned(
                left: 14,
                right: 14,
                bottom: 13,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.94),
                    borderRadius: BorderRadius.circular(14),
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
                      const Icon(Icons.star_rounded, color: Color(0xFFF2A900)),
                      const SizedBox(width: 4),
                      Text(
                        '${item.rating ?? 0}',
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _MenuSummary(item: item),
          const SizedBox(height: 18),
          _FactsCard(item: item),
          const SizedBox(height: 18),
          _AdditionalInfoCard(item: item, recommendedItem: recommendedItem),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFEFE5DD),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: List.generate(
                _tabs.length,
                (index) => Expanded(
                  child: _TabButton(
                    label: _tabs[index],
                    selected: _tab == _tabs[index],
                    onTap: () => setState(() => _tab = _tabs[index]),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          if (_tab == 'Komposisi Bahan') _buildIngredients(item),
          if (_tab == 'Cara Masak') _buildCookingSteps(),
          if (_tab == 'Info UMKM') _buildUkmInfo(item),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 9, 16, 9),
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
                    Text(
                      'Total',
                      style: TextStyle(color: AppColors.muted, fontSize: 9),
                    ),
                    Text(
                      item.priceLabel,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => setState(
                        () => _quantity = _quantity > 1 ? _quantity - 1 : 1,
                      ),
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text(
                      '$_quantity',
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(width: 7),
                    IconButton(
                      onPressed: () => setState(() => _quantity++),
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Tambah ke Keranjang'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIngredients(Item item) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '100% Segar & Higienis',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          ...item.ingredients.map(
            (ingredient) => Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(child: Text(ingredient)),
                  const Icon(
                    Icons.check_rounded,
                    color: Color(0xFF247A4D),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCookingSteps() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Langkah sederhana',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          const _Step(number: 1, text: 'Bersih-bersih bahan dan potong daging'),
          const _Step(number: 2, text: 'Panggang dengan suhu maksimum 180°C'),
          const _Step(number: 3, text: 'Sajikan dengan kemasan hygienis'),
        ],
      ),
    );
  }

  Widget _buildUkmInfo(Item item) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tentang UMKM',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            item.merchantName,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 5),
          Text(
            'Dikelola dengan standar kebersihan dan bahan lokal.',
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 11,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuSummary extends StatelessWidget {
  const _MenuSummary({required this.item});
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.border),
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
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.tagBackground,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Text(
                  'Paket Masak',
                  style: TextStyle(
                    color: Color(0xFF247A4D),
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.description,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 11,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                size: 16,
                color: AppColors.accent,
              ),
              const SizedBox(width: 7),
              const Text(
                '15 Mnt',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              const Icon(
                Icons.restaurant_rounded,
                size: 16,
                color: AppColors.accent,
              ),
              const SizedBox(width: 7),
              const Text(
                'Sangat Mudah',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FactsCard extends StatelessWidget {
  const _FactsCard({required this.item});
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Fact(
              icon: Icons.scale_outlined,
              label: 'Berat',
              value: item.weight ?? 'Belum tersedia',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _Fact(
              icon: Icons.inventory_2_outlined,
              label: 'Stok',
              value: '${item.stock ?? 0} paket',
            ),
          ),
        ],
      ),
    );
  }
}

class _AdditionalInfoCard extends StatelessWidget {
  const _AdditionalInfoCard({
    required this.item,
    required this.recommendedItem,
  });
  final Item item;
  final Item? recommendedItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informasi tambahan',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.timer_outlined,
            title: 'Durasi memasak',
            value: item.cookingDuration ?? 'Belum tersedia',
          ),
          const SizedBox(height: 10),
          _InfoRow(
            icon: Icons.inventory_outlined,
            title: 'Jangka simpan',
            value: item.storageDuration ?? 'Belum tersedia',
          ),
          const SizedBox(height: 10),
          _InfoRow(
            icon: Icons.check_circle_outline,
            title: 'Bahan segar & higienis',
            value:
                item.freshnessNote ?? 'Bahan dipilih dengan standar kebersihan',
          ),
          const SizedBox(height: 15),
          const Text(
            'Menu tambahan',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children:
                (item.additionalMenu.isEmpty
                        ? const ['Menu tambahan belum tersedia']
                        : item.additionalMenu)
                    .map(
                      (menu) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE4DB),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Text(
                          menu,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 15),
          const Text(
            'Rekomendasi menu',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 7),
          recommendedItem == null
              ? Text(
                  'Menu rekomendasi belum tersedia.',
                  style: const TextStyle(color: AppColors.muted, fontSize: 9),
                )
              : _RecommendedMenuCard(item: recommendedItem!),
        ],
      ),
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
        borderRadius: BorderRadius.circular(13),
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
                errorBuilder: (_, __, ___) => const _Fallback(),
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
            size: 14,
            color: AppColors.muted,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });
  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE4DB),
            borderRadius: BorderRadius.circular(10),
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
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE4DB),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 17),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: AppColors.muted, fontSize: 8),
              ),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
            ],
          ),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        minimumSize: Size.zero,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? AppColors.primary : AppColors.muted,
          fontSize: 9,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.number, required this.text});
  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 23,
            height: 23,
            decoration: const BoxDecoration(
              color: Color(0xFFFFE4DB),
              shape: BoxShape.circle,
            ),
            child: Text(
              '$number',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 9,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 10, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(Icons.restaurant_rounded, color: AppColors.accent, size: 45),
    );
  }
}
