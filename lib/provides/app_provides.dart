
// lib/providers/app_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product_model.dart';

final productsProvider =
    NotifierProvider<ProductsNotifier, List<ProductModel>>(
  ProductsNotifier.new,
);

class ProductsNotifier extends Notifier<List<ProductModel>> {
  @override
  List<ProductModel> build() {
    return [];
  }

  void addProduct(ProductModel product) {
    state = [
      ...state,
      product,
    ];
  }

  void setProducts(
    List<ProductModel> products,
  ) {
    state = products;
  }

  void removeProduct(
    String productId,
  ) {
    state = state
        .where(
          (product) => product.id != productId,
        )
        .toList();
  }

  void clearProducts() {
    state = [];
  }
}

final categoriesProvider = Provider<List<String>>((ref) {
  final products = ref.watch(productsProvider);

  final categorySet = <String>{
    'All',
  };

  for (final product in products) {
    final category = product.categoryName.trim();

    if (category.isNotEmpty) {
      categorySet.add(category);
    }
  }

  return categorySet.toList();
});

final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, String>(
  SelectedCategoryNotifier.new,
);

class SelectedCategoryNotifier extends Notifier<String> {
  @override
  String build() {
    return 'All';
  }

  void setCategory(
    String category,
  ) {
    final value = category.trim();

    state = value.isEmpty ? 'All' : value;
  }

  void clearCategory() {
    state = 'All';
  }
}

final searchQueryProvider =
    NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() {
    return '';
  }

  void setSearchQuery(
    String query,
  ) {
    state = query.trim().toLowerCase();
  }

  void clearSearch() {
    state = '';
  }
}

final filteredProductsProvider =
    Provider<List<ProductModel>>((ref) {
  final products = ref.watch(productsProvider);
  final selectedCategory =
      ref.watch(selectedCategoryProvider);
  final searchQuery =
      ref.watch(searchQueryProvider);

  return products.where((product) {
    final normalizedName =
        product.name.toLowerCase();

    final normalizedDescription =
        product.description.toLowerCase();

    final normalizedBrand =
        product.brand.toLowerCase();

    final normalizedCategory =
        product.categoryName.toLowerCase();

    final matchesSearch =
        searchQuery.isEmpty ||
        normalizedName.contains(searchQuery) ||
        normalizedDescription.contains(searchQuery) ||
        normalizedBrand.contains(searchQuery);

    final matchesCategory =
        selectedCategory == 'All' ||
        normalizedCategory ==
            selectedCategory.toLowerCase();

    return matchesSearch && matchesCategory;
  }).toList();
});

class CartItem {
  const CartItem({
    required this.product,
    this.quantity = 1,
  });

  final ProductModel product;
  final int quantity;

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

final cartProvider =
    NotifierProvider<CartNotifier, Map<String, CartItem>>(
  CartNotifier.new,
);

class CartNotifier
    extends Notifier<Map<String, CartItem>> {
  @override
  Map<String, CartItem> build() {
    return {};
  }

  void addToCart(
    ProductModel product,
  ) {
    final currentCart = {
      ...state,
    };

    final existingItem =
        currentCart[product.id];

    if (existingItem != null) {
      currentCart[product.id] =
          existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
    } else {
      currentCart[product.id] = CartItem(
        product: product,
        quantity: 1,
      );
    }

    state = currentCart;
  }

  void removeFromCart(
    String productId,
  ) {
    final currentCart = {
      ...state,
    };

    currentCart.remove(productId);

    state = currentCart;
  }

  void increaseQuantity(
    String productId,
  ) {
    final currentCart = {
      ...state,
    };

    final item = currentCart[productId];

    if (item == null) {
      return;
    }

    currentCart[productId] =
        item.copyWith(
      quantity: item.quantity + 1,
    );

    state = currentCart;
  }

  void decreaseQuantity(
    String productId,
  ) {
    final currentCart = {
      ...state,
    };

    final item = currentCart[productId];

    if (item == null) {
      return;
    }

    if (item.quantity > 1) {
      currentCart[productId] =
          item.copyWith(
        quantity: item.quantity - 1,
      );
    } else {
      currentCart.remove(productId);
    }

    state = currentCart;
  }

  void clearCart() {
    state = {};
  }
}

final cartItemsProvider =
    Provider<List<CartItem>>((ref) {
  final cart = ref.watch(cartProvider);

  return cart.values.toList();
});

final cartItemCountProvider =
    Provider<int>((ref) {
  final cart = ref.watch(cartProvider);

  return cart.values.fold<int>(
    0,
    (total, item) => total + item.quantity,
  );
});

final cartTotalProvider =
    Provider<double>((ref) {
  final cart = ref.watch(cartProvider);

  return cart.values.fold<double>(
    0.0,
    (total, item) => total + item.totalPrice,
  );
});
