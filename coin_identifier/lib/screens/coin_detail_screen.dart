import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../models/analysis_result.dart';
import '../providers/collection_provider.dart';

/// Detailed view of a coin with edit capabilities
class CoinDetailScreen extends StatefulWidget {
  final String coinId;

  const CoinDetailScreen({Key? key, required this.coinId}) : super(key: key);

  @override
  State<CoinDetailScreen> createState() => _CoinDetailScreenState();
}

class _CoinDetailScreenState extends State<CoinDetailScreen> {
  AnalysisResult? _coin;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCoin();
  }

  Future<void> _loadCoin() async {
    final provider = context.read<CollectionProvider>();
    // Find coin in collection
    final coins = await provider.loadCollection();
    setState(() {
      _coin = provider.collection.firstWhere(
        (c) => c.id == widget.coinId,
        orElse: () => provider.collection.first, // Fallback
      );
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_coin == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Coin Not Found')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('Coin not found'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_coin!.name),
        actions: [
          Consumer<CollectionProvider>(
            builder: (context, provider, _) {
              final isFavorite = _coin!.isFavorite;
              return IconButton(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                color: isFavorite ? Colors.red : null,
                tooltip: 'Toggle Favorite',
                onPressed: () async {
                  if (_coin!.id != null) {
                    await provider.toggleFavorite(_coin!.id!);
                    await _loadCoin(); // Reload
                  }
                },
              );
            },
          ),
          PopupMenuButton<String>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    const Icon(Icons.edit),
                    const SizedBox(width: 12),
                    const Text('Edit Details'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'wishlist',
                child: Row(
                  children: [
                    Icon(_coin!.isInWishlist
                        ? Icons.bookmark
                        : Icons.bookmark_border),
                    const SizedBox(width: 12),
                    Text(_coin!.isInWishlist
                        ? 'Remove from Wishlist'
                        : 'Add to Wishlist'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            onSelected: (value) async {
              switch (value) {
                case 'edit':
                  _showEditDialog();
                  break;
                case 'wishlist':
                  if (_coin!.id != null) {
                    await context
                        .read<CollectionProvider>()
                        .toggleWishlist(_coin!.id!);
                    await _loadCoin();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_coin!.isInWishlist
                              ? 'Added to wishlist'
                              : 'Removed from wishlist'),
                        ),
                      );
                    }
                  }
                  break;
                case 'delete':
                  _showDeleteDialog();
                  break;
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImageSection(),
            const SizedBox(height: 16),
            _buildBasicInfoCard(),
            const SizedBox(height: 16),
            _buildUserMetadataCard(),
            const SizedBox(height: 16),
            _buildRarityValueCard(),
            const SizedBox(height: 16),
            if (_coin!.materials.isNotEmpty) ...[
              _buildMaterialsCard(),
              const SizedBox(height: 16),
            ],
            _buildPhysicalCharacteristicsCard(),
            const SizedBox(height: 16),
            if (_coin!.historicalContext.isNotEmpty) ...[
              _buildHistoricalContextCard(),
              const SizedBox(height: 16),
            ],
            if (_coin!.mintErrors.isNotEmpty) ...[
              _buildMintErrorsCard(),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: _coin!.imagePath != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                _coin!.imagePath!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
              ),
            )
          : _buildPlaceholderImage(),
    );
  }

  Widget _buildPlaceholderImage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.monetization_on, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            'No Image',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(height: 24),
            _buildInfoRow('Name', _coin!.name),
            if (_coin!.country != null) _buildInfoRow('Country', _coin!.country!),
            if (_coin!.yearOfIssue != null)
              _buildInfoRow('Year', _coin!.yearOfIssue!),
            if (_coin!.denomination != null)
              _buildInfoRow('Denomination', _coin!.denomination!),
            if (_coin!.mintMark != null)
              _buildInfoRow('Mint Mark', _coin!.mintMark!),
            const SizedBox(height: 12),
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              _coin!.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: Colors.grey[700],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserMetadataCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFFD4AF37).withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Notes & Info',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: _showEditDialog,
                  tooltip: 'Edit',
                ),
              ],
            ),
            const Divider(height: 24),
            if (_coin!.tags.isNotEmpty) ...[
              Text(
                'Tags',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _coin!.tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
            ],
            if (_coin!.userNotes != null) ...[
              Text(
                'Notes',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  _coin!.userNotes!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                      ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (_coin!.purchasePrice != null ||
                _coin!.purchaseDate != null ||
                _coin!.location != null) ...[
              const Divider(height: 24),
              Text(
                'Purchase Information',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              if (_coin!.purchasePrice != null)
                _buildInfoRow(
                    'Purchase Price', '\$${_coin!.purchasePrice!.toStringAsFixed(2)}'),
              if (_coin!.purchaseDate != null)
                _buildInfoRow(
                  'Purchase Date',
                  '${_coin!.purchaseDate!.month}/${_coin!.purchaseDate!.day}/${_coin!.purchaseDate!.year}',
                ),
              if (_coin!.location != null)
                _buildInfoRow('Location', _coin!.location!),
            ],
            if (_coin!.addedAt != null) ...[
              const Divider(height: 24),
              _buildInfoRow(
                'Added to Collection',
                '${_coin!.addedAt!.month}/${_coin!.addedAt!.day}/${_coin!.addedAt!.year}',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRarityValueCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rarity & Value',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _coin!.rarityLevel,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _getRarityColor(_coin!.rarityScore),
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Score: ${_coin!.rarityScore}/10',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                if (_coin!.marketValue != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Market Value',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _coin!.marketValue!.getFormattedRange(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.science, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  'Materials',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const Divider(height: 24),
            ..._coin!.materials.map((material) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              material.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              material.description,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${material.percentage.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildPhysicalCharacteristicsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.straighten, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Physical Characteristics',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const Divider(height: 24),
            if (_coin!.weight != null)
              _buildInfoRow('Weight', '${_coin!.weight!.toStringAsFixed(2)} g'),
            if (_coin!.diameter != null)
              _buildInfoRow(
                  'Diameter', '${_coin!.diameter!.toStringAsFixed(2)} mm'),
            if (_coin!.edge != null) _buildInfoRow('Edge', _coin!.edge!),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoricalContextCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.history_edu, color: Colors.brown),
                const SizedBox(width: 8),
                Text(
                  'Historical Context',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const Divider(height: 24),
            Text(
              _coin!.historicalContext,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMintErrorsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.purple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.error, color: Colors.purple.shade700),
                const SizedBox(width: 8),
                Text(
                  'Mint Errors',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade900,
                      ),
                ),
              ],
            ),
            const Divider(height: 24),
            ..._coin!.mintErrors.map((error) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.purple.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        error.errorType,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(error.description),
                      const SizedBox(height: 8),
                      Text(
                        'Rarity Impact: ${error.rarityImpact}',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRarityColor(int score) {
    if (score >= 9) return Colors.purple.shade700;
    if (score >= 7) return Colors.orange.shade700;
    if (score >= 5) return Colors.amber.shade700;
    if (score >= 3) return Colors.blue.shade700;
    return Colors.grey.shade600;
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) => _EditCoinDialog(
        coin: _coin!,
        onSaved: () async {
          await _loadCoin();
        },
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Coin?'),
        content: Text('Are you sure you want to delete "${_coin!.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              if (_coin!.id != null) {
                await context.read<CollectionProvider>().deleteCoin(_coin!.id!);
                if (mounted) {
                  context.pop(); // Go back to collection
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

/// Edit dialog for coin metadata
class _EditCoinDialog extends StatefulWidget {
  final AnalysisResult coin;
  final VoidCallback onSaved;

  const _EditCoinDialog({required this.coin, required this.onSaved});

  @override
  State<_EditCoinDialog> createState() => _EditCoinDialogState();
}

class _EditCoinDialogState extends State<_EditCoinDialog> {
  late TextEditingController _notesController;
  late TextEditingController _purchasePriceController;
  late TextEditingController _locationController;
  late TextEditingController _tagController;

  late List<String> _tags;
  DateTime? _purchaseDate;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.coin.userNotes ?? '');
    _purchasePriceController = TextEditingController(
      text: widget.coin.purchasePrice?.toString() ?? '',
    );
    _locationController =
        TextEditingController(text: widget.coin.location ?? '');
    _tagController = TextEditingController();
    _tags = List.from(widget.coin.tags);
    _purchaseDate = widget.coin.purchaseDate;
  }

  @override
  void dispose() {
    _notesController.dispose();
    _purchasePriceController.dispose();
    _locationController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  Future<void> _selectPurchaseDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _purchaseDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _purchaseDate = date;
      });
    }
  }

  Future<void> _save() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final updatedCoin = widget.coin.copyWith(
        tags: _tags,
        userNotes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        purchasePrice: _purchasePriceController.text.trim().isEmpty
            ? null
            : double.tryParse(_purchasePriceController.text.trim()),
        purchaseDate: _purchaseDate,
        location: _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
      );

      await context.read<CollectionProvider>().updateCoin(updatedCoin);

      if (mounted) {
        Navigator.pop(context);
        widget.onSaved();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Coin updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating coin: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Coin Details'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tags
              Text(
                'Tags',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _tagController,
                      decoration: const InputDecoration(
                        hintText: 'Add tag...',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _addTag(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addTag,
                    color: const Color(0xFFD4AF37),
                  ),
                ],
              ),
              if (_tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: _tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      onDeleted: () => _removeTag(tag),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 16),

              // Notes
              Text(
                'Notes',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  hintText: 'Your notes...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Purchase info
              Text(
                'Purchase Information',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _purchasePriceController,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        prefixText: '\$ ',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _selectPurchaseDate,
                      icon: const Icon(Icons.calendar_today, size: 16),
                      label: Text(
                        _purchaseDate == null
                            ? 'Date'
                            : '${_purchaseDate!.month}/${_purchaseDate!.day}/${_purchaseDate!.year}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Storage Location',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          onPressed: _isSaving ? null : _save,
          icon: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : const Icon(Icons.save),
          label: Text(_isSaving ? 'Saving...' : 'Save'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD4AF37),
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
