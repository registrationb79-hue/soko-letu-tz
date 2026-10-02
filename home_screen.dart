import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import '../widgets/category_card.dart';
import '../widgets/product_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value.trim();
    });
  }

  void _clearSearch() {
    _searchController.clear();

    setState(() {
      _searchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final categories = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    final products = _searchQuery.isEmpty
        ? ref.watch(filteredProductsProvider)
        : ref.watch(productSearchProvider(_searchQuery));

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ------------------------------------------------------------
            // APP BAR
            // ------------------------------------------------------------
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
              floating: true,
              elevation: 0,
              backgroundColor: theme.colorScheme.surface,
              surfaceTintColor: Colors.transparent,

              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SOKO LETU Tz',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.primary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    'Nunua kwa urahisi',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),

              actions: [
                IconButton(
                  tooltip: 'Notifications',
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none_rounded),
                ),
                const SizedBox(width: 4),
              ],
            ),

            // ------------------------------------------------------------
            // SEARCH BAR
            // ------------------------------------------------------------
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  8,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Tafuta bidhaa...',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            tooltip: 'Futa',
                            onPressed: _clearSearch,
                            icon: const Icon(
                              Icons.close_rounded,
                            ),
                          )
                        : null,
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ),

            // ------------------------------------------------------------
            // WELCOME / PROMO BANNER
            // ------------------------------------------------------------
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  20,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primaryContainer,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Karibu SOKO LETU Tz 👋',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Gundua bidhaa bora kutoka kwa wauzaji wa Tanzania.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onPrimary
                                    .withValues(alpha: 0.9),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.shopping_bag_rounded,
                        size: 52,
                        color: theme.colorScheme.onPrimary
                            .withValues(alpha: 0.9),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ------------------------------------------------------------
            // CATEGORIES TITLE
            // ------------------------------------------------------------
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    Text(
                      'Kategoria',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        ref
                            .read(
                              selectedCategoryProvider.notifier,
                            )
                            .setSelectedCategory('');
                      },
                      child: const Text('Zote'),
                    ),
                  ],
                ),
              ),
            ),

            // ------------------------------------------------------------
            // CATEGORIES
            // ------------------------------------------------------------
            SliverToBoxAdapter(
              child: SizedBox(
                height: 128,
                child: categories.isEmpty
                    ? const Center(
                        child: Text(
                          'Hakuna kategoria kwa sasa',
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];

                          return SizedBox(
                            width: 110,
                            child: CategoryCard(
                              categoryId: category,
                              categoryName: category,
                              icon: _getCategoryIcon(category),
                            ),
                          );
                        },
                      ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 12),
            ),

            // ------------------------------------------------------------
            // PRODUCTS TITLE
            // ------------------------------------------------------------
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  4,
                  16,
                  12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _searchQuery.isNotEmpty
                            ? 'Matokeo ya utafutaji'
                            : selectedCategory.isEmpty
                                ? 'Bidhaa Maarufu'
                                : selectedCategory,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      Text(
                        '${products.length}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // ------------------------------------------------------------
            // PRODUCTS GRID
            // ------------------------------------------------------------
            if (products.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 50,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _searchQuery.isNotEmpty
                            ? Icons.search_off_rounded
                            : Icons.inventory_2_outlined,
                        size: 64,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _searchQuery.isNotEmpty
                            ? 'Hakuna bidhaa iliyopatikana'
                            : 'Hakuna bidhaa kwa sasa',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _searchQuery.isNotEmpty
                            ? 'Jaribu kutafuta kwa jina jingine.'
                            : 'Bidhaa zitaonekana hapa baada ya kuongezwa.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  10,
                  0,
                  10,
                  24,
                ),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = products[index];

                      return ProductCard(
                        product: product,
                      );
                    },
                    childCount: products.length,
                  ),
                  gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.68,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Returns a suitable icon for common Tanzanian e-commerce categories.
  IconData _getCategoryIcon(String category) {
    final normalized = category.toLowerCase().trim();

    if (normalized.contains('simu') ||
        normalized.contains('phone') ||
        normalized.contains('electronics')) {
      return Icons.smartphone_rounded;
    }

    if (normalized.contains('nguo') ||
        normalized.contains('fashion') ||
        normalized.contains('clothes')) {
      return Icons.checkroom_rounded;
    }

    if (normalized.contains('viatu') ||
        normalized.contains('shoes')) {
      return Icons.shopping_bag_rounded;
    }

    if (normalized.contains('beauty') ||
        normalized.contains('urembo') ||
        normalized.contains('cosmetic')) {
      return Icons.face_retouching_natural_rounded;
    }

    if (normalized.contains('nyumbani') ||
        normalized.contains('home') ||
        normalized.contains('furniture')) {
      return Icons.chair_rounded;
    }

    if (normalized.contains('chakula') ||
        normalized.contains('food')) {
      return Icons.restaurant_rounded;
    }

    if (normalized.contains('gari') ||
        normalized.contains('auto') ||
        normalized.contains('motor')) {
      return Icons.directions_car_rounded;
    }

    if (normalized.contains('sports') ||
        normalized.contains('michezo')) {
      return Icons.sports_soccer_rounded;
    }

    return Icons.category_rounded;
  }
}