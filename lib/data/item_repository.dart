import '../models/item.dart';

/// Sumber data sementara (dummy). Nanti bisa diganti dengan API/database.
class ItemRepository {
  // Data dummy disesuaikan dengan tema aplikasi CookBox
  static const List<Item> _items = [
    Item(
      id: '1',
      title: 'Paket Masak Ayam Balado',
      subtitle: 'Porsi 2-3 orang • Lengkap dengan bumbu halus',
      description:
          'Paket masak Ayam Balado siap olah. Berisi 500g potongan ayam segar, cabai merah keriting, bawang merah, bawang putih, tomat, dan racikan bumbu khas CookBox yang sudah ditakar pas.',
    ),
    Item(
      id: '2',
      title: 'Paket Sayur Asem Segar',
      subtitle: 'Porsi 3-4 orang • Sayuran potong & bumbu racik',
      description:
          'Paket sayur asem segar lengkap dengan labu siam, jagung manis, kacang panjang, melinjo, daun melinjo, dan bumbu racik asam segar khas Nusantara.',
    ),
    Item(
      id: '3',
      title: 'Paket Nasi Goreng Spesial',
      subtitle: 'Porsi 2 orang • Bumbu rempah & telur',
      description:
          'Bahan lengkap untuk nasi goreng spesial. Termasuk beras pulen porsi 2 orang, 2 butir telur ayam segar, potongan sosis, bumbu iris, dan saus racikan spesial.',
    ),
  ];

  /// Mengambil daftar item.
  /// simulateError: true -> sengaja dibuat gagal untuk menguji error state.
  Future<List<Item>> fetchItems({bool simulateError = false}) async {
    await Future.delayed(const Duration(seconds: 2)); // simulasi waktu tunggu server
    if (simulateError) {
      throw Exception('Gagal memuat data. Periksa koneksi internet.');
    }
    return _items;
  }
}
