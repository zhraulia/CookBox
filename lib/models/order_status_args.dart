// [BARU] Model pembungkus data checkout yang dikirim ke OrderStatusScreen.
// Bukan data dummy — diisi dari nilai nyata di CartCheckoutScreen saat checkout.
import 'item.dart';

class OrderStatusArgs {
  final Item item; // item utama yang dipesan
  final int quantity; // total porsi
  final String deliveryMode; // mode pengantaran (dari CartProvider)
  final int totalPrice; // total harga akhir yang dibayar
  final String orderCode; // kode unik pesanan

  const OrderStatusArgs({
    required this.item,
    required this.quantity,
    required this.deliveryMode,
    required this.totalPrice,
    required this.orderCode,
  });
}
