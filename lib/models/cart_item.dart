import 'item.dart';

/// Model untuk item di dalam keranjang belanja.
class CartItem {
  final Item item;
  int quantity;
  final String note;
  final List<String> selectedAddons;

  CartItem({
    required this.item,
    this.quantity = 1,
    this.note = '',
    this.selectedAddons = const [],
  });

  /// Harga satuan (mengambil dari item.price atau default 20.000)
  int get unitPrice => item.price ?? 20000;

  /// Total harga untuk item ini (unitPrice * kuantitas)
  int get totalPrice => unitPrice * quantity;

  String get formattedUnitPrice {
    final digits = unitPrice.toString();
    final grouped = digits.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
    return 'Rp $grouped';
  }

  String get formattedPrice {
    final digits = totalPrice.toString();
    final grouped = digits.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
    return 'Rp $grouped';
  }

  CartItem copyWith({
    int? quantity,
    String? note,
    List<String>? selectedAddons,
  }) {
    return CartItem(
      item: item,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
      selectedAddons: selectedAddons ?? this.selectedAddons,
    );
  }
}
