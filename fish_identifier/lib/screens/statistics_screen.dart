import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/statistics_provider.dart';
import '../services/export_service.dart';
import '../flutter_gen/gen_l10n/app_localizations.dart';

/// Screen showing fishing statistics and analytics
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    await context.read<StatisticsProvider>().loadStatistics();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabStatistics ?? 'Statistics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: _exportStatistics,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStatistics,
          ),
        ],
      ),
      body: Consumer<StatisticsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!provider.hasData) {
            return const Center(
              child: Text('No statistics available.\nStart catching fish!'),
            );
          }

          final stats = provider.currentStats!;

          return RefreshIndicator(
            onRefresh: _loadStatistics,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Overview card
                _buildOverviewCard(stats.overall),
                const SizedBox(height: 16),

                // Personal records
                _buildPersonalRecordsCard(stats.records),
                const SizedBox(height: 16),

                // Species distribution
                _buildSpeciesChart(stats.bySpecies),
                const SizedBox(height: 16),

                // Catch trend
                _buildCatchTrendChart(stats.byTime),
                const SizedBox(height: 16),

                // Location stats
                _buildLocationStats(stats.byLocation),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewCard(overall) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Divider(),
            _buildStatRow('Total Catches', overall.totalCatches.toString()),
            _buildStatRow('Unique Species', overall.uniqueSpecies.toString()),
            _buildStatRow('Unique Locations', overall.uniqueLocations.toString()),
            _buildStatRow('Avg Length', '${overall.averageLength.toStringAsFixed(1)} cm'),
            _buildStatRow('Avg Weight', '${overall.averageWeight.toStringAsFixed(2)} kg'),
            _buildStatRow('Days Active', overall.daysActive.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalRecordsCard(records) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Personal Records', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Divider(),
            if (records.longestFish != null)
              _buildRecordTile(
                '🏆 Longest Fish',
                '${records.longestFish!.speciesName} - ${records.longestFish!.length.toStringAsFixed(1)}cm',
              ),
            if (records.heaviestFish != null)
              _buildRecordTile(
                '⚖️ Heaviest Fish',
                '${records.heaviestFish!.speciesName} - ${records.heaviestFish!.weight.toStringAsFixed(2)}kg',
              ),
            _buildRecordTile('🔥 Current Streak', '${records.currentStreak} days'),
            _buildRecordTile('📅 Longest Streak', '${records.longestStreak} days'),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeciesChart(List species) {
    if (species.isEmpty) return const SizedBox();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Species Distribution', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: species.take(5).map((s) {
                    return PieChartSectionData(
                      value: s.count.toDouble(),
                      title: '${s.count}',
                      color: _getRandomColor(s.speciesName.hashCode),
                      radius: 80,
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...species.take(5).map((s) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        color: _getRandomColor(s.speciesName.hashCode),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(s.speciesName)),
                      Text('${s.percentage.toStringAsFixed(1)}%'),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildCatchTrendChart(List timeStats) {
    if (timeStats.isEmpty) return const SizedBox();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Catch Trend', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: timeStats
                          .asMap()
                          .entries
                          .map((e) => FlSpot(
                                e.key.toDouble(),
                                e.value.catches.toDouble(),
                              ))
                          .toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationStats(List locations) {
    if (locations.isEmpty) return const SizedBox();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Top Locations', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Divider(),
            ...locations.take(5).map((loc) => ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(loc.locationName),
                  subtitle: Text('${loc.count} catches • ${loc.uniqueSpecies} species'),
                  trailing: Text('${(loc.successRate * 100).toStringAsFixed(0)}%'),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildRecordTile(String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  Color _getRandomColor(int seed) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];
    return colors[seed % colors.length];
  }

  Future<void> _exportStatistics() async {
    final stats = context.read<StatisticsProvider>().currentStats;
    if (stats == null) return;

    try {
      final file = await ExportService.instance.exportStatisticsToPdf(stats);
      await ExportService.instance.shareFile(file, subject: 'My Fishing Statistics');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Statistics exported successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }
}
