import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';

/// Layar Keranjang Belanja CookBox (M2) dengan algoritma pengelolaan item,
/// manipulasi kuantitas porsi, kode promo, dan kalkulasi subtotal.
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _voucherController = TextEditingController();
  final CartProvider _cart = CartProvider.instance;

  @override
  void initState() {
    super.initState();
    _voucherController.text = _cart.appliedVoucher ?? 'HEMATKOS';
    _cart.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    _cart.removeListener(_onCartChanged);
    _voucherController.dispose();
    super.dispose();
  }

  void _onCartChanged() {
    if (mounted) setState(() {});
  }

  void _applyVoucher() {
    final code = _voucherController.text.trim();
    if (code.isEmpty) return;

    final success = _cart.applyVoucher(code);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Voucher $code berhasil diterapkan! Diskon terpasang.'
              : 'Kode voucher tidak valid. Coba "HEMATKOS" atau "DISKON10"',
        ),
        backgroundColor: success ? const Color(0xFF008955) : Colors.redAccent,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showClearConfirmDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kosongkan Keranjang?'),
        content: const Text('Semua menu masakan yang telah kamu pilih akan dihapus dari keranjang.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(ctx);
              _cart.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Keranjang belanja berhasil dikosongkan'),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Kosongkan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _cart.items;
    final isEmpty = items.isEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.ink),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            const Text(
              'Keranjang Belanja',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 6),
            if (!isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFECE5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${_cart.totalItemCount}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
          ],
        ),
        actions: [
          if (!isEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent),
              tooltip: 'Kosongkan Keranjang',
              onPressed: _showClearConfirmDialog,
            ),
        ],
      ),
      body: isEmpty ? _buildEmptyView() : _buildCartContent(items),
      bottomNavigationBar: isEmpty ? null : _buildBottomBar(),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF0E8),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.remove_shopping_cart_rounded,
                size: 44,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Keranjang Belanja Kosong',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Kamu belum menambahkan menu masakan siap masak. Yuk pilih paket bahan dari UMKM lokal pilihan!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.muted, height: 1.4),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.restaurant_menu_rounded, size: 16),
              label: const Text('Mulai Pilih Menu'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartContent(List<CartItem> items) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
      children: [
        // 1. INFO HEADER
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F6F0),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFD0EEDF)),
          ),
          child: const Row(
            children: [
              Icon(Icons.storefront_rounded, color: Color(0xFF008955), size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Bahan siap olah langsung dikemas dari UMKM mitra terdekat.',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF07653F)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // 2. DAFTAR ITEM KERANJANG
        ...items.map((cartItem) => _buildCartItemCard(cartItem)),

        const SizedBox(height: 16),

        // 3. KODE VOUCHER / PROMO
        _buildVoucherCard(),

        const SizedBox(height: 16),

        // 4. RINGKASAN HARGA
        _buildPriceSummaryCard(),
      ],
    );
  }

  Widget _buildCartItemCard(CartItem cartItem) {
    final item = cartItem.item;
    final itemPrice = cartItem.unitPrice;
    final itemTotal = cartItem.totalPrice;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar menu
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.imageUrl ??
                  'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=400&q=80',
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 70,
                height: 70,
                color: const Color(0xFFFFECE5),
                child: const Icon(Icons.lunch_dining_rounded, color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Detail nama & harga
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: AppColors.ink,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.muted),
                      tooltip: 'Hapus Item',
                      onPressed: () {
                        _cart.removeItem(item.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${item.title} dihapus dari keranjang'),
                            duration: const Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.merchantName} • ${item.category}',
                  style: const TextStyle(fontSize: 10, color: AppColors.muted),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      cartItem.formattedUnitPrice,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text('•', style: TextStyle(color: AppColors.muted, fontSize: 10)),
                    const SizedBox(width: 4),
                    Text(
                      'Total: ${cartItem.formattedPrice}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Algoritma Counter Kuantitas: [-] [qty] [+]
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE5E5E7)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () => _cart.decrementQuantity(item.id),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: 26,
                              height: 26,
                              alignment: Alignment.center,
                              child: Icon(
                                cartItem.quantity == 1 ? Icons.delete_outline_rounded : Icons.remove,
                                size: 15,
                                color: cartItem.quantity == 1 ? Colors.redAccent : AppColors.ink,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '${cartItem.quantity}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: AppColors.ink,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => _cart.incrementQuantity(item.id),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: const Icon(Icons.add, size: 15, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherCard() {
    final hasVoucher = _cart.appliedVoucher != null;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.confirmation_number_outlined, size: 16, color: AppColors.primary),
              SizedBox(width: 6),
              Text(
                'Voucher Promo CookBox',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.ink),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9FA),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E2E6)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    controller: _voucherController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      hintText: 'Masukkan kode promo (mis. HEMATKOS)',
                      hintStyle: TextStyle(fontSize: 11, color: AppColors.muted),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (hasVoucher)
                TextButton(
                  onPressed: () {
                    _cart.removeVoucher();
                    _voucherController.clear();
                  },
                  child: const Text('Hapus', style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                )
              else
                FilledButton(
                  onPressed: _applyVoucher,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Terapkan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummaryCard() {
    final subtotal = _cart.subtotal;
    final packaging = _cart.packagingFee;
    final discount = _cart.discount;
    final grandTotal = _cart.grandTotal;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Belanja',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.ink),
          ),
          const SizedBox(height: 12),
          _summaryRow('Subtotal (${_cart.totalItemCount} porsi)', 'Rp ${subtotal.toStringAsFixed(0)}'),
          const SizedBox(height: 8),
          _summaryRow('Biaya Kemasan Higienis', 'Rp ${packaging.toStringAsFixed(0)}'),
          if (discount > 0) ...[
            const SizedBox(height: 8),
            _summaryRow(
              'Diskon Promo (${_cart.appliedVoucher})',
              '-Rp ${discount.toStringAsFixed(0)}',
              isGreen: true,
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFEEEEEE)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Estimasi Total',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.ink),
              ),
              Text(
                'Rp ${grandTotal.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: isGreen ? const Color(0xFF008955) : AppColors.ink,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    final grandTotal = _cart.grandTotal;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
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
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TOTAL BELANJA',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    'Rp ${grandTotal.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: () {
                final firstItem = _cart.items.first.item;
                Navigator.pushNamed(
                  context,
                  AppRoutes.checkout,
                  arguments: firstItem,
                );
              },
              icon: const Icon(Icons.arrow_forward_rounded, size: 16),
              label: const Text(
                'Lanjut ke Checkout',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
