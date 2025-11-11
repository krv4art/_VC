import 'package:flutter/material.dart';
import '../flutter_gen/gen_l10n/app_localizations.dart';
import 'camera_screen.dart';
import 'history_screen.dart';
import 'collection_screen.dart';
import 'settings_screen.dart';

/// Main screen with bottom navigation
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const CameraScreen(),
      const HistoryScreen(),
      const CollectionScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.camera_alt),
            label: l10n.tabCamera,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.history),
            label: l10n.tabHistory,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.collections),
            label: l10n.tabCollection,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.tabSettings,
          ),
        ],
      ),
    );
  }
}
