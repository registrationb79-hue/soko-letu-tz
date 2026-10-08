
// lib/widgets/product_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product_model.dart';
import '../providers/app_providers.dart';

class ProductCard extends ConsumerWidget {
  const ProductCard({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final theme = Theme.of(context);
    final imageUrl =
        product.primaryImageUrl;

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              color: theme.colorScheme.surfaceContainerHighest,
              child: imageUrl == null ||
                      imageUrl.isEmpty
                  ? Icon(
                      Icons.image_outlined,
                      size: 42,
                      color: theme.colorScheme
                          .onSurfaceVariant,
                    )
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return Icon(
                          Icons.broken_image_outlined,
                          size: 42,
                          color: theme.colorScheme
                              .onSurfaceVariant,
                        );
                      },
                      loadingBuilder: (
                        context,
                        child,
                        loadingProgress,
                      ) {
                        if (loadingProgress ==
                            null) {
                          return child;
                        }

                        return const Center(
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        );
                      },
                    ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                12,
                10,
                12,
                10,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name.isEmpty
                        ? 'Bidhaa'
                        : product.name,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'TZS ${product.retailPrice.toStringAsFixed(0)}',
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(
                      color:
                          theme.colorScheme.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  if (product.wholesalePrice >
                      0) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Jumla: TZS ${product.wholesalePrice.toStringAsFixed(0)}',
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(
                        color: theme.colorScheme
                            .onSurfaceVariant,
                      ),
                    ),
                  ],
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: FilledButton.icon(
                      onPressed:
                          product.inStock
                              ? () {
                                  ref
                                      .read(
                                        cartProvider
                                            .notifier,
                                      )
                                      .addToCart(
                                        product,
                                      );

                                  ScaffoldMessenger.of(
                                    context,
                                  )
                                      .hideCurrentSnackBar();

                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Bidhaa imeongezwa kwenye kikapu.',
                                      ),
                                      behavior:
                                          SnackBarBehavior
                                              .floating,
                                    ),
                                  );
                                }
                              : null,
                      icon: const Icon(
                        Icons
                            .add_shopping_cart_rounded,
                        size: 18,
                      ),
                      label: const Text(
                        'Ongeza',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
