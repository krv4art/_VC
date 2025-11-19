import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../flutter_gen/gen_l10n/app_localizations.dart';
import 'camera_screen.dart';
import 'history_screen.dart';
import 'collection_screen.dart';
import 'chat_screen.dart';
import 'settings_screen.dart';
import 'forecast_screen.dart';
import 'regulations_screen.dart';
import 'statistics_screen.dart';

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
      const ChatScreen(fishId: null), // Universal AI chat without specific fish context
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: _currentIndex == 0 ? AppBar(
        title: const Text('Fish Identifier'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _showQuickMenu(context),
          ),
        ],
      ) : null,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      drawer: _buildDrawer(context, l10n),
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
            icon: const Icon(Icons.chat_bubble_outline),
            label: l10n.tabChat,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.tabSettings,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, AppLocalizations l10n) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.phishing, size: 48, color: Colors.white),
                const SizedBox(height: 8),
                const Text(
                  'Fish Identifier',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Pro Features',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.cloud),
            title: Text(l10n.tabForecast ?? 'Fishing Forecast'),
            subtitle: const Text('Weather & solunar data'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ForecastScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.gavel),
            title: Text(l10n.tabRegulations ?? 'Regulations'),
            subtitle: const Text('Fishing laws & compliance'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegulationsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: Text(l10n.tabStatistics ?? 'Statistics'),
            subtitle: const Text('Analytics & records'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StatisticsScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Fishing Map'),
            onTap: () {
              Navigator.pop(context);
              context.push('/fishing-map');
            },
          ),
          ListTile(
            leading: const Icon(Icons.workspace_premium),
            title: const Text('Go Premium'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'PRO',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              context.push('/premium');
            },
          ),
        ],
      ),
    );
  }

  void _showQuickMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Quick Access',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickMenuItem(
                  context,
                  Icons.cloud,
                  'Forecast',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ForecastScreen()),
                  ),
                ),
                _buildQuickMenuItem(
                  context,
                  Icons.gavel,
                  'Regulations',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegulationsScreen()),
                  ),
                ),
                _buildQuickMenuItem(
                  context,
                  Icons.bar_chart,
                  'Statistics',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const StatisticsScreen()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickMenuItem(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
