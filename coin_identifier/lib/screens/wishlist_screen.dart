import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/collection_provider.dart';
import '../models/analysis_result.dart';
import 'package:go_router/go_router.dart';

/// Экран wishlist - желаемые монеты
class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CollectionProvider>().loadWishlist();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfo(context),
          ),
        ],
      ),
      body: Consumer<CollectionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.wishlist.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadWishlist(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.wishlist.length,
              itemBuilder: (context, index) {
                final coin = provider.wishlist[index];
                return _buildCoinCard(context, coin, provider);
              },
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
              Icons.bookmark_border,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Your Wishlist is Empty',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add coins you want to acquire to your wishlist',
              textAlign: TextAlign.center,
              style: TextTheme.of(context).bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push('/scan'),
              icon: const Icon(Icons.add),
              label: const Text('Scan a Coin'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoinCard(
    BuildContext context,
    AnalysisResult coin,
    CollectionProvider provider,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // Navigate to details
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Image thumbnail
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: coin.imagePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          coin.imagePath!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.monetization_on,
                            size: 40,
                            color: Colors.grey[400],
                          ),
                        ),
                      )
                    : Icon(
                        Icons.monetization_on,
                        size: 40,
                        color: Colors.grey[400],
                      ),
              ),
              const SizedBox(width: 12),

              // Coin info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coin.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (coin.country != null)
                      Text(
                        '${coin.country} ${coin.yearOfIssue ?? ''}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildRarityBadge(coin.rarityLevel),
                        const SizedBox(width: 8),
                        if (coin.marketValue != null)
                          Text(
                            coin.marketValue!.getFormattedRange(),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Actions
              Column(
                children: [
                  IconButton(
                    icon: Icon(
                      coin.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: coin.isFavorite ? Colors.red : null,
                    ),
                    onPressed: () {
                      if (coin.id != null) {
                        provider.toggleFavorite(coin.id!);
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.check_circle_outline),
                    tooltip: 'Move to Collection',
                    onPressed: () {
                      if (coin.id != null) {
                        provider.toggleWishlist(coin.id!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Moved to collection!')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRarityBadge(String rarity) {
    Color color;
    switch (rarity.toLowerCase()) {
      case 'extremely rare':
        color = Colors.purple;
        break;
      case 'very rare':
        color = Colors.red;
        break;
      case 'rare':
        color = Colors.orange;
        break;
      case 'uncommon':
        color = Colors.blue;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        rarity,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Wishlist'),
        content: const Text(
          'Wishlist contains coins you want to acquire. '
          'Mark coins from scan results as "wishlist" to track them here. '
          'When you acquire a coin, move it to your collection.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
