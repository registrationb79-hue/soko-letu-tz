
// lib/widgets/category_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';

class CategoryCard extends ConsumerWidget {
  const CategoryCard({
    super.key,
    required this.category,
    this.icon = Icons.category_outlined,
  });

  final String category;
  final IconData icon;

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final theme = Theme.of(context);
    final selectedCategory =
        ref.watch(selectedCategoryProvider);

    final isSelected =
        selectedCategory.toLowerCase() ==
            category.toLowerCase();

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        ref
            .read(
              selectedCategoryProvider
                  .notifier,
            )
            .setCategory(category);
      },
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 200,
        ),
        width: 105,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme
                  .surfaceContainerLow,
          borderRadius:
              BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme
                    .outlineVariant,
          ),
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              category,
              maxLines: 1,
              overflow:
                  TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall
                  ?.copyWith(
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
