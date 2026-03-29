import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:golden_app/l10n/app_localizations.dart';
import '../../data/models/gold_item.dart';
import '../../views/home/home_screen.dart';
import '../../views/add_gold/add_gold_screen.dart';
import '../../views/gold_detail/gold_detail_screen.dart';
import '../../views/zakat/zakat_screen.dart';
import '../../views/settings/settings_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String addGold = '/add-gold';
  static const String editGold = '/edit-gold';
  static const String goldDetail = '/gold-detail';
  static const String zakat = '/zakat';
  static const String settings = '/settings';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: MainShell(),
      ),
    ),
    GoRoute(
      path: AppRoutes.addGold,
      pageBuilder: (context, state) => MaterialPage(
        child: AddGoldScreen(existingItem: null),
      ),
    ),
    GoRoute(
      path: AppRoutes.editGold,
      pageBuilder: (context, state) {
        final item = state.extra as GoldItem;
        return MaterialPage(child: AddGoldScreen(existingItem: item));
      },
    ),
    GoRoute(
      path: AppRoutes.goldDetail,
      pageBuilder: (context, state) {
        final item = state.extra as GoldItem;
        return MaterialPage(child: GoldDetailScreen(item: item));
      },
    ),
  ],
);

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ZakatScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.diamond_outlined),
            activeIcon: const Icon(Icons.diamond),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calculate_outlined),
            activeIcon: const Icon(Icons.calculate),
            label: l10n.zakat,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            activeIcon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }
}
