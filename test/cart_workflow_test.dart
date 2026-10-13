import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nama_project/data/item_repository.dart';
import 'package:nama_project/models/item.dart';
import 'package:nama_project/providers/cart_provider.dart';
import 'package:nama_project/routes/app_routes.dart';
import 'package:nama_project/screens/cart_checkout_screen.dart';
import 'package:nama_project/screens/cart_screen.dart';
import 'package:nama_project/screens/detail_menu_screen.dart';

void main() {
  final testItem = const Item(
    id: 'test_item',
    title: 'Ayam Woku Manado',
    subtitle: 'Bahan segar rica pedas',
    description: 'Paket siap masak ayam woku dengan rempah khas.',
    merchantName: 'Dapur Nusantara',
    category: 'Paket Masak',
    price: 30000,
  );

  group('CartProvider Algorithm Unit Tests', () {
    late CartProvider cart;

    setUp(() {
      cart = CartProvider.instance;
      cart.clear();
    });

    test('addItem menambahkan item baru atau mengakumulasi kuantitas', () {
      expect(cart.isEmpty, isTrue);

      cart.addItem(testItem, quantity: 2);
      expect(cart.items.length, 1);
      expect(cart.totalItemCount, 2);
      expect(cart.subtotal, 60000);

      // Tambah item yang sama lagi
      cart.addItem(testItem, quantity: 1);
      expect(cart.items.length, 1);
      expect(cart.totalItemCount, 3);
      expect(cart.subtotal, 90000);
    });

    test('incrementQuantity dan decrementQuantity mengubah kuantitas dan total', () {
      cart.addItem(testItem, quantity: 2);

      cart.incrementQuantity(testItem.id);
      expect(cart.totalItemCount, 3);
      expect(cart.subtotal, 90000);

      cart.decrementQuantity(testItem.id);
      expect(cart.totalItemCount, 2);
      expect(cart.subtotal, 60000);

      // Kurang sampai 0 menghapus item
      cart.decrementQuantity(testItem.id);
      cart.decrementQuantity(testItem.id);
      expect(cart.isEmpty, isTrue);
    });

    test('mode pengantaran mempengaruhi ongkos kirim secara dinamis', () {
      cart.addItem(testItem, quantity: 1); // 30.000

      cart.setDeliveryMode('Diantar ke Alamat');
      expect(cart.shippingFee, 6000);

      cart.setDeliveryMode('Ambil ke UMKM');
      expect(cart.shippingFee, 0);
    });

    test('voucher promo HEMATKOS memotong total belanja', () {
      cart.addItem(testItem, quantity: 1);
      cart.setDeliveryMode('Diantar ke Alamat');

      final applied = cart.applyVoucher('HEMATKOS');
      expect(applied, isTrue);
      expect(cart.discount, 5000);
      // Subtotal (30.000) + Ongkir (6.000) + Packing (2.000) - Diskon (5.000) = 33.000
      expect(cart.grandTotal, 33000);
    });
  });

  group('Cart & Checkout Screen Workflow Tests', () {
    setUp(() {
      CartProvider.instance.clear();
      CartProvider.instance.addItem(testItem, quantity: 1);
    });

    testWidgets('CartScreen menampilkan daftar item dan merespons counter', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CartScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Keranjang Belanja'), findsOneWidget);
      expect(find.text('Ayam Woku Manado'), findsOneWidget);
      expect(find.text('Total: Rp 30.000'), findsOneWidget);

      // Tap tombol tambah (+) di keranjang
      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pumpAndSettle();

      expect(CartProvider.instance.totalItemCount, 2);
      expect(find.text('Total: Rp 60.000'), findsOneWidget);
    });

    testWidgets('Detail Menu menambah item ke CartProvider dan navigasi ke checkout', (
      tester,
    ) async {
      CartProvider.instance.clear();

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: DetailMenuScreen(item: testItem),
        ),
      );
      await tester.pumpAndSettle();

      // Tap tambah
      await tester.tap(find.widgetWithText(FilledButton, 'Tambah'));
      await tester.pumpAndSettle();

      // Memastikan item masuk ke keranjang
      expect(CartProvider.instance.items.any((ci) => ci.item.id == testItem.id), isTrue);

      // Memastikan berpindah ke Checkout
      expect(find.text('Checkout'), findsOneWidget);
      expect(find.text('Ayam Woku Manado'), findsOneWidget);
    });

    testWidgets('Checkout Konfirmasi & Bayar mengosongkan keranjang dan navigasi ke order status', (
      tester,
    ) async {
      CartProvider.instance.clear();
      CartProvider.instance.addItem(testItem, quantity: 1);

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: CartCheckoutScreen(item: testItem),
        ),
      );
      await tester.pumpAndSettle();

      expect(CartProvider.instance.isNotEmpty, isTrue);

      await tester.tap(find.text('Konfirmasi & Bayar'));
      await tester.pumpAndSettle();

      // Keranjang otomatis kosong setelah pembayaran
      expect(CartProvider.instance.isEmpty, isTrue);
      expect(find.text('Status Pesanan'), findsOneWidget);
    });
  });
}
