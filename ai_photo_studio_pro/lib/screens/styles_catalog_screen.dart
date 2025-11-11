import 'package:flutter/material.dart';
import '../models/style_model.dart';
import '../services/local_photo_database_service.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

class StylesCatalogScreen extends StatefulWidget {
  final Function(StyleModel)? onStyleSelected;

  const StylesCatalogScreen({
    super.key,
    this.onStyleSelected,
  });

  @override
  State<StylesCatalogScreen> createState() => _StylesCatalogScreenState();
}

class _StylesCatalogScreenState extends State<StylesCatalogScreen> {
  final LocalPhotoDatabase _db = LocalPhotoDatabase();
  StyleCategory? _selectedCategory;
  List<StyleModel> _styles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStyles();
  }

  Future<void> _loadStyles() async {
    setState(() => _isLoading = true);

    try {
      final styles = _selectedCategory == null
          ? await _db.getAllStyles()
          : await _db.getStylesByCategory(_selectedCategory!);

      setState(() {
        _styles = styles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('Error loading styles: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.stylesCatalog),
      ),
      body: Column(
        children: [
          _buildCategoryFilter(context, l10n),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildStyleGrid(context, l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(BuildContext context, AppLocalizations l10n) {
    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.space16,
          vertical: AppTheme.space8,
        ),
        children: [
          _buildCategoryChip(context, l10n, null, l10n.allStyles),
          const SizedBox(width: AppTheme.space8),
          _buildCategoryChip(
            context,
            l10n,
            StyleCategory.professional,
            l10n.categoryProfessional,
          ),
          const SizedBox(width: AppTheme.space8),
          _buildCategoryChip(
            context,
            l10n,
            StyleCategory.casual,
            l10n.categoryCasual,
          ),
          const SizedBox(width: AppTheme.space8),
          _buildCategoryChip(
            context,
            l10n,
            StyleCategory.creative,
            l10n.categoryCreative,
          ),
          const SizedBox(width: AppTheme.space8),
          _buildCategoryChip(
            context,
            l10n,
            StyleCategory.formal,
            l10n.categoryFormal,
          ),
          const SizedBox(width: AppTheme.space8),
          _buildCategoryChip(
            context,
            l10n,
            StyleCategory.outdoor,
            l10n.categoryOutdoor,
          ),
          const SizedBox(width: AppTheme.space8),
          _buildCategoryChip(
            context,
            l10n,
            StyleCategory.studio,
            l10n.categoryStudio,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    AppLocalizations l10n,
    StyleCategory? category,
    String label,
  ) {
    final isSelected = _selectedCategory == category;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedCategory = selected ? category : null;
        });
        _loadStyles();
      },
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }

  Widget _buildStyleGrid(BuildContext context, AppLocalizations l10n) {
    if (_styles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.style_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: AppTheme.space16),
            Text(
              'No styles found',
              style: AppTheme.h4.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppTheme.space16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppTheme.space16,
        mainAxisSpacing: AppTheme.space16,
        childAspectRatio: 0.8,
      ),
      itemCount: _styles.length,
      itemBuilder: (context, index) {
        return _buildStyleCard(context, _styles[index], l10n);
      },
    );
  }

  Widget _buildStyleCard(
    BuildContext context,
    StyleModel style,
    AppLocalizations l10n,
  ) {
    final locale = Localizations.localeOf(context).languageCode;

    return GestureDetector(
      onTap: () => _onStyleTap(context, style),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Preview image
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                child: Stack(
                  children: [
                    // Placeholder (until we have actual preview images)
                    Center(
                      child: Icon(
                        Icons.photo_camera,
                        size: 48,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.3),
                      ),
                    ),

                    // Premium badge
                    if (style.isPremium)
                      Positioned(
                        top: AppTheme.space8,
                        right: AppTheme.space8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.space8,
                            vertical: AppTheme.space4,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                            ),
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusSmall,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                size: 12,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                'PRO',
                                style: AppTheme.caption.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Style info
            Padding(
              padding: const EdgeInsets.all(AppTheme.space12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    style.getLocalizedName(locale),
                    style: AppTheme.h4.copyWith(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppTheme.space4),
                  Text(
                    style.getLocalizedDescription(locale),
                    style: AppTheme.bodySmall.copyWith(fontSize: 11),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onStyleTap(BuildContext context, StyleModel style) {
    if (style.isPremium) {
      // TODO: Check subscription status
      // For now, just show upgrade dialog
      _showPremiumDialog(context, style);
    } else {
      if (widget.onStyleSelected != null) {
        widget.onStyleSelected!(style);
        Navigator.of(context).pop();
      }
    }
  }

  void _showPremiumDialog(BuildContext context, StyleModel style) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.premiumOnly),
        content: Text(l10n.premiumFeature),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to subscription screen
            },
            child: Text(l10n.upgradeNow),
          ),
        ],
      ),
    );
  }
}
