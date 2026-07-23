/// Mirrors the `merch_items` table — single platform-wide store.
enum MerchCategory {
  giftCards,
  apparel,
  accessories,
  gamingGear,
  collectibles,
}

MerchCategory _merchCategoryFromString(String value) {
  switch (value) {
    case 'gift_cards':
      return MerchCategory.giftCards;
    case 'apparel':
      return MerchCategory.apparel;
    case 'accessories':
      return MerchCategory.accessories;
    case 'gaming_gear':
      return MerchCategory.gamingGear;
    case 'collectibles':
      return MerchCategory.collectibles;
    default:
      throw ArgumentError('Unknown merch_category: $value');
  }
}

class MerchItem {
  final String id;
  final String name;
  final String? description;
  final double price;
  final MerchCategory category;
  final List<String> images;
  final int stockQuantity;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MerchItem({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.category,
    required this.images,
    required this.stockQuantity,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MerchItem.fromMap(Map<String, dynamic> map) {
    return MerchItem(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      price: (map['price'] as num).toDouble(),
      category: _merchCategoryFromString(map['category'] as String),
      images: List<String>.from(map['images'] as List? ?? []),
      stockQuantity: map['stock_quantity'] as int,
      isActive: map['is_active'] as bool,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  // No toMap() — merch catalog is managed by admin directly via the
  // Supabase dashboard; Flutter only ever reads this table.

  bool get isOutOfStock => stockQuantity <= 0;

  MerchItem copyWith({
    String? name,
    String? description,
    double? price,
    int? stockQuantity,
    bool? isActive,
  }) {
    return MerchItem(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category,
      images: images,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
