// lib/providers/app_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';

/// ===========================================================================
/// SOKO LETU Tz - APP PROVIDERS (RIVERPOD)
/// ===========================================================================
/// Inasimamia:
/// 1. Products (Bidhaa zote)
/// 2. Categories (Kategoria za bidhaa)
/// 3. Selected Category (Kategoria iliyochaguliwa kwa sasa)
/// 4. Search Query (Maneno ya utafutaji)
/// 5. Shopping Cart & Cart Calculations (Kikapu cha manunuzi)
/// ===========================================================================

// 1. PRODUCTS PROVIDER
final productsProvider = NotifierProvider<ProductsNotifier, List<ProductModel>>(() {
  return ProductsNotifier();
});

class ProductsNotifier extends Notifier<List<ProductModel>> {
  @override
  List<ProductModel> build() {
    return [];
  }

  /// Weka bidhaa mpya
  void addProduct(ProductModel product) {
    state = [...state, product];
  }

  /// Weka list nzima ya bidhaa
  void setProducts(List<ProductModel> products) {
    state = products;
  }

  /// Ondoa bidhaa kwa kutumia ID
  void removeProduct(String productId) {
    state = state.where((product) => product.id != productId).toList();
  }
}

// 2. CATEGORIES PROVIDER
final categoriesProvider = Provider<List<String>>((ref) {
  final products = ref.watch(productsProvider);
  final categorySet = <String>{'All'};

  for (final product in products) {
    final category = product.categoryName.trim();
    if (category.isNotEmpty) {
      categorySet.add(category);
    }
  }

  return categorySet.toList();
});

// 3. SELECTED CATEGORY PROVIDER
final selectedCategoryProvider = NotifierProvider<SelectedCategoryNotifier, String>(() {
  return SelectedCategoryNotifier();
});

class SelectedCategoryNotifier extends Notifier<String> {
  @override
  String build() {
    return 'All';
  }

  void setCategory(String category) {
    state = category;
  }

  void clearCategory() {
    state = 'All';
  }
}

// 4. SEARCH QUERY PROVIDER
final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(() {
  return SearchQueryNotifier();
});

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() {
    return '';
  }

  void setSearchQuery(String query) {
    state = query.trim().toLowerCase();
  }

  void clearSearch() {
    state = '';
  }
}

// 5. FILTERED PRODUCTS PROVIDER (Inachuja kwa ajili ya UI)
final filteredProductsProvider = Provider<List<ProductModel>>((ref) {
  final products = ref.watch(productsProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final searchQuery = ref.watch(searchQueryProvider);

  return products.where((product) {
    final matchesSearch = searchQuery.isEmpty ||
        product.name.toLowerCase().contains(searchQuery) ||
        product.description.toLowerCase().contains(searchQuery) ||
        product.brand.toLowerCase().contains(searchQuery);

    final matchesCategory = selectedCategory == 'All' ||
        product.categoryName.toLowerCase() == selectedCategory.toLowerCase();

    return matchesSearch && matchesCategory;
  }).toList();
});

// 6. SHOPPING CART ITEM MODEL
class CartItem {
  final ProductModel product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice {
    return product.retailPrice * quantity;
  }

  CartItem copyWith({
    ProductModel? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

// 7. CART PROVIDER
final cartProvider = NotifierProvider<CartNotifier, Map<String, CartItem>>(() {
  return CartNotifier();
});

class CartNotifier extends Notifier<Map<String, CartItem>> {
  @override
  Map<String, CartItem> build() {
    return {};
  }

  /// Ongeza bidhaa kwenye cart
  void addToCart(ProductModel product) {
    final currentCart = {...state};
    if (currentCart.containsKey(product.id)) {
      currentCart[product.id] = currentCart[product.id]!.copyWith(
        quantity: currentCart[product.id]!.quantity + 1,
      );
    } else {
      currentCart[product.id] = CartItem(product: product, quantity: 1);
    }
    state = currentCart;
  }

  /// Ondoa bidhaa kabisa kwenye cart
  void removeFromCart(String productId) {
    final currentCart = {...state};
    currentCart.remove(productId);
    state = currentCart;
  }

  /// Ongeza idadi ya bidhaa moja kwenye cart
  void increaseQuantity(String productId) {
    final currentCart = {...state};
    if (currentCart.containsKey(productId)) {
      currentCart[productId] = currentCart[productId]!.copyWith(
        quantity: currentCart[productId]!.quantity + 1,
      );
      state = currentCart;
    }
  }

  /// Punguza idadi ya bidhaa kwenye cart
  void decreaseQuantity(String productId) {
    final currentCart = {...state};
    if (currentCart.containsKey(productId)) {
      final currentQty = currentCart[productId]!.quantity;
      if (currentQty > 1) {
        currentCart[productId] = currentCart[productId]!.copyWith(
          quantity: currentQty - 1,
        );
      } else {
        currentCart.remove(productId);
      }
      state = currentCart;
    }
  }

  /// Futa kila kitu kwenye cart
  void clearCart() {
    state = {};
  }
}

// 8. CART COMPUTED PROVIDERS (Hesabu za Jumla)
final cartItemsProvider = Provider<List<CartItem>>((ref) {
  final cartMap = ref.watch(cartProvider);
  return cartMap.values.toList();
});

final cartItemCountProvider = Provider<int>((ref) {
  final cartMap = ref.watch(cartProvider);
  return cartMap.values.fold(0, (total, item) => total + item.quantity);
});

final cartTotalProvider = Provider<double>((ref) {
  final cartMap = ref.watch(cartProvider);
  return cartMap.values.fold(0.0, (total, item) => total + item.totalPrice);
});
