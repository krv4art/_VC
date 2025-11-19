import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/collection_provider.dart';
import '../models/analysis_result.dart';

/// Экран истории/коллекции с фильтрами и поиском
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCountry;
  String? _selectedRarity;
  bool _showFavoritesOnly = false;
  List<AnalysisResult> _filteredCoins = [];
  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CollectionProvider>().loadCollection();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters(CollectionProvider provider) {
    var coins = provider.collection;

    // Filter by search query
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      coins = coins.where((coin) {
        return coin.name.toLowerCase().contains(query) ||
            coin.description.toLowerCase().contains(query) ||
            (coin.country?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Filter by country
    if (_selectedCountry != null) {
      coins = coins.where((coin) => coin.country == _selectedCountry).toList();
    }

    // Filter by rarity
    if (_selectedRarity != null) {
      coins = coins.where((coin) => coin.rarityLevel == _selectedRarity).toList();
    }

    // Filter by favorites
    if (_showFavoritesOnly) {
      coins = coins.where((coin) => coin.isFavorite).toList();
    }

    setState(() {
      _filteredCoins = coins;
      _isSearchActive = _searchController.text.isNotEmpty ||
          _selectedCountry != null ||
          _selectedRarity != null ||
          _showFavoritesOnly;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Collection'),
        actions: [
          IconButton(
            icon: Icon(_showFavoritesOnly ? Icons.favorite : Icons.favorite_border),
            tooltip: 'Show Favorites Only',
            onPressed: () {
              setState(() {
                _showFavoritesOnly = !_showFavoritesOnly;
              });
              _applyFilters(context.read<CollectionProvider>());
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filters',
            onPressed: () => _showFiltersDialog(),
          ),
        ],
      ),
      body: Consumer<CollectionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final coinsToDisplay = _isSearchActive ? _filteredCoins : provider.collection;

          if (coinsToDisplay.isEmpty && !_isSearchActive) {
            return _buildEmptyState();
          }

          return Column(
            children: [
              _buildSearchBar(provider),
              if (_isSearchActive) _buildActiveFiltersChips(provider),
              Expanded(
                child: coinsToDisplay.isEmpty
                    ? _buildNoResultsState()
                    : RefreshIndicator(
                        onRefresh: () async {
                          await provider.loadCollection();
                          _applyFilters(provider);
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: coinsToDisplay.length,
                          itemBuilder: (context, index) {
                            final coin = coinsToDisplay[index];
                            return _buildCoinCard(context, coin, provider);
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(CollectionProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search coins...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _applyFilters(provider);
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (value) => _applyFilters(provider),
      ),
    );
  }

  Widget _buildActiveFiltersChips(CollectionProvider provider) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          if (_selectedCountry != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Chip(
                label: Text('Country: $_selectedCountry'),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () {
                  setState(() => _selectedCountry = null);
                  _applyFilters(provider);
                },
              ),
            ),
          if (_selectedRarity != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Chip(
                label: Text('Rarity: $_selectedRarity'),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () {
                  setState(() => _selectedRarity = null);
                  _applyFilters(provider);
                },
              ),
            ),
          if (_showFavoritesOnly)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Chip(
                label: const Text('Favorites'),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () {
                  setState(() => _showFavoritesOnly = false);
                  _applyFilters(provider);
                },
              ),
            ),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _searchController.clear();
                _selectedCountry = null;
                _selectedRarity = null;
                _showFavoritesOnly = false;
              });
              _applyFilters(provider);
            },
            icon: const Icon(Icons.clear_all),
            label: const Text('Clear All'),
          ),
        ],
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
            Icon(Icons.monetization_on, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No Coins Yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start scanning coins to build your collection',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push('/scan'),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Scan Your First Coin'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No Results Found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or search query',
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

  Widget _buildCoinCard(
    BuildContext context,
    AnalysisResult coin,
    CollectionProvider provider,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to coin detail screen
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
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                      ],
                    ),
                    if (coin.tags.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        children: coin.tags.take(3).map((tag) {
                          return Chip(
                            label: Text(tag),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            labelStyle: const TextStyle(fontSize: 10),
                            visualDensity: VisualDensity.compact,
                          );
                        }).toList(),
                      ),
                    ],
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
                  PopupMenuButton<String>(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'wishlist',
                        child: Row(
                          children: [
                            Icon(Icons.bookmark_border),
                            SizedBox(width: 8),
                            Text('Add to Wishlist'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) async {
                      switch (value) {
                        case 'wishlist':
                          if (coin.id != null) {
                            await provider.toggleWishlist(coin.id!);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Moved to wishlist')),
                              );
                            }
                          }
                          break;
                        case 'edit':
                          // TODO: Open edit dialog
                          break;
                        case 'delete':
                          _showDeleteDialog(coin, provider);
                          break;
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

  void _showFiltersDialog() {
    final provider = context.read<CollectionProvider>();
    final countries = provider.getCountries();
    final rarities = ['Common', 'Uncommon', 'Rare', 'Very Rare', 'Extremely Rare'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Collection'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Country:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCountry,
                decoration: const InputDecoration(
                  hintText: 'Select country',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All Countries')),
                  ...countries.map((country) {
                    return DropdownMenuItem(value: country, child: Text(country));
                  }).toList(),
                ],
                onChanged: (value) {
                  setState(() => _selectedCountry = value);
                },
              ),
              const SizedBox(height: 16),
              const Text('Rarity:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedRarity,
                decoration: const InputDecoration(
                  hintText: 'Select rarity',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All Rarities')),
                  ...rarities.map((rarity) {
                    return DropdownMenuItem(value: rarity, child: Text(rarity));
                  }).toList(),
                ],
                onChanged: (value) {
                  setState(() => _selectedRarity = value);
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _applyFilters(provider);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(AnalysisResult coin, CollectionProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Coin?'),
        content: Text('Are you sure you want to delete "${coin.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              if (coin.id != null) {
                await provider.deleteCoin(coin.id!);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Coin deleted')),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
