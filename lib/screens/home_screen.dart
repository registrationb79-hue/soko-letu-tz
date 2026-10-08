
// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import '../widgets/category_card.dart';
import '../widgets/product_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final theme = Theme.of(context);

    final products =
        ref.watch(productsProvider);

    final categories =
        ref.watch(categoriesProvider);

    final searchQuery =
        ref.watch(searchQueryProvider);

    return Scaffold(
      backgroundColor:
          theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'SOKO LETU Tz',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Wasifu',
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(productsProvider);
          ref.invalidate(categoriesProvider);
        },
        child: ListView(
          physics:
              const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            32,
          ),
          children: [
            TextField(
              onChanged: (value) {
                ref
                    .read(
                      searchQueryProvider
                          .notifier,
                    )
                    .setSearchQuery(value);
              },
              decoration:
                  InputDecoration(
                hintText:
                    'Tafuta bidhaa...',
                prefixIcon: const Icon(
                  Icons.search_rounded,
                ),
                suffixIcon:
                    searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              ref
                                  .read(
                                    searchQueryProvider
                                        .notifier,
                                  )
                                  .clearSearch();
                            },
                            icon: const Icon(
                              Icons.clear_rounded,
                            ),
                          )
                        : null,
              ),
            ),

            const SizedBox(height: 16),

            Container(
              padding:
                  const EdgeInsets.all(20),
              decoration:
                  BoxDecoration(
                gradient:
                    LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme
                        .primaryContainer,
                  ],
                  begin:
                      Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.circular(
                  22,
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Karibu SOKO LETU Tz',
                    style: theme.textTheme
                        .headlineSmall
                        ?.copyWith(
                      color: Colors.white,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nunua bidhaa kwa urahisi kutoka kwa wauzaji wa Tanzania.',
                    style: theme.textTheme
                        .bodyMedium
                        ?.copyWith(
                      color: Colors.white
                          .withValues(
                        alpha: 0.9,
                      ),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Text(
                  'Makundi',
                  style: theme.textTheme
                      .titleLarge
                      ?.copyWith(
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child:
                      const Text('Yote'),
                ),
              ],
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: 115,
              child: ListView.separated(
                scrollDirection:
                    Axis.horizontal,
                itemCount:
                    categories.length,
                separatorBuilder:
                    (_, __) =>
                        const SizedBox(
                  width: 10,
                ),
                itemBuilder:
                    (context, index) {
                  final category =
                      categories[index];

                  return CategoryCard(
                    category: category,
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Text(
                  'Bidhaa Maarufu',
                  style: theme.textTheme
                      .titleLarge
                      ?.copyWith(
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
                const Spacer(),
                Text(
                  '${products.length}',
                  style: theme.textTheme
                      .bodyMedium
                      ?.copyWith(
                    color: theme.colorScheme
                        .onSurfaceVariant,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (products.isEmpty)
              Container(
                padding:
                    const EdgeInsets.all(32),
                decoration:
                    BoxDecoration(
                  color: theme.colorScheme
                      .surfaceContainerLow,
                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons
                          .inventory_2_outlined,
                      size: 48,
                      color: theme.colorScheme
                          .onSurfaceVariant,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Hakuna bidhaa kwa sasa.',
                      textAlign:
                          TextAlign.center,
                      style: theme.textTheme
                          .titleMedium
                          ?.copyWith(
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount:
                    products.length >
                            6
                        ? 6
                        : products.length,
                gridDelegate:
                    const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.68,
                ),
                itemBuilder:
                    (context, index) {
                  return ProductCard(
                    product:
                        products[index],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
