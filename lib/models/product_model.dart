
// lib/models/product_model.dart

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double retailPrice;
  final double wholesalePrice;
  final List<String> imageUrls;
  final String categoryId;
  final String categoryName;
  final String sellerId;
  final String sellerName;
  final int stockQuantity;
  final bool isAvailable;
  final String brand;
  final String location;
  final double rating;
  final int reviewCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.retailPrice,
    required this.wholesalePrice,
    required this.imageUrls,
    required this.categoryId,
    required this.categoryName,
    required this.sellerId,
    required this.sellerName,
    required this.stockQuantity,
    required this.isAvailable,
    this.brand = '',
    this.location = '',
    this.rating = 0.0,
    this.reviewCount = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return ProductModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      retailPrice: _toDouble(map['retailPrice']),
      wholesalePrice: _toDouble(map['wholesalePrice']),
      imageUrls: _toStringList(map['imageUrls']),
      categoryId: map['categoryId']?.toString() ?? '',
      categoryName: map['categoryName']?.toString() ?? '',
      sellerId: map['sellerId']?.toString() ?? '',
      sellerName: map['sellerName']?.toString() ?? '',
      stockQuantity: _toInt(map['stockQuantity']),
      isAvailable: _toBool(map['isAvailable']),
      brand: map['brand']?.toString() ?? '',
      location: map['location']?.toString() ?? '',
      rating: _toDouble(map['rating']),
      reviewCount: _toInt(map['reviewCount']),
      createdAt: _toDateTime(map['createdAt']),
      updatedAt: _toDateTime(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'retailPrice': retailPrice,
      'wholesalePrice': wholesalePrice,
      'imageUrls': imageUrls,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'stockQuantity': stockQuantity,
      'isAvailable': isAvailable,
      'brand': brand,
      'location': location,
      'rating': rating,
      'reviewCount': reviewCount,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? retailPrice,
    double? wholesalePrice,
    List<String>? imageUrls,
    String? categoryId,
    String? categoryName,
    String? sellerId,
    String? sellerName,
    int? stockQuantity,
    bool? isAvailable,
    String? brand,
    String? location,
    double? rating,
    int? reviewCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      retailPrice: retailPrice ?? this.retailPrice,
      wholesalePrice: wholesalePrice ?? this.wholesalePrice,
      imageUrls: imageUrls ?? this.imageUrls,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      isAvailable: isAvailable ?? this.isAvailable,
      brand: brand ?? this.brand,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get inStock {
    return stockQuantity > 0 && isAvailable;
  }

  String? get primaryImageUrl {
    if (imageUrls.isEmpty) {
      return null;
    }

    return imageUrls.first;
  }

  static double _toDouble(dynamic value) {
    if (value == null) {
      return 0.0;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString()) ?? 0.0;
  }

  static int _toInt(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value.toString()) ?? 0;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      return value.toLowerCase() == 'true';
    }

    return true;
  }

  static List<String> _toStringList(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .map((item) => item.toString())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    try {
      final dynamic date = value.toDate();

      if (date is DateTime) {
        return date;
      }
    } catch (_) {
      // Ignore unsupported date formats.
    }

    return null;
  }
}
