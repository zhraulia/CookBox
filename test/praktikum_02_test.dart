import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nama_project/main.dart';
import 'package:nama_project/screens/catatan_form_screen.dart';
import 'package:nama_project/screens/detail_screen.dart';
import 'package:nama_project/screens/not_found_screen.dart';
import 'package:nama_project/widgets/state_views.dart';

void main() {
  testWidgets('1. Login dengan isian salah menampilkan pesan error', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // Skenario A: Tekan login saat field masih kosong
    // ignore: avoid_print
    print('\n--- PENGUJIAN 1A: Form Kosong ---');
    await tester.tap(find.text('Masuk  →'));
    await tester.pump();

    final errorHpKosong = find.text('Nomor HP wajib diisi');
    final errorPassKosong = find.text('Password minimal 6 karakter');

    // ignore: avoid_print
    print('Bukti pesan error HP kosong: "${tester.widget<Text>(errorHpKosong).data}"');
    // ignore: avoid_print
    print('Bukti pesan error Password kosong: "${tester.widget<Text>(errorPassKosong).data}"');

    expect(errorHpKosong, findsOneWidget);
    expect(errorPassKosong, findsOneWidget);

    // Skenario B: Isi Nomor HP tidak valid (< 8 digit) dan Password pendek (< 6 karakter)
    // ignore: avoid_print
    print('\n--- PENGUJIAN 1B: Isian Tidak Valid (HP: 123, Pass: abc) ---');
    await tester.enterText(find.byType(TextFormField).first, '123');
    await tester.enterText(find.byType(TextFormField).last, 'abc');
    await tester.tap(find.text('Masuk  →'));
    await tester.pump();

    final errorHpFormat = find.text('Masukkan nomor HP yang valid');
    final errorPassPendek = find.text('Password minimal 6 karakter');

    // ignore: avoid_print
    print('Bukti pesan error HP < 8 digit: "${tester.widget<Text>(errorHpFormat).data}"');
    // ignore: avoid_print
    print('Bukti pesan error Password < 6 karakter: "${tester.widget<Text>(errorPassPendek).data}"');

    expect(errorHpFormat, findsOneWidget);
    expect(errorPassPendek, findsOneWidget);
    // ignore: avoid_print
    print('--- SEMUA BUKTI VALIDASI BERHASIL DITAMPILKAN ---\n');
  });

  testWidgets(
    '2. Login benar pindah ke Home, 3. Home menampilkan loading lalu data, 5. Tap item ke Detail, 6. Catatan form ke Detail',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Isi form login dengan benar
      await tester.enterText(find.byType(TextFormField).first, '81234567890');
      await tester.enterText(find.byType(TextFormField).last, 'password');
      await tester.tap(find.text('Masuk  →'));
      await tester.pump();

      // Transisi dari login ke home
      await tester.pump(const Duration(milliseconds: 950));
      await tester.pump();

      // State loading di Home
      expect(find.text('Memuat data...'), findsOneWidget);

      // Tunggu delay 2 detik dari repository dan pastikan snackbar login selesai
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      // Data berhasil tampil di Home
      expect(find.text('Pilihan Paket Masak'), findsOneWidget);
      expect(find.text('Paket Masak Ayam Balado'), findsOneWidget);

      // Tap item pertama untuk navigasi ke Detail
      await tester.tap(find.text('Paket Masak Ayam Balado'));
      await tester.pumpAndSettle();

      // Halaman Detail terbuka dengan data yang sesuai
      expect(find.byType(DetailScreen), findsOneWidget);
      expect(find.text('Belum ada catatan.'), findsOneWidget);
      expect(find.text('Tulis Catatan'), findsOneWidget);

      // Buka Form Catatan
      await tester.tap(find.text('Tulis Catatan'));
      await tester.pumpAndSettle();

      expect(find.byType(CatatanFormScreen), findsOneWidget);

      // Validasi form catatan (kurang dari 5 karakter)
      await tester.enterText(find.byType(TextFormField), 'halo');
      await tester.tap(find.text('Simpan'));
      await tester.pump();
      expect(find.text('Catatan minimal 5 karakter'), findsOneWidget);

      // Simpan catatan yang valid
      await tester.enterText(
        find.byType(TextFormField),
        'Tolong cabainya ditambah ya!',
      );
      await tester.tap(find.text('Simpan'));
      await tester.pump(); // trigger pop
      await tester.pump(const Duration(milliseconds: 350)); // pop transition selesai, kembalikan data
      await tester.pump(); // render detail screen & panggil showSnackBar
      await tester.pump(const Duration(milliseconds: 300)); // animasi SnackBar muncul

      // Kembali ke Detail dan catatan tampil
      expect(find.byType(DetailScreen), findsOneWidget);
      expect(
        find.text('Catatan: Tolong cabainya ditambah ya!'),
        findsOneWidget,
      );
      expect(find.text('Catatan berhasil disimpan'), findsOneWidget);
    },
  );

  testWidgets(
    '4. ErrorView menampilkan pesan error dan tombol Coba Lagi',
    (WidgetTester tester) async {
      bool retried = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(
              message: 'Gagal memuat data. Periksa koneksi internet.',
              onRetry: () => retried = true,
            ),
          ),
        ),
      );

      expect(find.text('Oops, terjadi kesalahan'), findsOneWidget);
      expect(
        find.text('Gagal memuat data. Periksa koneksi internet.'),
        findsOneWidget,
      );
      expect(find.text('Coba Lagi'), findsOneWidget);

      await tester.tap(find.text('Coba Lagi'));
      expect(retried, isTrue);
    },
  );

  testWidgets('7. Route tidak terdaftar menampilkan NotFoundScreen (404)', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final navigatorContext = tester.element(find.byType(Navigator));
    Navigator.of(navigatorContext).pushNamed('/route-tidak-dikenal');
    await tester.pumpAndSettle();

    expect(find.byType(NotFoundScreen), findsOneWidget);
    expect(find.text('404'), findsOneWidget);
    expect(find.text('Route: /route-tidak-dikenal'), findsOneWidget);
  });
}
