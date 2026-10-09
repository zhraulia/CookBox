import '../models/item.dart';

/// Sumber data sementara (dummy). Nanti bisa diganti dengan API/database.
class ItemRepository {
  // Ganti isi data dummy ini sesuai aplikasi kelompok
  static const List<Item> _items = [
    Item(
      id: '1',
      title: 'Ayam Geprek Sambal Korek',
      subtitle: 'Ayam, sambal korek, nasi',
      description: 'Paket ayam geprek dengan sambal korek.',
      merchantName: 'Dapur Bu Tini',
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
      recommendedItemId: '2',
      recommendedMenu: 'Cah Kangkung Terasi',
      recommendedMerchantName: 'Pasar Segar Bu Sari',
    ),
    Item(
      id: '2',
      title: 'Cah Kangkung Terasi',
      subtitle: 'Kangkung segar, bumbu terasi',
      description: 'Sayur segar siap dimasak.',
      merchantName: 'Pasar Segar Bu Sari',
      category: 'Segar',
      imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=900&q=85',
      price: 8500,
      rating: 4.8,
      reviewCount: 86,
      ingredients: ['Kangkung', 'Bumbu terasi', 'Bawang merah', 'Cabai'],
      weight: '250 g',
      stock: 20,
      cookingDuration: '18 menit',
      storageDuration: '2 hari di suhu rendah',
      freshnessNote: 'Sayur segar & dipilih setiap hari',
      additionalMenu: ['Bumbu terasi tambahan', 'Nasi putih'],
      recommendedItemId: '3',
      recommendedMenu: 'Sup Telur Bakso Gurih',
      recommendedMerchantName: 'Kantin Mbak Sari',
    ),
    Item(
      id: '3',
      title: 'Sup Telur Bakso Gurih',
      subtitle: 'Telur, bakso, sayuran',
      description: 'Lauk praktis untuk makan sehari-hari.',
      merchantName: 'Kantin Mbak Sari',
      category: 'Lauk Instan',
      imageUrl: 'https://images.unsplash.com/photo-1547592166-23ac45744acd?auto=format&fit=crop&w=900&q=85',
      price: 12000,
      rating: 4.9,
      reviewCount: 94,
      ingredients: ['Telur', 'Bakso sapi', 'Wortel', 'Daun bawang'],
      weight: '300 g',
      stock: 15,
      cookingDuration: '30 menit',
      storageDuration: '4 hari di suhu rendah',
      freshnessNote: 'Bahan segar & higienis',
      additionalMenu: ['Brotowelt', 'Roti panggang'],
      recommendedItemId: '4',
      recommendedMenu: 'Tumis Tempe Orek',
      recommendedMerchantName: 'Dapur Hemat Kampus',
    ),
    Item(
      id: '4',
      title: 'Tumis Tempe Orek',
      subtitle: 'Tempe, kecap, bumbu pilihan',
      description: 'Menu hemat dengan bahan yang sudah ditakar.',
      merchantName: 'Dapur Hemat Kampus',
      category: 'Hemat Kos',
      imageUrl: 'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=85',
      price: 9500,
      rating: 4.7,
      reviewCount: 62,
      ingredients: ['Tempe', 'Kecap manis', 'Bawang merah', 'Cabai'],
      weight: '250 g',
      stock: 18,
      cookingDuration: '20 menit',
      storageDuration: '2 hari di suhu rendah',
      freshnessNote: 'Tempe segar & higienis',
      additionalMenu: ['Kecap asin', 'Bumbu pedas'],
      recommendedItemId: '1',
      recommendedMenu: 'Ayam Geprek Sambal Korek',
      recommendedMerchantName: 'Dapur Bu Tini',
    ),
  ];

  static Item? findById(String? id) {
    if (id == null) return null;
    return _items.where((item) => item.id == id).firstOrNull;
  }

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
