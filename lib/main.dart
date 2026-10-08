
// lib/main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'screens/auth_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/home_screen.dart';
import 'screens/products_screen.dart';
import 'screens/profile_screen.dart';
import 'services/auth_service.dart';
import 'widgets/bottom_nav_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool firebaseReady = false;

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    firebaseReady = true;
  } catch (_) {
    firebaseReady = false;
  }

  runApp(
    ProviderScope(
      child: SokoLetuApp(
        firebaseReady: firebaseReady,
      ),
    ),
  );
}

class SokoLetuApp extends StatelessWidget {
  const SokoLetuApp({
    super.key,
    required this.firebaseReady,
  });

  final bool firebaseReady;

  static const Color primaryOrange = Color(0xFFFF6A00);
  static const Color darkGrey = Color(0xFF2B2B2B);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soko Letu Tz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryOrange,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: darkGrey,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: primaryOrange,
              width: 1.5,
            ),
          ),
        ),
      ),
      home: AuthWrapper(
        firebaseReady: firebaseReady,
      ),
    );
  }
}

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({
    super.key,
    required this.firebaseReady,
  });

  final bool firebaseReady;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!firebaseReady) {
      return const AuthScreen();
    }

    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      loading: () {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      error: (_, __) {
        return const AuthScreen();
      },
      data: (user) {
        if (user == null) {
          return const AuthScreen();
        }

        return const MainNavigationWrapper();
      },
    );
  }
}

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({
    super.key,
  });

  @override
  State<MainNavigationWrapper> createState() =>
      _MainNavigationWrapperState();
}

class _MainNavigationWrapperState
    extends State<MainNavigationWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ProductsScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
