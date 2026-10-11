/// Data satu UMKM mitra.
class Umkm {
  final String id;
  final String name;
  final String description;
  final String category;
  final double rating;
  final String? address;
  final String? phoneNumber;
  final String? imageUrl;
  final bool isFollowing;

  const Umkm({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.rating,
    this.address,
    this.phoneNumber,
    this.imageUrl,
    this.isFollowing = false,
  });

  /// Membuat salinan UMKM dengan status ikuti yang baru.
  /// Semua field bersifat final, jadi data tidak diubah langsung,
  /// melainkan dibuat objek baru. Ini menghindari menulis ulang 9 field.
  Umkm copyWith({bool? isFollowing}) {
    return Umkm(
      id: id,
      name: name,
      description: description,
      category: category,
      rating: rating,
      address: address,
      phoneNumber: phoneNumber,
      imageUrl: imageUrl,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}
