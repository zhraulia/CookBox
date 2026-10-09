class Item {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String merchantName;
  final String category;
  final String? imageUrl;
  final int? price;
  final double? rating;
  final int? reviewCount;
  final List<String> ingredients;
  final String? weight;
  final int? stock;
  final String? cookingDuration;
  final String? storageDuration;
  final String? freshnessNote;
  final List<String> additionalMenu;
  final String? recommendedItemId;
  final String? recommendedMenu;
  final String? recommendedMerchantName;

  const Item({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.merchantName,
    required this.category,
    this.imageUrl,
    this.price,
    this.rating,
    this.reviewCount,
    this.ingredients = const [],
    this.weight,
    this.stock,
    this.cookingDuration,
    this.storageDuration,
    this.freshnessNote,
    this.additionalMenu = const [],
    this.recommendedItemId,
    this.recommendedMenu,
    this.recommendedMerchantName,
  });

  String get priceLabel {
    final amount = price;
    if (amount == null) return 'Harga belum tersedia';
    final digits = amount.toString();
    final grouped = digits.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
    return 'Rp $grouped';
  }
}
