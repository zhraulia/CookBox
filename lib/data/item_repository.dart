import '../models/item.dart';

/// Sumber data sementara (dummy). Nanti bisa diganti dengan API/database.
class ItemRepository {
  static const List<Item> _items = [
    Item(
      id: '1',
      title: 'Bahan Sudah Ditakar',
      subtitle: 'Takaran pas untuk tiap porsi',
      description: 'Takaran sesuai resep dan jumlah porsi. Noli sia...',
    ),
    Item(
      id: '2',
      title: 'Praktis & Hemat',
      subtitle: 'Tanpa belanja ke pasar',
      description: 'Tidak perlu belanja bahan satu per satu ke pasar.',
    ),
    Item(
      id: '3',
      title: 'Dukung UMKM Lokal',
      subtitle: 'Langsung dari pedagang',
      description: 'Pesan paket bahan secara langsung dari pedagang.',
    ),
  ];

  /// Mengambil daftar item.
  /// simulateError: true -> sengaja dibuat gagal untuk menguji error state.
  Future<List<Item>> fetchItems({bool simulateError = false}) async {
    await Future.delayed(
      const Duration(seconds: 2),
    ); // simulasi waktu tunggu server
    if (simulateError) {
      throw Exception('Gagal memuat data. Periksa koneksi internet.');
    }
    return _items;
  }
}
