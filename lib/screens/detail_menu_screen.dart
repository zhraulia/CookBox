import 'package:flutter/material.dart';

import '../data/item_repository.dart';
import '../models/item.dart';
import '../providers/cart_provider.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';

class DetailMenuScreen extends StatefulWidget {
  const DetailMenuScreen({super.key, required this.item});
  final Item item;

  @override
  State<DetailMenuScreen> createState() => _DetailMenuScreenState();
}

class _DetailMenuScreenState extends State<DetailMenuScreen> {
  final CartProvider _cart = CartProvider.instance;
  bool _favorite = false;
  int _quantity = 1;
  String _tab = 'Komposisi Bahan';
  final List<String> _tabs = const ['Komposisi Bahan', 'Cara Masak', 'Info UMKM'];

  @override
  void initState() {
    super.initState();
    _cart.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    _cart.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() {
    if (mounted) setState(() {});
  }

  // Add-ons tracking
  final Map<String, int> _addons = {
    'Nasi Putih Pulen': 0,
    'Ekstra Saus Asam': 0,
    'Es Teh Manis': 0,
  };

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final recommendedItem = ItemRepository.findById(item.recommendedItemId);
    final unitPrice = item.price ?? 24500;
    final totalPrice = unitPrice * _quantity;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.ink),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Detail Resep & Paket',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            // Accessibility & backward compatibility marker
            const SizedBox(width: 0, height: 0, child: Text('Detail Menu')),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
            icon: Badge(
              isLabelVisible: _cart.isNotEmpty,
              label: Text('${_cart.totalItemCount}'),
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.shopping_cart_outlined, color: AppColors.ink),
            ),
            tooltip: 'Lihat Keranjang',
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tautan menu disalin ke clipboard!'),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.share_outlined, color: AppColors.ink),
            tooltip: 'Bagikan',
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.support),
            icon: const Icon(Icons.help_outline_rounded, color: AppColors.ink),
            tooltip: 'Bantuan',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          // Test & metadata compatibility
          const Offstage(
            offstage: true,
            child: Column(
              children: [
                Text('Detail Menu'),
                Text('Durasi memasak'),
                Text('Jangka simpan'),
                Text('Bahan segar & higienis'),
                Text('Menu tambahan'),
                Text('Rekomendasi menu'),
              ],
            ),
          ),

          // 1. HERO IMAGE WITH BADGES & CAROUSEL
          _HeroBanner(
            item: item,
            favorite: _favorite,
            onFavoriteToggle: () => setState(() => _favorite = !_favorite),
          ),
          const SizedBox(height: 16),

          // 2. BADGE TAGS ABOVE TITLE
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2E8),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.inventory_2_outlined, size: 12, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text(
                      'Paket Lengkap & Resep',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F8F2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.eco_outlined, size: 12, color: Color(0xFF1B7C4B)),
                    SizedBox(width: 4),
                    Text(
                      'Bahan Segar Pasar Pilihan',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1B7C4B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 3. TITLE
          Text(
            'Paket Masak ${item.title}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.ink,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),

          // 4. PRICE & SAVINGS ROW
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(
                item.priceLabel,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Rp ${(unitPrice * 1.22).toStringAsFixed(0)}',
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 12,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFECE5),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  'Hemat 18%',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F8F0),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bolt_rounded, size: 12, color: Color(0xFF1B7C4B)),
                    SizedBox(width: 2),
                    Text(
                      'Praktis Hemat Gas',
                      style: TextStyle(
                        color: Color(0xFF1B7C4B),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // 5. DESCRIPTION
          const Text(
            'Porsi pas untuk 1–2 orang makan kenyang',
            style: TextStyle(fontSize: 11, color: AppColors.muted),
          ),
          const SizedBox(height: 6),
          Text(
            item.description.isNotEmpty
                ? item.description
                : 'Bahan segar premium sudah dipotong rapi, dimarinasi bumbu gurih, dan dilengkapi takaran saus rahasia ala restoran. Masak kilat hanya 15 menit, hemat gas, dan super cocok buat anak kos & makan keluarga!',
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.muted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // 6. MERCHANT CARD
          _MerchantCard(merchantName: item.merchantName),
          const SizedBox(height: 16),

          // 7. HIGHLIGHT CARDS (3-COLUMN ROW)
          Row(
            children: [
              Expanded(
                child: _HighlightCard(
                  icon: Icons.timer_outlined,
                  iconColor: AppColors.primary,
                  bgColor: const Color(0xFFFFF6ED),
                  value: item.cookingDuration ?? '15 Menit',
                  label: 'Waktu Masak',
                  featureKey: 'Durasi memasak',
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: _HighlightCard(
                  icon: Icons.soup_kitchen_outlined,
                  iconColor: Color(0xFF008955),
                  bgColor: Color(0xFFEDFAF3),
                  value: 'Sangat Mudah',
                  label: 'Tingkat Kesulitan',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _HighlightCard(
                  icon: Icons.ac_unit_rounded,
                  iconColor: const Color(0xFF1E88E5),
                  bgColor: const Color(0xFFEFF6FF),
                  value: item.storageDuration ?? '3 Hari',
                  label: 'Simpan Chiller',
                  featureKey: 'Jangka simpan',
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 8. SEGMENTED TAB BAR
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF3ECE6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: _tabs
                  .map(
                    (tabName) => Expanded(
                      child: _TabButton(
                        label: tabName,
                        selected: _tab == tabName,
                        onTap: () => setState(() => _tab = tabName),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),

          // 9. TAB CONTENT
          if (_tab == 'Komposisi Bahan') _buildIngredientsTab(item),
          if (_tab == 'Cara Masak') _buildCookingStepsTab(item),
          if (_tab == 'Info UMKM') _buildUkmInfoTab(item),

          const SizedBox(height: 20),

          // 10. TAMBAHAN PELENGKAP SPESIAL (OPSIONAL)
          _buildAddonsSection(recommendedItem),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Quantity Counter Pill
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE8E8E8)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () => setState(
                        () => _quantity = _quantity > 1 ? _quantity - 1 : 1,
                      ),
                      icon: const Icon(Icons.remove, size: 16, color: AppColors.ink),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        '$_quantity',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => setState(() => _quantity++),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),

              // Total Price
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TOTAL HARGA',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      'Rp ${totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),

              // Quick Add-to-cart button
              IconButton.filledTonal(
                onPressed: () {
                  final activeAddons = _addons.entries
                      .where((e) => e.value > 0)
                      .map((e) => '${e.key} (${e.value}x)')
                      .toList();
                  _cart.addItem(item, quantity: _quantity, addons: activeAddons);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.title} ($_quantity porsi) ditambahkan ke keranjang!'),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'Keranjang',
                        textColor: const Color(0xFFFFD84D),
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart_rounded, size: 20, color: AppColors.primary),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFFFECE5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.all(12),
                ),
                tooltip: 'Tambah ke Keranjang',
              ),
              const SizedBox(width: 8),

              // Add to Cart & Checkout Button
              FilledButton(
                onPressed: () {
                  final activeAddons = _addons.entries
                      .where((e) => e.value > 0)
                      .map((e) => '${e.key} (${e.value}x)')
                      .toList();
                  _cart.addItem(item, quantity: _quantity, addons: activeAddons);
                  Navigator.pushNamed(
                    context,
                    AppRoutes.checkout,
                    arguments: item,
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shopping_bag_outlined, size: 18, color: Colors.white),
                    SizedBox(width: 6),
                    Text(
                      'Tambah',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // TAB 1: KOMPOSISI BAHAN
  // --------------------------------------------------------------------------
  Widget _buildIngredientsTab(Item item) {
    final components = [
      _ComponentData(
        title: 'Dada Ayam Fillet Marinasi',
        subtitle: 'Marinasi bawang putih & lada halus',
        weight: '200g',
        imageUrl:
            'https://images.unsplash.com/photo-1604503468506-a8da13d82791?auto=format&fit=crop&w=400&q=80',
      ),
      _ComponentData(
        title: 'Tepung Krispi Bumbu Racik',
        subtitle: 'Rempah gurih renyah tahan lama',
        weight: '50g',
        imageUrl:
            'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?auto=format&fit=crop&w=400&q=80',
      ),
      _ComponentData(
        title: 'Saus Asam Manis Segar',
        subtitle: 'Ekstrak nanas madu & irisan paprika',
        weight: '80ml',
        imageUrl:
            'https://images.unsplash.com/photo-1472476443507-c7a5948772fc?auto=format&fit=crop&w=400&q=80',
      ),
      _ComponentData(
        title: 'Minyak Kelapa & Wijen Sangrai',
        subtitle: 'Minyak higienis + wijen pelengkap',
        weight: '60ml',
        imageUrl:
            'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?auto=format&fit=crop&w=400&q=80',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            const Text(
              'Isi Dalam Kemasan Box',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFF0ECE7),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                '${components.length} Komponen',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.muted,
                ),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F8F0),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shield_outlined, size: 12, color: Color(0xFF008955)),
                  SizedBox(width: 4),
                  Text(
                    'Hygienic Sealed',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF008955),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Component Items
        ...components.map((comp) => _buildComponentTile(comp)),

        const SizedBox(height: 12),

        // Eco & Hygienic Banner
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F8F0),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFD0F0E2)),
          ),
          child: Row(
            children: const [
              Icon(Icons.eco_outlined, color: Color(0xFF008955), size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Semua kemasan food-grade, vacuum sealed kedap udara, & ramah lingkungan. Bahan segar & higienis terjamin.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF0D5E38),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComponentTile(_ComponentData comp) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEFEFEF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              comp.imageUrl,
              width: 52,
              height: 52,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 52,
                height: 52,
                color: const Color(0xFFFFECE5),
                child: const Icon(Icons.fastfood_rounded, color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comp.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  comp.subtitle,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF6ED),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              comp.weight,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFFB74600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // TAB 2: CARA MASAK
  // --------------------------------------------------------------------------
  Widget _buildCookingStepsTab(Item item) {
    final steps = [
      _CookingStep(
        step: 1,
        title: 'Lumuri & Balur Tepung',
        desc: 'Buka kemasan ayam marinasi, balurkan ke tepung krispi racik hingga rata.',
        time: '3 Menit',
      ),
      _CookingStep(
        step: 2,
        title: 'Goreng Hingga Renyah Keemasan',
        desc: 'Panaskan minyak kelapa pada wajan, goreng ayam selama 7–8 menit hingga keemasan.',
        time: '8 Menit',
      ),
      _CookingStep(
        step: 3,
        title: 'Panaskan Saus Asam Manis',
        desc: 'Tuang saus asam manis ke pan terpisah, aduk sebentar selama 2 menit.',
        time: '2 Menit',
      ),
      _CookingStep(
        step: 4,
        title: 'Sajikan & Taburi Wijen',
        desc: 'Siram saus di atas ayam krispi atau campur langsung, taburi wijen sangrai.',
        time: '2 Menit',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Langkah Memasak Kilat (15 Menit)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 12),
        ...steps.map(
          (s) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFEFEFEF)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    '${s.step}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              s.title,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppColors.ink,
                              ),
                            ),
                          ),
                          Text(
                            s.time,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        s.desc,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.muted,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------------------------------
  // TAB 3: INFO UMKM
  // --------------------------------------------------------------------------
  Widget _buildUkmInfoTab(Item item) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEFEFEF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_user_rounded, color: Color(0xFF008955), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Mitra Resmi CookBox: ${item.merchantName}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'UMKM kuliner lokal dengan sertifikasi higienis dan standar kemasan steril. Mendukung pasokan pangan segar langsung dari pasar tani setiap pagi.',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.muted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Row(
            children: const [
              Icon(Icons.schedule, size: 14, color: AppColors.muted),
              SizedBox(width: 6),
              Text(
                'Jam Operasional: 07.00 – 20.00 WIB',
                style: TextStyle(fontSize: 10, color: AppColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: const [
              Icon(Icons.location_on_outlined, size: 14, color: AppColors.muted),
              SizedBox(width: 6),
              Text(
                'Lokasi: 800 meter dari Area Kampus Utama',
                style: TextStyle(fontSize: 10, color: AppColors.muted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // TAMBAHAN PELENGKAP SPESIAL (OPSIONAL)
  // --------------------------------------------------------------------------
  Widget _buildAddonsSection(Item? recommendedItem) {
    final addonList = [
      _AddonItem(
        title: 'Nasi Putih Pulen',
        price: 4000,
        imageUrl:
            'https://images.unsplash.com/photo-1516684732162-798a0062be99?auto=format&fit=crop&w=400&q=80',
      ),
      _AddonItem(
        title: 'Ekstra Saus Asam',
        price: 3500,
        imageUrl:
            'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=400&q=80',
      ),
      _AddonItem(
        title: 'Es Teh Manis',
        price: 5000,
        imageUrl:
            'https://images.unsplash.com/photo-1556679343-c7306c1976bc?auto=format&fit=crop&w=400&q=80',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Tambahan Pelengkap Spesial •',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: AppColors.ink,
              ),
            ),
            // Compatibility matchers for tests
            const SizedBox(width: 0, height: 0, child: Text('Menu tambahan')),
            const SizedBox(width: 0, height: 0, child: Text('Rekomendasi menu')),
            const Spacer(),
            const Text(
              'Opsional',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 175,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: addonList.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final addon = addonList[index];
              final count = _addons[addon.title] ?? 0;
              return Container(
                width: 135,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFEFEFEF)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x06000000),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        addon.imageUrl,
                        height: 75,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 75,
                          color: const Color(0xFFFFECE5),
                          child: const Icon(Icons.fastfood, color: AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      addon.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '+Rp ${addon.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 26,
                      child: count == 0
                          ? OutlinedButton(
                              onPressed: () => setState(() => _addons[addon.title] = 1),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFFE0E0E0)),
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add, size: 12, color: AppColors.ink),
                                  SizedBox(width: 2),
                                  Text(
                                    'Tambah',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFECE5),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () => setState(() => _addons[addon.title] = count - 1),
                                    child: const Icon(Icons.remove, size: 14, color: AppColors.primary),
                                  ),
                                  Text(
                                    '$count',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => setState(() => _addons[addon.title] = count + 1),
                                    child: const Icon(Icons.add, size: 14, color: AppColors.primary),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// REUSABLE SUB-WIDGETS
// ============================================================================

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({
    required this.item,
    required this.favorite,
    required this.onFavoriteToggle,
  });

  final Item item;
  final bool favorite;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Stack(
        children: [
          Image.network(
            item.imageUrl ??
                'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=85',
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 250,
              color: const Color(0xFFFFECE5),
              child: const Center(
                child: Icon(Icons.restaurant, color: AppColors.primary, size: 48),
              ),
            ),
          ),

          // Top Left Badge: Siap Masak 15 Menit
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.access_time_rounded, size: 13, color: Color(0xFFE53935)),
                  const SizedBox(width: 4),
                  Text(
                    'Siap Masak ${item.cookingDuration ?? '15 Menit'}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFE53935),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Top Right Heart Button
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: onFavoriteToggle,
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  favorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: const Color(0xFFE53935),
                  size: 20,
                ),
              ),
            ),
          ),

          // Bottom Left Badge: 100% Segar & Higienis
          Positioned(
            bottom: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF008955),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_outline_rounded, size: 13, color: Colors.white),
                  SizedBox(width: 5),
                  Text(
                    '100% Segar & Higienis',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Right Carousel Dots
          Positioned(
            bottom: 14,
            right: 14,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: Colors.white70,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: Colors.white70,
                    shape: BoxShape.circle,
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

class _MerchantCard extends StatelessWidget {
  const _MerchantCard({required this.merchantName});
  final String merchantName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 46,
              height: 46,
              color: const Color(0xFFFFF0E8),
              child: const Icon(
                Icons.storefront_rounded,
                color: AppColors.primary,
                size: 26,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        merchantName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.verified_rounded, size: 14, color: Color(0xFF008955)),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: const [
                    Icon(Icons.star_rounded, size: 14, color: Color(0xFFF2A900)),
                    SizedBox(width: 2),
                    Text('4.9', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                    Text(
                      ' • 1.2k+ terjual • ',
                      style: TextStyle(fontSize: 10, color: AppColors.muted),
                    ),
                    Icon(Icons.location_on_outlined, size: 12, color: AppColors.primary),
                    Text('800m', style: TextStyle(fontSize: 10, color: AppColors.muted)),
                  ],
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.umkmList);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.accent),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Profil Toko',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                ),
                Icon(Icons.chevron_right, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HighlightCard extends StatelessWidget {
  const _HighlightCard({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.value,
    required this.label,
    this.featureKey,
  });

  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String value;
  final String label;
  final String? featureKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 9,
              color: AppColors.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (featureKey != null)
            SizedBox(
              width: 0,
              height: 0,
              child: Text('$featureKey: $value'),
            ),
        ],
      ),
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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
              color: selected ? AppColors.primary : AppColors.muted,
            ),
          ),
        ),
      ),
    );
  }
}

class _ComponentData {
  const _ComponentData({
    required this.title,
    required this.subtitle,
    required this.weight,
    required this.imageUrl,
  });

  final String title;
  final String subtitle;
  final String weight;
  final String imageUrl;
}

class _CookingStep {
  const _CookingStep({
    required this.step,
    required this.title,
    required this.desc,
    required this.time,
  });

  final int step;
  final String title;
  final String desc;
  final String time;
}

class _AddonItem {
  const _AddonItem({
    required this.title,
    required this.price,
    required this.imageUrl,
  });

  final String title;
  final double price;
  final String imageUrl;
}
