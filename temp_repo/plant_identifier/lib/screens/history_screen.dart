import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/plant_history_provider.dart';
import '../theme/app_theme.dart';
import 'plant_result_screen.dart';

/// History screen - Shows past plant identifications
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyProvider = context.watch<PlantHistoryProvider>();
    final history = historyProvider.history;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.historyTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () {
                // Show confirmation dialog
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(l10n.clearHistory),
                    content: Text(
                      l10n.clearHistoryConfirm,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(l10n.cancel),
                      ),
                      TextButton(
                        onPressed: () {
                          historyProvider.clearHistory();
                          Navigator.pop(ctx);
                        },
                        child: Text(l10n.clear),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: historyProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : history.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 100,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l10n.noHistory,
                        style: AppTheme.h3.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          l10n.noHistoryDesc,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AppTheme.space16),
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final result = history[index];
                    return Card(
                      margin: const EdgeInsets.only(
                        bottom: AppTheme.space16,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green[100],
                          child: Icon(
                            _getIconForType(result.type.toString()),
                            color: Colors.green[700],
                          ),
                        ),
                        title: Text(result.plantName),
                        subtitle: Text(result.scientificName),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            historyProvider.deleteResult(result.id);
                          },
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PlantResultScreen(result: result),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }

  IconData _getIconForType(String type) {
    if (type.contains('mushroom')) return Icons.park;
    if (type.contains('tree')) return Icons.forest;
    if (type.contains('flower')) return Icons.local_florist;
    return Icons.eco;
  }
}
