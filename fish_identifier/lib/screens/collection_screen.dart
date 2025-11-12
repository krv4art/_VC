import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/collection_provider.dart';
import '../constants/app_dimensions.dart';
import '../theme/app_theme.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final collectionProvider = context.watch<CollectionProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.collectionTitle),
      ),
      body: collectionProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : collectionProvider.collection.isEmpty
              ? _buildEmptyState(l10n)
              : Column(
                  children: [
                    _buildStats(l10n, collectionProvider),
                    Expanded(
                      child: _buildCollectionList(
                        context,
                        l10n,
                        collectionProvider.collection,
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.collections,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: AppDimensions.space16),
          Text(l10n.collectionEmpty, style: AppTheme.h3),
          const SizedBox(height: AppDimensions.space8),
          Text(
            l10n.collectionHint,
            style: AppTheme.body.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(AppLocalizations l10n, CollectionProvider provider) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.space16),
      color: Theme.of(provider as BuildContext).primaryColor.withValues(alpha: 0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            l10n.totalCatches,
            provider.totalCatches.toString(),
            Icons.set_meal,
          ),
          _buildStatItem(
            l10n.favoriteFish,
            provider.favorites.length.toString(),
            Icons.favorite,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32),
        const SizedBox(height: AppDimensions.space8),
        Text(value, style: AppTheme.h2),
        Text(label, style: AppTheme.bodySmall),
      ],
    );
  }

  Widget _buildCollectionList(
    BuildContext context,
    AppLocalizations l10n,
    List collection,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.space16),
      itemCount: collection.length,
      cacheExtent: 500, // Preload items for smoother scrolling
      itemBuilder: (context, index) {
        final item = collection[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppDimensions.space12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(AppDimensions.space12),
            leading: Icon(
              item.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: item.isFavorite ? Colors.red : Colors.grey,
            ),
            title: Text(
              l10n.catchNumber('${item.id}'),
              style: AppTheme.h4,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${l10n.date}: ${item.catchDate.toString().substring(0, 10)}',
                  style: AppTheme.bodySmall,
                ),
                if (item.location != null)
                  Text(
                    '${l10n.location}: ${item.location}',
                    style: AppTheme.bodySmall,
                  ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                item.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: () {
                context
                    .read<CollectionProvider>()
                    .toggleFavorite(item.id!);
              },
            ),
          ),
        );
      },
    );
  }
}
