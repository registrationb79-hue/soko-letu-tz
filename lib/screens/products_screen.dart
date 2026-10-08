
// lib/screens/products_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import '../widgets/product_card.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({
    super.key,
    this.title = 'Bidhaa Zote',
  });

  final String title;

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final theme = Theme.of(context);

    final products =
        ref.watch(filteredProductsProvider);

    final selectedCategory =
        ref.watch(selectedCategoryProvider);

    final hasCategory =
        selectedCategory != 'All';

    return Scaffold(
      backgroundColor:
          theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () {
              ref.invalidate(
                filteredProductsProvider,
              );
            },
            icon: const Icon(
              Icons.refresh_rounded,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          if (hasCategory)
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                4,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_alt_rounded,
                    size: 18,
                    color:
                        theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Kategoria: $selectedCategory',
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: theme.textTheme
                          .bodyMedium
                          ?.copyWith(
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ref
                          .read(
                            selectedCategoryProvider
                                .notifier,
                          )
                          .clearCategory();
                    },
                    child:
                        const Text('Ondoa'),
                  ),
                ],
              ),
            ),

          Padding(
            padding:
                const EdgeInsets.fromLTRB(
              16,
              8,
              16,
              12,
            ),
            child: Row(
              children: [
                Text(
                  '${products.length} bidhaa',
                  style: theme.textTheme
                      .titleSmall
                      ?.copyWith(
                    fontWeight:
                        FontWeight.w700,
                    color: theme.colorScheme
                        .onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                if (!hasCategory)
                  const Text(
                    'Bidhaa zote',
                  ),
              ],
            ),
          ),

          Expanded(
            child: products.isEmpty
                ? _EmptyProductsState(
                    selectedCategory:
                        selectedCategory,
                  )
                : GridView.builder(
                    padding:
                        const EdgeInsets.fromLTRB(
                      10,
                      0,
                      10,
                      24,
                    ),
                    itemCount:
                        products.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent:
                          220,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio:
                          0.68,
                    ),
                    itemBuilder:
                        (context, index) {
                      return ProductCard(
                        product:
                            products[index],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _EmptyProductsState
    extends ConsumerWidget {
  const _EmptyProductsState({
    required this.selectedCategory,
  });

  final String selectedCategory;

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final theme = Theme.of(context);

    final hasCategory =
        selectedCategory != 'All';

    return Center(
      child: SingleChildScrollView(
        padding:
            const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration:
                  BoxDecoration(
                color: theme.colorScheme
                    .primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasCategory
                    ? Icons
                        .inventory_2_outlined
                    : Icons
                        .shopping_bag_outlined,
                size: 42,
                color: theme.colorScheme
                    .onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              hasCategory
                  ? 'Hakuna bidhaa kwenye kategoria hii'
                  : 'Hakuna bidhaa kwa sasa',
              textAlign:
                  TextAlign.center,
              style: theme.textTheme
                  .titleMedium
                  ?.copyWith(
                fontWeight:
                    FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hasCategory
                  ? 'Jaribu kuchagua kategoria nyingine ili kuona bidhaa zaidi.'
                  : 'Bidhaa zitakapoingizwa zitaonekana hapa.',
              textAlign:
                  TextAlign.center,
              style: theme.textTheme
                  .bodyMedium
                  ?.copyWith(
                color: theme.colorScheme
                    .onSurfaceVariant,
                height: 1.4,
              ),
            ),
            if (hasCategory) ...[
              const SizedBox(height: 20),
              FilledButton.tonal(
                onPressed: () {
                  ref
                      .read(
                        selectedCategoryProvider
                            .notifier,
                      )
                      .clearCategory();
                },
                child: const Text(
                  'Onyesha bidhaa zote',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
