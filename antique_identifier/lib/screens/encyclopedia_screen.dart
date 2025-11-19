import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../services/encyclopedia_service.dart';
import '../models/encyclopedia_entry.dart';

/// Экран энциклопедии антиквариата
class EncyclopediaScreen extends StatefulWidget {
  const EncyclopediaScreen({Key? key}) : super(key: key);

  @override
  State<EncyclopediaScreen> createState() => _EncyclopediaScreenState();
}

class _EncyclopediaScreenState extends State<EncyclopediaScreen> {
  final EncyclopediaService _service = EncyclopediaService();
  List<EncyclopediaEntry> _entries = [];
  List<EncyclopediaEntry> _filteredEntries = [];
  String _selectedCategory = 'all';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadEntries() {
    setState(() {
      _entries = _service.getAllEntries();
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<EncyclopediaEntry> filtered = _entries;

    // Фильтр по категории
    if (_selectedCategory != 'all') {
      filtered = filtered.where((e) => e.category == _selectedCategory).toList();
    }

    // Поиск
    if (_searchQuery.isNotEmpty) {
      filtered = _service.search(_searchQuery);
      if (_selectedCategory != 'all') {
        filtered = filtered.where((e) => e.category == _selectedCategory).toList();
      }
    }

    setState(() {
      _filteredEntries = filtered;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
      _applyFilters();
    });
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'style':
        return Icons.palette;
      case 'period':
        return Icons.history;
      case 'term':
        return Icons.book;
      case 'technique':
        return Icons.handyman;
      case 'material':
        return Icons.category;
      default:
        return Icons.article;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'style':
        return Colors.purple;
      case 'period':
        return Colors.blue;
      case 'term':
        return Colors.green;
      case 'technique':
        return Colors.orange;
      case 'material':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encyclopedia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About Encyclopedia'),
                  content: const Text(
                    'This encyclopedia contains comprehensive information about antique styles, '
                    'periods, terms, techniques, and materials. Use it to learn more about '
                    'the fascinating world of antiques and collectibles.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Поиск
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search encyclopedia...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
          ),

          // Фильтр по категориям
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildCategoryChip('all', 'All', Icons.grid_view, Colors.grey),
                ..._service.getCategories().map(
                      (cat) => _buildCategoryChip(
                        cat,
                        _service.getCategoryName(cat),
                        _getCategoryIcon(cat),
                        _getCategoryColor(cat),
                      ),
                    ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Счетчик результатов
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${_filteredEntries.length} ${_filteredEntries.length == 1 ? 'entry' : 'entries'}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Список записей
          Expanded(
            child: _filteredEntries.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No entries found',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search or filters',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade500,
                              ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredEntries.length,
                    itemBuilder: (context, index) {
                      final entry = _filteredEntries[index];
                      return _buildEntryCard(entry);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String value, String label, IconData icon, Color color) {
    final isSelected = _selectedCategory == value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        selected: isSelected,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : color),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
        onSelected: (selected) {
          _onCategoryChanged(value);
        },
        selectedColor: color,
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildEntryCard(EncyclopediaEntry entry) {
    final categoryColor = _getCategoryColor(entry.category);
    final categoryIcon = _getCategoryIcon(entry.category);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          context.push('/encyclopedia/${entry.id}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок и категория
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber.shade900,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(categoryIcon, size: 14, color: categoryColor),
                            const SizedBox(width: 4),
                            Text(
                              _service.getCategoryName(entry.category),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: categoryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            if (entry.period != null) ...[
                              const SizedBox(width: 8),
                              const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                entry.period!,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey.shade600,
                                    ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Определение
              Text(
                entry.definition,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              // Related terms (если есть)
              if (entry.relatedTerms.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: entry.relatedTerms.take(3).map((term) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        term,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade700,
                            ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Детальный экран записи энциклопедии
class EncyclopediaDetailScreen extends StatelessWidget {
  final String entryId;

  const EncyclopediaDetailScreen({
    Key? key,
    required this.entryId,
  }) : super(key: key);

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'style':
        return Icons.palette;
      case 'period':
        return Icons.history;
      case 'term':
        return Icons.book;
      case 'technique':
        return Icons.handyman;
      case 'material':
        return Icons.category;
      default:
        return Icons.article;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'style':
        return Colors.purple;
      case 'period':
        return Colors.blue;
      case 'term':
        return Colors.green;
      case 'technique':
        return Colors.orange;
      case 'material':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  void _shareEntry(BuildContext context, EncyclopediaEntry entry) {
    // Create text to copy to clipboard
    final text = '''
${entry.title}

${entry.definition}

${entry.detailedDescription ?? ''}

Category: ${EncyclopediaService().getCategoryName(entry.category)}
${entry.period != null ? 'Period: ${entry.period}' : ''}

Learn more in Antique Identifier app.
''';

    // Copy to clipboard
    final data = ClipboardData(text: text);
    Clipboard.setData(data);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Copied to clipboard!'),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = EncyclopediaService();
    final entry = service.getById(entryId);

    if (entry == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Encyclopedia')),
        body: const Center(child: Text('Entry not found')),
      );
    }

    final categoryColor = _getCategoryColor(entry.category);
    final categoryIcon = _getCategoryIcon(entry.category);

    return Scaffold(
      appBar: AppBar(
        title: Text(entry.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareEntry(context, entry),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Категория и период
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: categoryColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(categoryIcon, size: 16, color: categoryColor),
                      const SizedBox(width: 6),
                      Text(
                        service.getCategoryName(entry.category),
                        style: TextStyle(
                          color: categoryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (entry.period != null) ...[
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          entry.period!,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 24),

            // Определение
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lightbulb, color: Colors.amber.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.definition,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                    ),
                  ),
                ],
              ),
            ),

            if (entry.detailedDescription != null) ...[
              const SizedBox(height: 24),
              Text(
                'Detailed Description',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                entry.detailedDescription!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                    ),
              ),
            ],

            if (entry.examples.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                'Examples',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              ...entry.examples.map(
                (example) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle, size: 20, color: Colors.green.shade600),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          example,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            if (entry.relatedTerms.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                'Related Terms',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: entry.relatedTerms.map((term) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      term,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade800,
                          ),
                    ),
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
