import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Modern category card for Soko Letu Tz.
///
/// Features:
/// - Material 3 design
/// - Riverpod selected state
/// - Smooth selected/unselected appearance
/// - Category icon
/// - Category name
/// - Optional product count
/// - Responsive sizing
class CategoryCard extends ConsumerWidget {
  const CategoryCard({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.icon,
    this.productCount,
    this.onTap,
  });

  /// Unique ID of the category.
  final String categoryId;

  /// Category display name.
  final String categoryName;

  /// Icon displayed on the card.
  final IconData icon;

  /// Optional number of products in the category.
  final int? productCount;

  /// Called when the category card is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Reads the currently selected category.
    //
    // This provider is expected to be available in
    // lib/providers/app_providers.dart.
    final selectedCategoryId = ref.watch(selectedCategoryProvider);

    final isSelected = selectedCategoryId == categoryId;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant,
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isSelected ? 0.12 : 0.05,
            ),
            blurRadius: isSelected ? 12 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            ref
                .read(selectedCategoryProvider.notifier)
                .setSelectedCategory(categoryId);

            onTap?.call();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Category icon
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.18)
                        : theme.colorScheme.primary.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 28,
                    color: isSelected
                        ? Colors.white
                        : theme.colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 10),

                // Category name
                Text(
                  categoryName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? Colors.white
                        : theme.colorScheme.onSurface,
                  ),
                ),

                // Optional product count
                if (productCount != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '$productCount bidhaa',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.85)
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}