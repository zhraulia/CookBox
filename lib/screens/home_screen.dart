import 'package:flutter/material.dart';

import '../data/item_repository.dart';
import '../models/item.dart';
import '../providers/cart_provider.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../widgets/state_views.dart';

enum ViewStatus { loading, success, error }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repository = ItemRepository();
  final _searchController = TextEditingController();
  final CartProvider _cart = CartProvider.instance;
  ViewStatus _status = ViewStatus.loading;
  List<Item> _items = [];
  String _errorMessage = '';
  Set<String> _selectedCategories = {};
  int _selectedBottomNav = 0;

  List<Item> get _filteredItems {
    final query = _searchController.text.trim().toLowerCase();
    return _items.where((item) {
      final matchesQuery = query.isEmpty ||
          '${item.title} ${item.merchantName} ${item.category} ${item.subtitle}'
              .toLowerCase()
              .contains(query);
      final matchesCategory = _selectedCategories.isEmpty ||
          _selectedCategories.any(
            (cat) => cat.toLowerCase() == item.category.toLowerCase(),
          );
      return matchesQuery && matchesCategory;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _cart.addListener(_onCartChanged);
    _loadItems();
  }

  void _onCartChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadItems() async {
    if (_status != ViewStatus.loading) {
      setState(() => _status = ViewStatus.loading);
    }
    try {
      final items = await _repository.fetchItems();
      if (!mounted) return;
      setState(() {
        _items = items;
        _status = ViewStatus.success;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _status = ViewStatus.error;
      });
    }
  }

  Future<void> _showCategoryFilter() async {
    FocusManager.instance.primaryFocus?.unfocus();
    var draftSelection = Set<String>.of(_selectedCategories);
    final selection = await showModalBottomSheet<Set<String>>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Filter kategori',
                        style: TextStyle(
                          color: AppColors.ink,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => setSheetState(() => draftSelection = {}),
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    'Paket Masak',
                    'Segar',
                    'Lauk Instan',
                    'Hemat Kos',
                  ]
                      .map(
                        (cat) => FilterChip(
                          label: Text(cat),
                          selected: draftSelection.contains(cat),
                          onSelected: (selected) {
                            setSheetState(() {
                              if (selected) {
                                draftSelection.add(cat);
                              } else {
                                draftSelection.remove(cat);
                              }
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(sheetContext, draftSelection),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text('Terapkan'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (selection != null && mounted) {
      setState(() => _selectedCategories = selection);
    }
  }

  @override
  void dispose() {
    _cart.removeListener(_onCartChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _openItem(Item item) {
    Navigator.pushNamed(context, AppRoutes.detailMenu, arguments: item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: _loadItems,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 140),
                children: [
                  // 1. TOP HEADER WITH LOCATION, BADGES, AND AVATAR
                  const _HeaderSection(),
                  const SizedBox(height: 14),

                  // 2. SEARCH BAR & FILTER
                  _SearchBarSection(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    onFilter: _showCategoryFilter,
                    selectedCount: _selectedCategories.length,
                    onClear: () {
                      _searchController.clear();
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 14),

                  // 3. VIBRANT HERO PROMO BANNER
                  const _PromoBannerCard(),
                  const SizedBox(height: 16),

                  // 4. 4 QUICK ACTION CATEGORIES
                  _CategoryQuickActions(
                    onSelectCategory: (category) {
                      setState(() {
                        _selectedCategories = {category};
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // 5. SECTION 1: PAKET BAHAN TERLARIS
                  _SectionHeading(
                    title: 'Paket Bahan Terlaris',
                    subtitle: 'Takaran pas untuk 1–2 orang, anti mubazir',
                    indicatorColor: AppColors.primary,
                    actionText: 'Lihat Semua',
                    onAction: () => Navigator.pushNamed(context, AppRoutes.umkmList),
                  ),
                  const SizedBox(height: 12),
                  _buildContent(),
                  const SizedBox(height: 22),

                  // 6. SECTION 2: MENU POPULER MAHASISWA
                  if (_searchController.text.trim().isEmpty &&
                      _selectedCategories.isEmpty) ...[
                    _SectionHeading(
                      title: 'Menu Populer Mahasiswa',
                      subtitle: 'Porsi pas kenyang, hemat anggaran bulanan',
                      indicatorColor: const Color(0xFF00B060),
                      badgeText: 'Lagi Tren',
                      onAction: () {},
                    ),
                    const SizedBox(height: 12),
                    _buildPopularGrid(),
                  ],
                ],
              ),
            ),

            // 7. FLOATING CART PILL BAR AT BOTTOM (Dinamis dari CartProvider)
            Positioned(
              left: 16,
              right: 16,
              bottom: 12,
              child: _FloatingCartBar(
                itemCount: _cart.totalItemCount,
                totalAmount: _cart.grandTotal,
                onTapCart: () => Navigator.pushNamed(context, AppRoutes.cart),
                onCheckout: () {
                  final defaultItem = _cart.isNotEmpty
                      ? _cart.items.first.item
                      : ItemRepository.findById('1');
                  if (defaultItem != null) {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.checkout,
                      arguments: defaultItem,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNavBar(
        currentIndex: _selectedBottomNav,
        onTap: (index) {
          setState(() => _selectedBottomNav = index);
          if (index == 2) {
            Navigator.pushNamed(context, AppRoutes.orderStatus);
          } else if (index == 3) {
            Navigator.pushNamed(context, AppRoutes.umkmList);
          } else if (index == 4) {
            Navigator.pushNamed(context, AppRoutes.support);
          }
        },
      ),
    );
  }

  // Content for Section 1 (Paket Bahan Terlaris / Search results)
  Widget _buildContent() {
    if (_status == ViewStatus.loading) {
      return const SizedBox(height: 120, child: LoadingView());
    }
    if (_status == ViewStatus.error) {
      return ErrorView(
        message: _errorMessage,
        onRetry: _loadItems,
      );
    }
    final items = _filteredItems;
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: EmptyView(
          message: 'Menu tidak ditemukan',
          icon: Icons.search_off_rounded,
        ),
      );
    }

    // Normal view: Horizontal scrollable best seller cards
    if (_searchController.text.trim().isEmpty && _selectedCategories.isEmpty) {
      return SizedBox(
        height: 255,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final item = items[index];
            return _BestSellerCard(
              item: item,
              discountTag: index == 0 ? 'DISKON 20%' : null,
              timeTag: index == 0 ? '15 Mnt' : null,
              freshTag: index == 1 ? 'Segar 100%' : null,
              strikePrice: index == 0 ? 'Rp 22.500' : null,
              salePrice: index == 0 ? 'Rp 18.000' : item.priceLabel,
              pricePrefix: index == 1 ? 'Harga Kit' : null,
              soldCount: index == 0 ? 'Terjual 340+' : 'Terjual 520+',
              onTap: () => _openItem(item),
            );
          },
        ),
      );
    }

    // Filter/Search active: Grid view of matching items
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return _BestSellerCard(
          item: item,
          salePrice: item.priceLabel,
          soldCount: 'Terjual ${item.reviewCount ?? 100}+',
          onTap: () => _openItem(item),
        );
      },
    );
  }

  // Section 2: Popular Menu 2x2 Grid
  Widget _buildPopularGrid() {
    if (_items.isEmpty) {
      return const SizedBox(height: 120, child: LoadingView());
    }

    final popularList = [
      _PopularMenuItemData(
        title: 'Tumis Tempe Orek ...',
        merchantSubtitle: 'Dapur Bu Dewi • Tempe + Bu...',
        priceLabel: 'Rp 9.500',
        badgeLabel: 'Hemat Banget',
        badgeColor: const Color(0xFFE53935),
        timeLabel: '10 Mnt',
        imageUrl:
            'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=600&q=80',
        item: _items.length > 3 ? _items[3] : _items.first,
      ),
      _PopularMenuItemData(
        title: 'Sup Telur Bakso Gurih',
        merchantSubtitle: 'Kantin Mbok Sri • Segar & Ha...',
        priceLabel: 'Rp 12.000',
        badgeLabel: 'Tinggi Protein',
        badgeColor: const Color(0xFF00A86B),
        timeLabel: '12 Mnt',
        imageUrl:
            'https://images.unsplash.com/photo-1547592166-23ac45744acd?auto=format&fit=crop&w=600&q=80',
        item: _items.length > 2 ? _items[2] : _items.first,
      ),
      _PopularMenuItemData(
        title: 'Beef Enoki Teriyaki',
        merchantSubtitle: 'Bento Kosan • Daging Slice',
        priceLabel: 'Rp 23.500',
        badgeLabel: 'Spesial Nikmat',
        badgeColor: const Color(0xFFF59E0B),
        timeLabel: '15 Mnt',
        imageUrl:
            'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=600&q=80',
        item: _items.first,
      ),
      _PopularMenuItemData(
        title: 'Cah Kangkung Terasi',
        merchantSubtitle: 'Sayur Segar Bu Joko • Bumb...',
        priceLabel: 'Rp 8.000',
        badgeLabel: 'Sayur Segar',
        badgeColor: const Color(0xFF059669),
        timeLabel: '8 Mnt',
        imageUrl:
            'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80',
        item: _items.length > 1 ? _items[1] : _items.first,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: popularList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 14,
        childAspectRatio: 0.74,
      ),
      itemBuilder: (context, index) {
        final data = popularList[index];
        return _PopularGridCard(
          data: data,
          onTap: () => _openItem(data.item),
        );
      },
    );
  }
}

// ============================================================================
// TOP HEADER SECTION (CookBox HEMAT, Location, Icons & Avatar)
// ============================================================================
class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // CookBox logo container
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Icon(Icons.lunch_dining_rounded, color: Colors.white, size: 22),
          ),
        ),
        const SizedBox(width: 8),

        // Brand & Location Dropdown
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text(
                    'CookBox',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F8F0),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      'HEMAT',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF008955),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: const [
                  Icon(Icons.location_on_outlined, size: 12, color: AppColors.primary),
                  SizedBox(width: 2),
                  Flexible(
                    child: Text(
                      'Kost Sakura, Kampus ...',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, size: 14, color: AppColors.muted),
                ],
              ),
            ],
          ),
        ),

        // Heart favorite button
        _HeaderCircleButton(
          icon: Icons.favorite_border_rounded,
          onTap: () {},
        ),
        const SizedBox(width: 8),

        // Bell notification button with red dot badge
        Stack(
          children: [
            _HeaderCircleButton(
              icon: Icons.notifications_none_rounded,
              onTap: () {},
            ),
            Positioned(
              top: 5,
              right: 6,
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFFE53935),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),

        // User Avatar Photo
        ClipOval(
          child: Image.network(
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
            width: 34,
            height: 34,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 34,
              height: 34,
              color: const Color(0xFFFFD84D),
              child: const Icon(Icons.person, color: AppColors.ink, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderCircleButton extends StatelessWidget {
  const _HeaderCircleButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Icon(icon, size: 18, color: AppColors.ink),
      ),
    );
  }
}

// ============================================================================
// SEARCH BAR & FILTER
// ============================================================================
class _SearchBarSection extends StatelessWidget {
  const _SearchBarSection({
    required this.controller,
    required this.onChanged,
    required this.onFilter,
    required this.selectedCount,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilter;
  final int selectedCount;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEFEFEF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(fontSize: 12, color: AppColors.ink),
              decoration: const InputDecoration(
                hintText: 'Cari paket bahan, bumbu iris, resep..',
                hintStyle: TextStyle(color: Color(0xFF9E9E9E), fontSize: 11),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            IconButton(
              tooltip: 'Hapus pencarian',
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.muted),
              onPressed: onClear,
            ),
          InkWell(
            key: const ValueKey('category-filter'),
            onTap: onFilter,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF2E8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.tune_rounded, size: 16, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// HERO PROMO BANNER (Spesial Kos • Menu Baru)
// ============================================================================
class _PromoBannerCard extends StatelessWidget {
  const _PromoBannerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF15A00), Color(0xFFFF7A28)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x30F15A00),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD54F),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.bolt, size: 11, color: Colors.black87),
                          SizedBox(width: 2),
                          Text(
                            'SPESIAL KOS',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      '• Menu Baru',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Masak Lezat, Hemat s/d\n40%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Paket bahan bersih & bumbu pas untu...',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Klaim Voucher',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(width: 3),
                          Icon(Icons.arrow_forward_rounded, size: 11, color: AppColors.primary),
                        ],
                      ),
                    ),
                    const Text(
                      'Sisa 8 Kupon',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Food Image with 22rb tag
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=400&q=80',
                  width: 88,
                  height: 88,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 88,
                    height: 88,
                    color: const Color(0xFFFFECE5),
                    child: const Center(
                      child: Icon(Icons.fastfood, color: AppColors.primary),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '22rb',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
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

// ============================================================================
// 4 CATEGORY QUICK ACTIONS
// ============================================================================
class _CategoryQuickActions extends StatelessWidget {
  const _CategoryQuickActions({required this.onSelectCategory});
  final ValueChanged<String> onSelectCategory;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _QuickActionTile(
          icon: Icons.ramen_dining_outlined,
          iconColor: const Color(0xFFF16A00),
          bgColor: const Color(0xFFFFF2E8),
          title: 'Paket Masak',
          subtitle: 'Siap Tumis',
          subColor: const Color(0xFFF16A00),
          onTap: () => onSelectCategory('Paket Masak'),
        ),
        _QuickActionTile(
          icon: Icons.eco_outlined,
          iconColor: const Color(0xFF008955),
          bgColor: const Color(0xFFE8F8F2),
          title: 'Sayur Segar',
          subtitle: 'Dari Pasar',
          subColor: const Color(0xFF008955),
          onTap: () => onSelectCategory('Segar'),
        ),
        _QuickActionTile(
          icon: Icons.soup_kitchen_outlined,
          iconColor: const Color(0xFFD48806),
          bgColor: const Color(0xFFFFF8E5),
          title: 'Lauk Instan',
          subtitle: 'Tinggal Goreng',
          subColor: const Color(0xFFB36B00),
          onTap: () => onSelectCategory('Lauk Instan'),
        ),
        _QuickActionTile(
          icon: Icons.savings_outlined,
          iconColor: const Color(0xFFD4380D),
          bgColor: const Color(0xFFFFEBF0),
          title: 'Hemat Kos',
          subtitle: '< Rp15 Ribu',
          subColor: const Color(0xFFC41D7F),
          onTap: () => onSelectCategory('Hemat Kos'),
        ),
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.subColor,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String subtitle;
  final Color subColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              text: title,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: subColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SECTION HEADING
// ============================================================================
class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.title,
    this.subtitle,
    required this.indicatorColor,
    this.actionText,
    this.badgeText,
    this.onAction,
  });

  final String title;
  final String? subtitle;
  final Color indicatorColor;
  final String? actionText;
  final String? badgeText;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: indicatorColor,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: AppColors.ink,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: const TextStyle(fontSize: 10, color: AppColors.muted),
                ),
              ],
            ],
          ),
        ),
        if (actionText != null)
          GestureDetector(
            onTap: onAction,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  actionText!,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Icon(Icons.chevron_right, size: 14, color: AppColors.primary),
              ],
            ),
          ),
        if (badgeText != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF2E8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.trending_up_rounded, size: 12, color: AppColors.primary),
                const SizedBox(width: 3),
                Text(
                  badgeText!,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 9,
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

// ============================================================================
// SECTION 1: PAKET BAHAN TERLARIS CARD
// ============================================================================
class _BestSellerCard extends StatelessWidget {
  const _BestSellerCard({
    required this.item,
    this.discountTag,
    this.timeTag,
    this.freshTag,
    this.strikePrice,
    required this.salePrice,
    this.pricePrefix,
    required this.soldCount,
    required this.onTap,
  });

  final Item item;
  final String? discountTag;
  final String? timeTag;
  final String? freshTag;
  final String? strikePrice;
  final String salePrice;
  final String? pricePrefix;
  final String soldCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEFEFEF)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  Image.network(
                    item.imageUrl ??
                        'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=600&q=80',
                    height: 108,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 108,
                      color: const Color(0xFFFFECE5),
                      child: const Center(
                        child: Icon(Icons.fastfood, color: AppColors.primary),
                      ),
                    ),
                  ),

                  // Tag top-left
                  if (timeTag != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF008955),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.access_time_rounded, size: 11, color: Colors.white),
                            const SizedBox(width: 3),
                            Text(
                              timeTag!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  if (freshTag != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF008955),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.shield_outlined, size: 11, color: Colors.white),
                            const SizedBox(width: 3),
                            Text(
                              freshTag!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Heart button top right
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        size: 15,
                        color: AppColors.accent,
                      ),
                    ),
                  ),

                  // Discount tag bottom left
                  if (discountTag != null)
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE53935),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          discountTag!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Card Body
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.storefront_outlined, size: 12, color: AppColors.primary),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          item.merchantName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 9, color: AppColors.muted),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 13, color: Color(0xFFF2A900)),
                      const SizedBox(width: 2),
                      const Text(
                        '4.8',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700),
                      ),
                      Flexible(
                        child: Text(
                          ' • $soldCount',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 9, color: AppColors.muted),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (strikePrice != null)
                              Text(
                                strikePrice!,
                                style: const TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 9,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              )
                            else if (pricePrefix != null)
                              Text(
                                pricePrefix!,
                                style: const TextStyle(color: AppColors.muted, fontSize: 9),
                              ),
                            Text(
                              salePrice,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          CartProvider.instance.addItem(item, quantity: 1);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${item.title} ditambahkan ke keranjang!'),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              action: SnackBarAction(
                                label: 'Keranjang',
                                textColor: const Color(0xFFFFD84D),
                                onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, size: 12, color: Colors.white),
                              SizedBox(width: 2),
                              Text(
                                'Tambah',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// SECTION 2: POPULAR MENU GRID CARD
// ============================================================================
class _PopularMenuItemData {
  const _PopularMenuItemData({
    required this.title,
    required this.merchantSubtitle,
    required this.priceLabel,
    required this.badgeLabel,
    required this.badgeColor,
    required this.timeLabel,
    required this.imageUrl,
    required this.item,
  });

  final String title;
  final String merchantSubtitle;
  final String priceLabel;
  final String badgeLabel;
  final Color badgeColor;
  final String timeLabel;
  final String imageUrl;
  final Item item;
}

class _PopularGridCard extends StatelessWidget {
  const _PopularGridCard({required this.data, required this.onTap});
  final _PopularMenuItemData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEFEFEF)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  Image.network(
                    data.imageUrl,
                    height: 110,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 110,
                      color: const Color(0xFFFFECE5),
                      child: const Center(
                        child: Icon(Icons.fastfood, color: AppColors.primary),
                      ),
                    ),
                  ),

                  // Badge top left
                  Positioned(
                    top: 7,
                    left: 7,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: data.badgeColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        data.badgeLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),

                  // Time tag bottom left
                  Positioned(
                    bottom: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.access_time_rounded, size: 10, color: Colors.white),
                          const SizedBox(width: 3),
                          Text(
                            data.timeLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Card Body
            Padding(
              padding: const EdgeInsets.all(9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    data.merchantSubtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 8, color: AppColors.muted),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data.priceLabel,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, size: 15, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// FLOATING CART PILL BAR
// ============================================================================
class _FloatingCartBar extends StatelessWidget {
  const _FloatingCartBar({
    required this.itemCount,
    required this.totalAmount,
    required this.onTapCart,
    required this.onCheckout,
  });

  final int itemCount;
  final int totalAmount;
  final VoidCallback onTapCart;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF141E28),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x35000000),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Orange bag icon with badge
          GestureDetector(
            onTap: onTapCart,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                Positioned(
                  top: -3,
                  right: -3,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFD54F),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$itemCount',
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Total & Item Summary (Tappable to open Cart)
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTapCart,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$itemCount Paket Bahan Dipilih',
                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                  Text(
                    'Rp ${totalAmount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Button Bayar ->
          FilledButton(
            onPressed: onCheckout,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Bayar',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_rounded, size: 14, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// BOTTOM NAVIGATION BAR
// ============================================================================
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.currentIndex, required this.onTap});
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavButton(
              icon: Icons.home_filled,
              label: 'Beranda',
              selected: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            _NavButton(
              icon: Icons.restaurant_menu_rounded,
              label: 'Menu',
              selected: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            _NavButton(
              icon: Icons.receipt_long_outlined,
              label: 'Pesanan',
              selected: currentIndex == 2,
              onTap: () => onTap(2),
            ),
            _NavButton(
              icon: Icons.storefront_outlined,
              label: 'UMKM',
              selected: currentIndex == 3,
              onTap: () => onTap(3),
            ),
            _NavButton(
              icon: Icons.headset_mic_outlined,
              label: 'Bantuan',
              selected: currentIndex == 4,
              onTap: () => onTap(4),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : const Color(0xFF9E9E9E);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
