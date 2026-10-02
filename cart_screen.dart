import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import '../models/product_model.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final cartItems = ref.watch(cartProvider);
    final cartTotal = ref.watch(cartTotalProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Kikapu Changu',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              tooltip: 'Futa kikapu',
              onPressed: () {
                _showClearCartDialog(context, ref);
              },
              icon: const Icon(
                Icons.delete_sweep_outlined,
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: cartItems.isEmpty
          ? const _EmptyCart()
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      12,
                      16,
                      20,
                    ),
                    itemCount: cartItems.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final product = cartItems[index];

                      return _CartItemCard(
                        product: product,
                      );
                    },
                  ),
                ),

                // Cart summary
                _CartSummary(
                  cartTotal: cartTotal,
                  itemCount: cartItems.length,
                ),
              ],
            ),
    );
  }

  void _showClearCartDialog(
    BuildContext context,
    WidgetRef ref,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Futa kikapu?',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            'Bidhaa zote zilizopo kwenye kikapu zitaondolewa.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Ghairi'),
            ),
            FilledButton(
              onPressed: () {
                ref
                    .read(cartProvider.notifier)
                    .clearCart();

                Navigator.of(dialogContext).pop();
              },
              child: const Text('Futa'),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// CART ITEM CARD
// ---------------------------------------------------------------------------

class _CartItemCard extends ConsumerWidget {
  const _CartItemCard({
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final quantity = ref.watch(
      cartProvider.select(
        (items) => items
            .where((item) => item.id == product.id)
            .length,
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Product image
            _ProductImage(
              imageUrl: product.imageUrl,
            ),

            const SizedBox(width: 12),

            // Product information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    _formatPrice(product.retailPrice),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Quantity controls
                  Row(
                    children: [
                      _QuantityButton(
                        icon: Icons.remove_rounded,
                        onPressed: quantity > 1
                            ? () {
                                ref
                                    .read(
                                      cartProvider.notifier,
                                    )
                                    .decreaseQuantity(product.id);
                              }
                            : null,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                        ),
                        child: Text(
                          '$quantity',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),

                      _QuantityButton(
                        icon: Icons.add_rounded,
                        onPressed: () {
                          ref
                              .read(cartProvider.notifier)
                              .increaseQuantity(product);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 4),

            // Delete product
            IconButton(
              tooltip: 'Ondoa bidhaa',
              onPressed: () {
                ref
                    .read(cartProvider.notifier)
                    .removeAllOfProduct(product.id);

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Bidhaa imeondolewa kwenye kikapu.',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
              },
              icon: Icon(
                Icons.delete_outline_rounded,
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    return 'TZS ${price.toStringAsFixed(0)}';
  }
}

// ---------------------------------------------------------------------------
// PRODUCT IMAGE
// ---------------------------------------------------------------------------

class _ProductImage extends StatelessWidget {
  const _ProductImage({
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 92,
        height: 110,
        color: theme.colorScheme.surfaceContainerHighest,
        child: imageUrl.isEmpty
            ? Icon(
                Icons.image_not_supported_outlined,
                color: theme.colorScheme.onSurfaceVariant,
                size: 32,
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
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 32,
                  );
                },
                loadingBuilder: (
                  context,
                  child,
                  loadingProgress,
                ) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        value: loadingProgress.expectedTotalBytes !=
                                null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// QUANTITY BUTTON
// ---------------------------------------------------------------------------

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 34,
      height: 34,
      child: IconButton.filledTonal(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 19,
        ),
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          foregroundColor: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// CART SUMMARY
// ---------------------------------------------------------------------------

class _CartSummary extends StatelessWidget {
  const _CartSummary({
    required this.cartTotal,
    required this.itemCount,
  });

  final double cartTotal;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        20,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Bidhaa',
                  style: theme.textTheme.bodyLarge,
                ),
                const Spacer(),
                Text(
                  '$itemCount',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Text(
                  'Jumla',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                Text(
                  'TZS ${cartTotal.toStringAsFixed(0)}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Checkout itaongezwa kwenye hatua inayofuata.',
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                },
                icon: const Icon(
                  Icons.shopping_cart_checkout_rounded,
                ),
                label: const Text(
                  'Endelea na Malipo',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// EMPTY CART
// ---------------------------------------------------------------------------

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 54,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Kikapu chako kiko tupu',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Ongeza bidhaa unazozipenda kwenye kikapu ili kuendelea na manunuzi.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}