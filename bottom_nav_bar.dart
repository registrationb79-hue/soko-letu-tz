import 'package:flutter/material.dart';

/// Modern Material 3 bottom navigation bar
/// for the Soko Letu Tz e-commerce app.
///
/// Tabs:
/// 0 - Home
/// 1 - Categories
/// 2 - Cart
/// 3 - Profile
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  /// Currently selected tab.
  final int currentIndex;

  /// Called when the user selects another tab.
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return NavigationBar(
      selectedIndex: currentIndex.clamp(0, 3),
      onDestinationSelected: onDestinationSelected,

      // Material 3 navigation appearance.
      backgroundColor: theme.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 3,

      // Smooth Material 3 indicator.
      indicatorColor: theme.colorScheme.primaryContainer,

      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,

      animationDuration: const Duration(milliseconds: 300),

      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.grid_view_outlined),
          selectedIcon: Icon(Icons.grid_view),
          label: 'Categories',
        ),
        NavigationDestination(
          icon: Icon(Icons.shopping_cart_outlined),
          selectedIcon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}