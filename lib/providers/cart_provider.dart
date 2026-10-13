import 'package:flutter/foundation.dart';

import '../data/item_repository.dart';
import '../models/cart_item.dart';
import '../models/item.dart';

/// Provider pengelola state dan logika bisnis keranjang belanja serta checkout CookBox.
class CartProvider extends ChangeNotifier {
  static final CartProvider _instance = CartProvider._internal();
  factory CartProvider() => _instance;
  static CartProvider get instance => _instance;

  CartProvider._internal() {
    _seedInitialItems();
  }

  final List<CartItem> _items = [];

  String _deliveryMode = 'Diantar ke Alamat';
  String _paymentMethod = 'qris';
  String? _appliedVoucher = 'HEMATKOS';
  int _voucherDiscount = 5000;

  /// Daftar item di dalam keranjang (unmodifiable view)
  List<CartItem> get items => List.unmodifiable(_items);

  /// Mode pengantaran: 'Diantar ke Alamat' atau 'Ambil ke UMKM'
  String get deliveryMode => _deliveryMode;

  /// Metode pembayaran: 'qris', 'cash', 'gopay', 'transfer'
  String get paymentMethod => _paymentMethod;

  /// Kode voucher yang aktif
  String? get appliedVoucher => _appliedVoucher;

  /// Apakah keranjang kosong
  bool get isEmpty => _items.isEmpty;

  /// Apakah keranjang memiliki item
  bool get isNotEmpty => _items.isNotEmpty;

  /// Total kuantitas seluruh porsi item di keranjang
  int get totalItemCount => _items.fold(0, (sum, i) => sum + i.quantity);

  /// Subtotal harga makanan
  int get subtotal => _items.fold(0, (sum, i) => sum + i.totalPrice);

  /// Ongkos kirim: gratis jika ambil di UMKM atau keranjang kosong
  int get shippingFee {
    if (_items.isEmpty) return 0;
    if (_deliveryMode == 'Ambil ke UMKM') return 0;
    return 6000;
  }

  /// Biaya kemasan higienis
  int get packagingFee => _items.isEmpty ? 0 : 2000;

  /// Potongan voucher promo
  int get discount {
    if (_items.isEmpty || _appliedVoucher == null) return 0;
    return _voucherDiscount > subtotal ? subtotal : _voucherDiscount;
  }

  /// Total akhir yang harus dibayar
  int get grandTotal {
    if (_items.isEmpty) return 0;
    final total = subtotal + shippingFee + packagingFee - discount;
    return total > 0 ? total : 0;
  }

  /// Helper format mata uang Rupiah dengan pemisah ribuan
  static String formatRupiah(int amount) {
    final digits = amount.toString();
    final grouped = digits.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
    return 'Rp $grouped';
  }

  /// Inisialisasi awal dengan item dummy default agar data langsung siap
  void _seedInitialItems() {
    final item1 = ItemRepository.findById('1');
    final item2 = ItemRepository.findById('2');
    if (item1 != null) {
      _items.add(CartItem(item: item1, quantity: 1));
    }
    if (item2 != null) {
      _items.add(CartItem(item: item2, quantity: 1));
    }
  }

  /// Algoritma Tambah Menu ke Keranjang
  /// Jika item sudah ada, kuantitas akan diakumulasikan.
  /// Jika belum ada, item baru akan ditambahkan.
  void addItem(
    Item item, {
    int quantity = 1,
    String note = '',
    List<String> addons = const [],
  }) {
    if (quantity <= 0) return;

    final existingIndex = _items.indexWhere((ci) => ci.item.id == item.id);
    if (existingIndex >= 0) {
      final existing = _items[existingIndex];
      _items[existingIndex] = existing.copyWith(
        quantity: existing.quantity + quantity,
        note: note.isNotEmpty ? note : existing.note,
        selectedAddons: addons.isNotEmpty ? addons : existing.selectedAddons,
      );
    } else {
      _items.add(
        CartItem(
          item: item,
          quantity: quantity,
          note: note,
          selectedAddons: addons,
        ),
      );
    }
    notifyListeners();
  }

  /// Tambah 1 kuantitas porsi
  void incrementQuantity(String itemId) {
    final index = _items.indexWhere((ci) => ci.item.id == itemId);
    if (index >= 0) {
      _items[index].quantity += 1;
      notifyListeners();
    }
  }

  /// Kurangi 1 kuantitas porsi (hapus jika mencapai 0)
  void decrementQuantity(String itemId) {
    final index = _items.indexWhere((ci) => ci.item.id == itemId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity -= 1;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  /// Update kuantitas item secara langsung
  void updateQuantity(String itemId, int newQuantity) {
    final index = _items.indexWhere((ci) => ci.item.id == itemId);
    if (index >= 0) {
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  /// Hapus item tertentu dari keranjang
  void removeItem(String itemId) {
    _items.removeWhere((ci) => ci.item.id == itemId);
    notifyListeners();
  }

  /// Bersihkan seluruh isi keranjang
  void clear() {
    _items.clear();
    notifyListeners();
  }

  /// Ubah mode pengantaran
  void setDeliveryMode(String mode) {
    if (_deliveryMode != mode) {
      _deliveryMode = mode;
      notifyListeners();
    }
  }

  /// Ubah metode pembayaran
  void setPaymentMethod(String method) {
    if (_paymentMethod != method) {
      _paymentMethod = method;
      notifyListeners();
    }
  }

  /// Terapkan kode promo
  bool applyVoucher(String code) {
    final clean = code.trim().toUpperCase();
    if (clean == 'HEMATKOS' || clean == 'COOKBOX5K') {
      _appliedVoucher = clean;
      _voucherDiscount = 5000;
      notifyListeners();
      return true;
    } else if (clean == 'DISKON10') {
      _appliedVoucher = clean;
      _voucherDiscount = 10000;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Hapus voucher
  void removeVoucher() {
    _appliedVoucher = null;
    _voucherDiscount = 0;
    notifyListeners();
  }
}
