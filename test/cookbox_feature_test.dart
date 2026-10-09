import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nama_project/models/item.dart';
import 'package:nama_project/screens/cart_checkout_screen.dart';
import 'package:nama_project/screens/detail_menu_screen.dart';
import 'package:nama_project/screens/merchant_directory_screen.dart';
import 'package:nama_project/screens/order_status_screen.dart';
import 'package:nama_project/screens/support_screen.dart';

void main() {
  final item = Item(
    id: '1',
    title: 'Ayam Geprek Sambal Korek',
    subtitle: 'Ayam, sambal korek, nasi',
    description: 'Paket ayam geprek dengan sambal korek.',
    merchantName: 'Dapur Barokah Kampus',
    category: 'Paket Masak',
    imageUrl: 'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=85',
    price: 18000,
    rating: 4.9,
    reviewCount: 128,
    ingredients: ['Ayam', 'Cabai rawit', 'Bawang putih', 'Nasi'],
    weight: '350 g',
    stock: 12,
    cookingDuration: '25 menit',
    storageDuration: '3 hari di suhu rendah',
    freshnessNote: 'Bahan segar & higienis',
    additionalMenu: ['Bebidas air putih', 'Sambal buat teman'],
    recommendedMenu: 'Ayam Geprek Sambal Korek',
    recommendedMerchantName: 'Dapur Barokah Kampus',
  );

  testWidgets('detail menu tampilkan badge, tab, dan counter porsi', (
    tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: DetailMenuScreen(item: item)));
    await tester.pumpAndSettle();

    expect(find.text('Tambah ke Keranjang'), findsOneWidget);
    expect(find.text('Detail Menu'), findsOneWidget);
  });

  testWidgets('detail menu tampilkan data bahan, waktu, dan rekomendasi', (
    tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: DetailMenuScreen(item: item)));
    await tester.pumpAndSettle();

    expect(
      tester.allWidgets.any(
        (widget) => widget.toString().contains('Durasi memasak'),
      ),
      isTrue,
    );
    expect(
      tester.allWidgets.any(
        (widget) => widget.toString().contains('Jangka simpan'),
      ),
      isTrue,
    );
    expect(
      tester.allWidgets.any(
        (widget) => widget.toString().contains('Bahan segar & higienis'),
      ),
      isTrue,
    );
    expect(
      tester.allWidgets.any(
        (widget) => widget.toString().contains('Menu tambahan'),
      ),
      isTrue,
    );
    expect(
      tester.allWidgets.any(
        (widget) => widget.toString().contains('Rekomendasi menu'),
      ),
      isTrue,
    );
  });

  testWidgets('checkout tampilkan stepper dan pilihan antar lokasi', (
    tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: CartCheckoutScreen(item: item)));

    expect(find.text('Keranjang'), findsOneWidget);
    expect(find.text('Pengiriman'), findsOneWidget);
    expect(find.text('Bayar'), findsOneWidget);
    expect(find.text('Diantar ke Alamat'), findsOneWidget);
    expect(find.text('Ambil ke UMKM'), findsOneWidget);
  });

  testWidgets('direktori mitra tampilkan pencarian dan filter', (tester) async {
    await tester.pumpWidget(MaterialApp(home: MerchantDirectoryScreen()));

    expect(find.text('Cari mitra atau katalog'), findsOneWidget);
    expect(find.text('Terdekat < 1km'), findsOneWidget);
    expect(find.text('Bintang 4.8+'), findsOneWidget);
    expect(find.text('Dapur Barokah Kampus'), findsOneWidget);
  });

  testWidgets('status pesanan tampilkan timeline dan form ulasan', (
    tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: OrderStatusScreen()));

    expect(find.text('Disiapkan UMKM'), findsOneWidget);
    expect(find.text('Bahan Segar'), findsOneWidget);
    expect(find.text('Ulasan'), findsOneWidget);
  });

  testWidgets('pusat bantuan tampilkan FAQ dan pengaduan', (tester) async {
    await tester.pumpWidget(MaterialApp(home: SupportScreen()));
    await tester.pump();

    expect(find.text('Pusat Bantuan'), findsOneWidget);
    expect(find.text('Bagaimana cara memesan?'), findsOneWidget);
    expect(find.text('Form Pengaduan'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Text && widget.data?.contains('5–15 menit') == true,
      ),
      findsOneWidget,
    );
  });
}
