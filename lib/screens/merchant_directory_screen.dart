import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class MerchantDirectoryScreen extends StatefulWidget {
  const MerchantDirectoryScreen({super.key});
  @override
  State<MerchantDirectoryScreen> createState() =>
      _MerchantDirectoryScreenState();
}

class _MerchantDirectoryScreenState extends State<MerchantDirectoryScreen> {
  bool _selected = false;
  String _filter = 'Semua';
  final _filters = const ['Semua', 'Paket Masak', 'Segar', 'Hemat Kos'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Direktori UMKM',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: AppColors.accent),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Cari mitra atau katalog',
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list_rounded),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 30,
                    height: 30,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _Chip(
                  label: 'Terdekat < 1km',
                  selected: _selected,
                  onTap: () => setState(() => _selected = !_selected),
                ),
                const SizedBox(width: 8),
                _Chip(label: 'Bintang 4.8+', selected: false, onTap: () {}),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFB83B00), Color(0xFFF16A3A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.storefront_outlined,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dapur Barokah Kampus',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'Mitra verified • 1,248 pelanggan',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const _ProfileFact(
                      icon: Icons.schedule,
                      label: '08.00–20.00',
                    ),
                    const SizedBox(width: 8),
                    const _ProfileFact(
                      icon: Icons.location_on,
                      label: '0.8 km',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.message_rounded),
                        label: const Text('WhatsApp'),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(.15),
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withOpacity(.45),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.phone_rounded),
                        label: const Text('Hubungi'),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Katalog mitra',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                '12 menu',
                style: const TextStyle(color: AppColors.muted, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: _filters
                .map(
                  (filter) => _FilterChip(
                    label: filter,
                    selected: _filter == filter,
                    onTap: () => setState(() => _filter = filter),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          _MerchantMenuCard(
            title: 'Paket Sayur Serba Gizi',
            price: 'Rp 18.000',
            stock: true,
          ),
          _MerchantMenuCard(
            title: 'Nasi Goreng Campuran',
            price: 'Rp 21.500',
            stock: true,
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF7EF),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.eco_rounded,
                  color: Color(0xFF27845A),
                  size: 30,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dukung ketahanan pangan lokal',
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      Text(
                        'Dukung UMKM kampus & bahan lokal',
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 9,
                        ),
                      ),
                    ],
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

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => ActionChip(
    label: Text(
      label,
      style: TextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w800,
        color: selected ? AppColors.primary : AppColors.muted,
      ),
    ),
    avatar: selected ? const Icon(Icons.check, size: 12) : null,
    onPressed: onTap,
    backgroundColor: selected ? const Color(0xFFFFE4DB) : Colors.white,
    side: BorderSide(color: AppColors.border),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  );
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => FilterChip(
    label: Text(label, style: const TextStyle(fontSize: 9)),
    selected: selected,
    onSelected: (_) => onTap(),
    selectedColor: const Color(0xFFFFE4DB),
    checkmarkColor: AppColors.primary,
    side: const BorderSide(color: AppColors.border),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );
}

class _ProfileFact extends StatelessWidget {
  const _ProfileFact({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.13),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _MerchantMenuCard extends StatelessWidget {
  const _MerchantMenuCard({
    required this.title,
    required this.price,
    required this.stock,
  });
  final String title;
  final String price;
  final bool stock;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 9),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    ),
    child: Row(
      children: [
        Container(
          width: 61,
          height: 61,
          decoration: BoxDecoration(
            color: const Color(0xFFFFE7D7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.restaurant_rounded,
            color: AppColors.accent,
            size: 30,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
              Text(
                price,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFDDF2E7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Ready stock',
                  style: TextStyle(
                    color: Color(0xFF247A4D),
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.add_circle, color: AppColors.primary, size: 24),
      ],
    ),
  );
}
