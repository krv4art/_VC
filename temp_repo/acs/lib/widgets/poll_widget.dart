import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/poll_service.dart';
import '../services/poll_translation_service.dart';
import '../models/poll_option.dart';
import '../models/poll_vote.dart';
import '../theme/app_theme.dart';
import '../theme/theme_extensions_v2.dart';
import '../constants/app_dimensions.dart';
import '../widgets/common/app_spacer.dart';

/// Фильтры для опроса
enum PollFilter {
  newest,
  topVoted,
  myOption,
}

/// Компактный виджет-карточка опроса для главного экрана
class PollWidget extends StatefulWidget {
  const PollWidget({super.key});

  @override
  State<PollWidget> createState() => _PollWidgetState();
}

class _PollWidgetState extends State<PollWidget> {
  final PollService _pollService = PollService();

  void _openPollSheet(PollFilter? selectedFilter) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PollBottomSheet(
        pollService: _pollService,
        initialFilter: selectedFilter,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => _openPollSheet(null),
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.cardBackground,
          borderRadius: BorderRadius.circular(AppDimensions.radius16),
          border: Border.all(
            color: context.colors.onSecondary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        padding: EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon and title row
            Row(
              children: [
                // Poll icon
                Container(
                  padding: EdgeInsets.all(AppDimensions.space12),
                  decoration: BoxDecoration(
                    color: context.colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radius12),
                  ),
                  child: Icon(
                    Icons.poll_outlined,
                    size: AppDimensions.iconLarge,
                    color: context.colors.primary,
                  ),
                ),
                AppSpacer.h12(),
                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.pollCardTitle,
                        style: AppTheme.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.colors.onBackground,
                        ),
                      ),
                      AppSpacer.v4(),
                      Text(
                        l10n.pollCardSubtitle,
                        style: AppTheme.bodySmall.copyWith(
                          color: context.colors.onSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppSpacer.v16(),
            // Filter chips
            Row(
              children: [
                _buildCompactFilterChip(
                  l10n.filterNewest,
                  PollFilter.newest,
                ),
                AppSpacer.h8(),
                _buildCompactFilterChip(
                  l10n.filterTopVoted,
                  PollFilter.topVoted,
                ),
                AppSpacer.h8(),
                _buildCompactFilterChip(
                  l10n.filterMyOption,
                  PollFilter.myOption,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactFilterChip(String label, PollFilter filter) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _openPollSheet(filter),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: AppDimensions.space8,
          ),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radius8),
            border: Border.all(
              color: context.colors.onSecondary.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTheme.bodySmall.copyWith(
              color: context.colors.onBackground,
            ),
          ),
        ),
      ),
    );
  }
}

/// BottomSheet для детального интерфейса опроса
class PollBottomSheet extends StatefulWidget {
  final PollService pollService;
  final PollFilter? initialFilter;

  const PollBottomSheet({
    super.key,
    required this.pollService,
    this.initialFilter,
  });

  @override
  State<PollBottomSheet> createState() => _PollBottomSheetState();
}

class _PollBottomSheetState extends State<PollBottomSheet> {
  final TextEditingController _customOptionController = TextEditingController();

  List<PollOption> _options = [];
  List<PollOption> _filteredOptions = [];
  List<PollVote> _userVotes = [];
  Set<String> _pendingVotes = {}; // Frontend vote accumulation
  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _showAddOption = false;
  PollFilter _currentFilter = PollFilter.newest;
  int _currentPage = 0;
  static const int _itemsPerPage = 5;
  String _currentLanguage = 'en';
  int _remainingVotes = 3;

  @override
  void initState() {
    super.initState();
    _currentFilter = widget.initialFilter ?? PollFilter.newest;
    _loadPollData();
  }

  @override
  void dispose() {
    _customOptionController.dispose();
    super.dispose();
  }

  Future<void> _loadPollData() async {
    setState(() => _isLoading = true);

    try {
      _currentLanguage = Localizations.localeOf(context).languageCode;

      // ОПТИМИЗАЦИЯ: Используем новый метод getPollData(), который делает 1 запрос вместо 3
      final pollData = await widget.pollService.getPollData(_currentLanguage);

      final options = pollData['options'] as List<PollOption>;
      final votes = pollData['votes'] as List<PollVote>;
      final remaining = pollData['remaining_votes'] as int;

      setState(() {
        _options = options;
        _userVotes = votes;
        _remainingVotes = remaining;
        _isLoading = false;
      });

      _applyFilter();
    } catch (e) {
      debugPrint('Error loading poll data: $e');
      setState(() => _isLoading = false);
      _showErrorSnackBar('Error loading poll data');
    }
  }

  void _applyFilter() {
    List<PollOption> filtered = List.from(_options);

    switch (_currentFilter) {
      case PollFilter.newest:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case PollFilter.topVoted:
        filtered.sort((a, b) => b.voteCount.compareTo(a.voteCount));
        break;
      case PollFilter.myOption:
        filtered = filtered.where((option) => option.isUserCreated).toList();
        break;
    }

    setState(() {
      _filteredOptions = filtered;
      _currentPage = 0;
    });
  }

  List<PollOption> _getPaginatedOptions() {
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, _filteredOptions.length);
    return _filteredOptions.sublist(startIndex, endIndex);
  }

  void _nextPage() {
    final totalPages = (_filteredOptions.length / _itemsPerPage).ceil();
    if (_currentPage < totalPages - 1) {
      setState(() => _currentPage++);
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
    }
  }

  void _toggleVote(String optionId) {
    setState(() {
      if (_pendingVotes.contains(optionId)) {
        _pendingVotes.remove(optionId);
      } else {
        _pendingVotes.add(optionId);
      }
    });
  }

  Future<void> _submitVotes() async {
    if (_pendingVotes.isEmpty) return;

    setState(() => _isSubmitting = true);

    try {
      // Submit all votes in batch
      bool allSuccessful = true;
      for (final optionId in _pendingVotes) {
        final success = await widget.pollService.vote(optionId);
        if (!success) {
          allSuccessful = false;
          break;
        }
      }

      if (allSuccessful) {
        setState(() {
          _pendingVotes.clear();
          _isSubmitting = false;
        });
        await _loadPollData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Votes submitted successfully!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        setState(() => _isSubmitting = false);
        _showErrorSnackBar('Failed to submit votes. Please try again.');
      }
    } catch (e) {
      debugPrint('Error submitting votes: $e');
      setState(() => _isSubmitting = false);
      _showErrorSnackBar('Failed to submit votes. Please try again.');
    }
  }

  Future<void> _addCustomOption() async {
    final text = _customOptionController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSubmitting = true);

    // Добавляем вариант опроса
    final optionId = await widget.pollService.addCustomOption(text, _currentLanguage);
    if (optionId == null) {
      setState(() => _isSubmitting = false);
      _showErrorSnackBar('Failed to add custom option. Please try again.');
      return;
    }

    _customOptionController.clear();
    setState(() {
      _showAddOption = false;
      _isSubmitting = false;
    });

    // Запускаем асинхронный перевод на остальные языки (не блокируем UI)
    _triggerTranslation(optionId, text);

    await _loadPollData();
  }

  /// Запускает перевод варианта опроса на остальные языки
  /// Это асинхронная операция, которая не блокирует UI
  void _triggerTranslation(String optionId, String text) {
    final translationService = PollTranslationService();

    // Запускаем перевод в фоне
    translationService.translateAndSave(optionId, text, _currentLanguage).then(
      (success) {
        if (success) {
          debugPrint('=== POLL WIDGET: Translation completed for option $optionId ===');
          // Перезагружаем данные опроса, чтобы показать новые переводы
          _loadPollData();
        } else {
          debugPrint('=== POLL WIDGET: Translation failed for option $optionId ===');
          // Переводы не удались, но вариант уже добавлен на исходном языке
        }
      },
      onError: (error) {
        debugPrint('=== POLL WIDGET: Translation error: $error ===');
      },
    );
  }

  bool _isVotedFor(String optionId) {
    return _userVotes.any((vote) => vote.optionId == optionId) ||
           _pendingVotes.contains(optionId);
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radius24),
          topRight: Radius.circular(AppDimensions.radius24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: AppDimensions.space12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.colors.onSecondary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          AppSpacer.v16(),
          // Help icon
          GestureDetector(
            onTap: () => _showPollHelp(context, l10n),
            child: Icon(
              Icons.help_outline,
              color: context.colors.primary,
              size: AppDimensions.iconMedium,
            ),
          ),
          AppSpacer.v16(),
          // Filters
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.space16),
            child: _buildFilters(l10n),
          ),
          AppSpacer.v16(),
          // Poll options list
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: context.colors.primary,
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppDimensions.space16),
                      child: Column(
                        children: [
                          // Poll options with swipe support
                          GestureDetector(
                            onHorizontalDragEnd: (details) {
                              if (details.primaryVelocity != null) {
                                if (details.primaryVelocity! < 0) {
                                  _nextPage();
                                } else if (details.primaryVelocity! > 0) {
                                  _previousPage();
                                }
                              }
                            },
                            child: Column(
                              children: _getPaginatedOptions()
                                  .map((option) => _buildOptionItem(option, l10n))
                                  .toList(),
                            ),
                          ),
                          // Suggest improvement section
                          AppSpacer.v16(),
                          if (_showAddOption)
                            _buildAddOptionForm(l10n)
                          else if (_pendingVotes.isEmpty)
                            _buildAddOptionButton(l10n),
                          // Pagination
                          if (_filteredOptions.length > _itemsPerPage) ...[
                            AppSpacer.v16(),
                            _buildPagination(),
                          ],
                          // Vote button (appears when options selected)
                          if (_pendingVotes.isNotEmpty) ...[
                            AppSpacer.v16(),
                            _buildVoteButton(l10n),
                          ],
                          AppSpacer.v32(),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _showPollHelp(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          l10n.pollHelpTitle,
          style: AppTheme.h3.copyWith(
            color: context.colors.onBackground,
          ),
        ),
        content: Text(
          l10n.pollHelpDescription,
          style: AppTheme.body.copyWith(
            color: context.colors.onBackground,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(child: _buildFilterChip(l10n.filterNewest, PollFilter.newest)),
        AppSpacer.h8(),
        Expanded(child: _buildFilterChip(l10n.filterTopVoted, PollFilter.topVoted)),
        AppSpacer.h8(),
        Expanded(child: _buildFilterChip(l10n.filterMyOption, PollFilter.myOption)),
      ],
    );
  }

  Widget _buildFilterChip(String label, PollFilter filter) {
    final isSelected = _currentFilter == filter;
    return GestureDetector(
      onTap: () {
        setState(() => _currentFilter = filter);
        _applyFilter();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppDimensions.space8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colors.primary
              : context.colors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radius8),
          border: Border.all(
            color: isSelected
                ? context.colors.primary
                : context.colors.onSecondary.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTheme.bodySmall.copyWith(
            color: isSelected
                ? Colors.white
                : context.colors.onBackground,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildOptionItem(PollOption option, AppLocalizations l10n) {
    final isVoted = _isVotedFor(option.id);

    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.space12),
      decoration: BoxDecoration(
        color: isVoted
            ? context.colors.primary.withValues(alpha: 0.1)
            : context.colors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        border: Border.all(
          color: isVoted
              ? context.colors.primary
              : context.colors.onSecondary.withValues(alpha: 0.2),
          width: isVoted ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _toggleVote(option.id),
          borderRadius: BorderRadius.circular(AppDimensions.radius12),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.space12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    option.text,
                    style: AppTheme.bodySmall.copyWith(
                      color: context.colors.onBackground,
                      fontWeight: isVoted ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
                AppSpacer.h12(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.space8,
                    vertical: AppDimensions.space4,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.onSecondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radius8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        size: 12,
                        color: context.colors.onSecondary,
                      ),
                      AppSpacer.h4(),
                      Text(
                        '${option.voteCount}',
                        style: AppTheme.caption.copyWith(
                          color: context.colors.onSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPagination() {
    final totalPages = (_filteredOptions.length / _itemsPerPage).ceil();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: _currentPage > 0
              ? () => setState(() => _currentPage--)
              : null,
          icon: Icon(
            Icons.arrow_back_ios,
            size: AppDimensions.iconSmall,
            color: _currentPage > 0
                ? context.colors.onBackground
                : context.colors.onSecondary.withValues(alpha: 0.3),
          ),
        ),
        Text(
          '${_currentPage + 1} / $totalPages',
          style: AppTheme.body.copyWith(
            color: context.colors.onBackground,
          ),
        ),
        IconButton(
          onPressed: _currentPage < totalPages - 1
              ? () => setState(() => _currentPage++)
              : null,
          icon: Icon(
            Icons.arrow_forward_ios,
            size: AppDimensions.iconSmall,
            color: _currentPage < totalPages - 1
                ? context.colors.onBackground
                : context.colors.onSecondary.withValues(alpha: 0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildAddOptionButton(AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => setState(() => _showAddOption = true),
        style: OutlinedButton.styleFrom(
          foregroundColor: context.colors.primary,
          side: BorderSide(color: context.colors.primary),
          padding: EdgeInsets.symmetric(vertical: AppDimensions.space12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radius12),
          ),
        ),
        child: Text(l10n.addYourOption),
      ),
    );
  }

  Widget _buildAddOptionForm(AppLocalizations l10n) {
    return Row(
      children: [
        // Cancel button
        IconButton(
          onPressed: _isSubmitting
              ? null
              : () {
                  setState(() {
                    _showAddOption = false;
                    _customOptionController.clear();
                  });
                },
          icon: Icon(
            Icons.close,
            color: _isSubmitting
                ? context.colors.onSecondary.withValues(alpha: 0.3)
                : context.colors.onSecondary,
          ),
        ),
        // TextField
        Expanded(
          child: TextField(
            controller: _customOptionController,
            enabled: !_isSubmitting,
            decoration: InputDecoration(
              hintText: l10n.enterYourOption,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radius8),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppDimensions.space12,
                vertical: AppDimensions.space8,
              ),
            ),
            maxLength: 100,
          ),
        ),
        // Accept button
        IconButton(
          onPressed: _isSubmitting ? null : _addCustomOption,
          icon: _isSubmitting
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: context.colors.primary,
                  ),
                )
              : Icon(
                  Icons.check,
                  color: context.colors.primary,
                ),
        ),
      ],
    );
  }

  Widget _buildVoteButton(AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isSubmitting ? null : _submitVotes,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colors.primary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: AppDimensions.space16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radius12),
          ),
        ),
        icon: _isSubmitting
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Icon(Icons.how_to_vote, size: AppDimensions.iconMedium),
        label: Text(
          _isSubmitting ? l10n.submitting : l10n.submitVote,
          style: AppTheme.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
