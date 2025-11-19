import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/collection_provider.dart';

/// Экран статистики коллекции
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<CollectionProvider>();
      provider.loadCollection();
      provider.loadWishlist();
      provider.loadStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final provider = context.read<CollectionProvider>();
              provider.loadStats();
            },
          ),
        ],
      ),
      body: Consumer<CollectionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.collectionCount == 0 && provider.wishlistCount == 0) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              await provider.loadStats();
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOverviewCards(provider),
                  const SizedBox(height: 24),
                  _buildRarityChart(provider),
                  const SizedBox(height: 24),
                  _buildCountriesChart(provider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Statistics Yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start building your collection to see statistics',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCards(CollectionProvider provider) {
    final stats = provider.stats;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Collection',
                '${stats['total_count'] ?? 0}',
                Icons.monetization_on,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Wishlist',
                '${stats['wishlist_count'] ?? 0}',
                Icons.bookmark,
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Countries',
                '${(stats['countries'] as List?)?.length ?? 0}',
                Icons.public,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Total Value',
                '\$${(stats['total_value'] ?? 0.0).toStringAsFixed(0)}',
                Icons.attach_money,
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRarityChart(CollectionProvider provider) {
    final stats = provider.stats;
    final rarityData = stats['rarity_distribution'] as List? ?? [];

    if (rarityData.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rarity Distribution',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _buildRaritySections(rarityData),
                  centerSpaceRadius: 60,
                  sectionsSpace: 2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ..._buildRarityLegend(rarityData),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildRaritySections(List<dynamic> data) {
    final colors = [
      Colors.grey,
      Colors.blue,
      Colors.orange,
      Colors.red,
      Colors.purple,
    ];

    return List.generate(data.length, (index) {
      final item = data[index] as Map<String, dynamic>;
      final value = (item['count'] as int).toDouble();

      return PieChartSectionData(
        value: value,
        color: colors[index % colors.length],
        radius: 50,
        title: '${value.toInt()}',
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  List<Widget> _buildRarityLegend(List<dynamic> data) {
    final colors = [
      Colors.grey,
      Colors.blue,
      Colors.orange,
      Colors.red,
      Colors.purple,
    ];

    return List.generate(data.length, (index) {
      final item = data[index] as Map<String, dynamic>;
      final rarity = item['rarity_level'] as String? ?? 'Unknown';
      final count = item['count'] as int;

      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: colors[index % colors.length],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text('$rarity: $count coins'),
          ],
        ),
      );
    });
  }

  Widget _buildCountriesChart(CollectionProvider provider) {
    final stats = provider.stats;
    final countriesData = (stats['countries'] as List? ?? [])
        .take(10)
        .toList(); // Top 10

    if (countriesData.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Countries',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...countriesData.map((item) {
              final country = item['country'] as String? ?? 'Unknown';
              final count = item['count'] as int;
              final maxCount =
                  (countriesData.first['count'] as int).toDouble();
              final percentage = (count / maxCount * 100).toInt();

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          country,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        Text(
                          '$count coins',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: count / maxCount,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
