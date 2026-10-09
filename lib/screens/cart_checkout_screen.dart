import 'package:flutter/material.dart';

import '../models/item.dart';
import '../theme/app_colors.dart';

class CartCheckoutScreen extends StatefulWidget {
  const CartCheckoutScreen({super.key, required this.item});
  final Item item;

  @override
  State<CartCheckoutScreen> createState() => _CartCheckoutScreenState();
}

class _CartCheckoutScreenState extends State<CartCheckoutScreen> {
  String _mode = 'Diantar ke Alamat';
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          const _Stepper(),
          const SizedBox(height: 16),
          _SegmentedControl(
            selected: _mode,
            onChanged: (value) => setState(() => _mode = value),
          ),
          const SizedBox(height: 14),
          _mode == 'Diantar ke Alamat'
              ? const _AddressCard()
              : const _PickupCard(),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Item Anda',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 70,
                        height: 70,
                        child: Image.network(
                          item.imageUrl ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const _Fallback(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                          Text(
                            item.merchantName,
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            item.priceLabel,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => setState(
                            () => _quantity = _quantity > 1 ? _quantity - 1 : 1,
                          ),
                          icon: const Icon(Icons.remove_circle_outline),
                          constraints: const BoxConstraints.tightFor(
                            width: 30,
                            height: 30,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        Text(
                          '$_quantity',
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        IconButton(
                          onPressed: () => setState(() => _quantity++),
                          icon: const Icon(Icons.add_circle_outline),
                          constraints: const BoxConstraints.tightFor(
                            width: 30,
                            height: 30,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const _InfoCard(
            icon: Icons.flash_on_rounded,
            title: 'Pengantaran kilat',
            body: 'Paling Cepat • 15–20 menit',
            color: Color(0xFF2E9A66),
          ),
          const SizedBox(height: 16),
          _Summary(price: item.price ?? 0, quantity: _quantity),
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
                    Text(
                      'Total pembayaran',
                      style: TextStyle(color: AppColors.muted, fontSize: 9),
                    ),
                    Text(
                      'Rp ${((item.price ?? 0) * _quantity).toStringAsFixed(0)}',
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
                onPressed: () {},
                icon: const Icon(Icons.payments_rounded),
                label: const Text('Konfirmasi & Bayar'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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

class _Stepper extends StatelessWidget {
  const _Stepper();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _Step(icon: Icons.shopping_bag, label: 'Keranjang', active: true),
        _Line(),
        _Step(icon: Icons.local_shipping, label: 'Pengiriman'),
        _Line(),
        _Step(icon: Icons.payment, label: 'Bayar'),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.icon, required this.label, this.active = false});
  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : const Color(0xFFE9E9EE),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 15,
            color: active ? Colors.white : AppColors.muted,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 8,
            color: active ? AppColors.primary : AppColors.muted,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _Line extends StatelessWidget {
  const _Line();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 1,
        color: const Color(0xFFE9E9EE),
        margin: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }
}

class _SegmentedControl extends StatelessWidget {
  const _SegmentedControl({required this.selected, required this.onChanged});
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final options = ['Diantar ke Alamat', 'Ambil ke UMKM'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE9E9EE),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: options.map((option) {
          return Expanded(
            child: ElevatedButton(
              onPressed: () => onChanged(option),
              style: ElevatedButton.styleFrom(
                backgroundColor: selected == option
                    ? Colors.white
                    : Colors.transparent,
                foregroundColor: selected == option
                    ? AppColors.primary
                    : AppColors.muted,
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: selected == option
                      ? FontWeight.w900
                      : FontWeight.w700,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: AppColors.accent),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alamat pengiriman',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'Jl. Hasanuddin No. 18, Blok C',
                      style: TextStyle(color: AppColors.muted, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7F1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Catatan kurir: satpam kos, akses masuk melalui gerbang barat.',
              style: TextStyle(fontSize: 9, color: Color(0xFF39704E)),
            ),
          ),
        ],
      ),
    );
  }
}

class _PickupCard extends StatelessWidget {
  const _PickupCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.storefront_outlined,
            color: AppColors.accent,
            size: 28,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dapur Barokah Kampus',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                Text(
                  'Jam operasional • 08.00–20.00',
                  style: const TextStyle(color: AppColors.muted, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.color,
  });
  final IconData icon;
  final String title;
  final String body;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7F1),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFDDF2E7)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                Text(
                  body,
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

class _Summary extends StatelessWidget {
  const _Summary({required this.price, required this.quantity});
  final int price;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rincian pembayaran',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          _LineRow('Subtotal', 'Rp ${(price * quantity).toStringAsFixed(0)}'),
          _LineRow('Opsi pengiriman', 'Rp 0'),
          _LineRow('Voucher mahasiswa', '-Rp 5000'),
          const SizedBox(height: 8),
          const Divider(),
          _LineRow(
            'Total',
            'Rp ${((price * quantity) - 5000).toStringAsFixed(0)}',
            emphasized: true,
          ),
        ],
      ),
    );
  }
}

class _LineRow extends StatelessWidget {
  const _LineRow(this.label, this.value, {this.emphasized = false});
  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(
            label,
            style: emphasized
                ? const TextStyle(fontWeight: FontWeight.w900)
                : const TextStyle(fontSize: 10, color: AppColors.muted),
          ),
          const Spacer(),
          Text(
            value,
            style: emphasized
                ? const TextStyle(fontWeight: FontWeight.w900)
                : const TextStyle(fontSize: 10),
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
    return const SizedBox(
      width: 70,
      height: 70,
      child: Center(
        child: Icon(Icons.restaurant_rounded, color: AppColors.accent),
      ),
    );
  }
}
