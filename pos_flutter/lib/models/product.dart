class Product {
  final String id;
  final String name;
  final String? barcode;
  final String? categoryId;
  final String? subcategoryId;
  final String? businessType;
  final double buyPrice;
  final double sellPrice;
  final int stockQuantity;
  final int buyUnitQuantity; // Quantity in buy unit
  final String buyUnit; // e.g., "box"
  final String saleUnit; // e.g., "piece"
  final String? imagePath;
  final bool isVisible;
  final DateTime? expiryDate;
  final int reorderLevel;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    this.barcode,
    this.categoryId,
    this.subcategoryId,
    this.businessType,
    required this.buyPrice,
    required this.sellPrice,
    this.stockQuantity = 0,
    this.buyUnitQuantity = 1,
    this.buyUnit = 'unit',
    this.saleUnit = 'unit',
    this.imagePath,
    this.isVisible = true,
    this.expiryDate,
    this.reorderLevel = 5,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'barcode': barcode,
      'category_id': categoryId,
      'subcategory_id': subcategoryId,
      'business_type': businessType,
      'buy_price': buyPrice,
      'sell_price': sellPrice,
      'stock_quantity': stockQuantity,
      'buy_unit_quantity': buyUnitQuantity,
      'buy_unit': buyUnit,
      'sale_unit': saleUnit,
      'image_path': imagePath,
      'is_visible': isVisible ? 1 : 0,
      'expiry_date': expiryDate?.toIso8601String(),
      'reorder_level': reorderLevel,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      barcode: map['barcode'],
      categoryId: map['category_id'],
      subcategoryId: map['subcategory_id'],
      businessType: map['business_type'],
      buyPrice: (map['buy_price'] ?? 0).toDouble(),
      sellPrice: (map['sell_price'] ?? 0).toDouble(),
      stockQuantity: map['stock_quantity'] ?? 0,
      buyUnitQuantity: map['buy_unit_quantity'] ?? 1,
      buyUnit: map['buy_unit'] ?? 'unit',
      saleUnit: map['sale_unit'] ?? 'unit',
      imagePath: map['image_path'],
      isVisible: map['is_visible'] == 1,
      expiryDate: map['expiry_date'] != null 
          ? DateTime.parse(map['expiry_date']) 
          : null,
      reorderLevel: map['reorder_level'] ?? 5,
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : DateTime.now(),
      updatedAt: map['updated_at'] != null 
          ? DateTime.parse(map['updated_at']) 
          : DateTime.now(),
    );
  }

  Product copyWith({
    String? id,
    String? name,
    String? barcode,
    String? categoryId,
    String? subcategoryId,
    String? businessType,
    double? buyPrice,
    double? sellPrice,
    int? stockQuantity,
    int? buyUnitQuantity,
    String? buyUnit,
    String? saleUnit,
    String? imagePath,
    bool? isVisible,
    DateTime? expiryDate,
    int? reorderLevel,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      businessType: businessType ?? this.businessType,
      buyPrice: buyPrice ?? this.buyPrice,
      sellPrice: sellPrice ?? this.sellPrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      buyUnitQuantity: buyUnitQuantity ?? this.buyUnitQuantity,
      buyUnit: buyUnit ?? this.buyUnit,
      saleUnit: saleUnit ?? this.saleUnit,
      imagePath: imagePath ?? this.imagePath,
      isVisible: isVisible ?? this.isVisible,
      expiryDate: expiryDate ?? this.expiryDate,
      reorderLevel: reorderLevel ?? this.reorderLevel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  double get costPerItem => buyPrice / buyUnitQuantity;
  double get profitPerItem => sellPrice - costPerItem;
  
  bool get isLowStock => stockQuantity <= reorderLevel;
  bool get isOutOfStock => stockQuantity == 0;
  
  bool get isNearExpiry {
    if (expiryDate == null) return false;
    final daysLeft = expiryDate!.difference(DateTime.now()).inDays;
    return daysLeft <= 30 && daysLeft >= 0;
  }
  
  bool get isExpired {
    if (expiryDate == null) return false;
    return expiryDate!.isBefore(DateTime.now());
  }
}

class Category {
  final String id;
  final String name;
  final String? parentId;
  final String? businessType;
  final DateTime createdAt;

  Category({
    required this.id,
    required this.name,
    this.parentId,
    this.businessType,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'parent_id': parentId,
      'business_type': businessType,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      parentId: map['parent_id'],
      businessType: map['business_type'],
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : DateTime.now(),
    );
  }
}
