
// lib/widgets/bottom_nav_bar.dart

import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected:
          onDestinationSelected,
      destinations: const [
        NavigationDestination(
          icon: Icon(
            Icons.home_outlined,
          ),
          selectedIcon: Icon(
            Icons.home_rounded,
          ),
          label: 'Nyumbani',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.grid_view_outlined,
          ),
          selectedIcon: Icon(
            Icons.grid_view_rounded,
          ),
          label: 'Bidhaa',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.shopping_cart_outlined,
          ),
          selectedIcon: Icon(
            Icons.shopping_cart_rounded,
          ),
          label: 'Kikapu',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.person_outline_rounded,
          ),
          selectedIcon: Icon(
            Icons.person_rounded,
          ),
          label: 'Wasifu',
        ),
      ],
    );
  }
}
