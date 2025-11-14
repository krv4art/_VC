import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class _PollWidgetState extends State<PollWidget>
    with SingleTickerProviderStateMixin {
  final PollService _pollService = PollService();
  late AnimationController _animationController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _rotationAnimation;
  Timer? _animationTimer;
  bool _shouldAnimate = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkPollStatus();
  }

  void _initializeAnimations() {
    // Animation controller for shake + rotation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Shake animation (subtle horizontal movement)
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -2.0), weight: 25),
      TweenSequenceItem(tween: Tween(begin: -2.0, end: 2.0), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 2.0, end: -2.0), weight: 25),
      TweenSequenceItem(tween: Tween(begin: -2.0, end: 0.0), weight: 25),
    ]).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Rotation animation (subtle tilt)
    _rotationAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.1), weight: 25),
      TweenSequenceItem(tween: Tween(begin: -0.1, end: 0.1), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.1, end: -0.1), weight: 25),
      TweenSequenceItem(tween: Tween(begin: -0.1, end: 0.0), weight: 25),
    ]).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Start periodic animation (once every 7 seconds)
    _startPeriodicAnimation();
  }

  void _startPeriodicAnimation() {
    if (!_shouldAnimate) return;

    _animationTimer = Timer.periodic(const Duration(seconds: 7), (timer) {
      if (mounted && _shouldAnimate) {
        _animationController.forward(from: 0.0);
      }
    });
  }

  Future<void> _checkPollStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasVoted = prefs.getBool('poll_has_voted') ?? false;

      if (mounted) {
        setState(() {
          _shouldAnimate = !hasVoted;
          if (!_shouldAnimate) {
            _animationTimer?.cancel();
            _animationController.stop();
          }
        });
      }
    } catch (e) {
      debugPrint('Error checking poll status: $e');
    }
  }

  Future<void> _markPollCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('poll_has_voted', true);
      if (mounted) {
        setState(() {
          _shouldAnimate = false;
          _animationTimer?.cancel();
          _animationController.stop();
        });
      }
    } catch (e) {
      debugPrint('Error marking poll as completed: $e');
    }
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _openPollSheet(PollFilter? selectedFilter) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => PollBottomSheet(
        pollService: _pollService,
        initialFilter: selectedFilter,
        onPollCompleted: _markPollCompleted,
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
                // Poll icon with animation
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(_shakeAnimation.value, 0),
                      child: Transform.rotate(
                        angle: _rotationAnimation.value,
                        child: Container(
                          padding: EdgeInsets.all(AppDimensions.space12),
                          decoration: BoxDecoration(
                            color: context.colors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppDimensions.radius12),
                          ),
                          child: Icon(
                            Icons.campaign,
                            size: AppDimensions.iconLarge,
                            color: context.colors.primary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                AppSpacer.h12(),
                // Title only
                Expanded(
                  child: Text(
                    l10n.pollCardTitle,
                    style: AppTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.colors.onBackground,
                    ),
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
            color: context.colors.cardBackground,
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
  final VoidCallback? onPollCompleted;

  const PollBottomSheet({
    super.key,
    required this.pollService,
    this.initialFilter,
    this.onPollCompleted,
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
    _currentFilter = widget.initialFilter ?? PollFilter.topVoted;
    // Загружаем данные после построения виджета, когда контекст доступен
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPollData();
    });
  }

  @override
  void dispose() {
    _customOptionController.dispose();
    super.dispose();
  }

  Future<void> _loadPollData() async {
    debugPrint('=== POLL WIDGET: Loading poll data ===');
    setState(() => _isLoading = true);

    try {
      _currentLanguage = Localizations.localeOf(context).languageCode;
      debugPrint('=== POLL WIDGET: Current language: $_currentLanguage ===');

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
    debugPrint('=== POLL WIDGET: Applying filter: $_currentFilter ===');
    debugPrint('=== POLL WIDGET: Total options before filter: ${_options.length} ===');
    debugPrint('=== POLL WIDGET: Total user votes: ${_userVotes.length} ===');

    List<PollOption> filtered = List.from(_options);

    switch (_currentFilter) {
      case PollFilter.newest:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        debugPrint('=== POLL WIDGET: Sorted by newest ===');
        break;
      case PollFilter.topVoted:
        filtered.sort((a, b) => b.voteCount.compareTo(a.voteCount));
        debugPrint('=== POLL WIDGET: Sorted by top voted ===');
        break;
      case PollFilter.myOption:
        // Фильтр "Мой выбор" - показывает варианты, за которые пользователь проголосовал
        final beforeCount = filtered.length;
        final votedOptionIds = _userVotes.map((vote) => vote.optionId).toSet();
        filtered = filtered.where((option) => votedOptionIds.contains(option.id)).toList();
        debugPrint('=== POLL WIDGET: Filtered voted options: ${filtered.length} of $beforeCount ===');
        debugPrint('=== POLL WIDGET: Voted option IDs: $votedOptionIds ===');
        break;
    }

    debugPrint('=== POLL WIDGET: Filtered options count: ${filtered.length} ===');

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
    debugPrint('=== POLL WIDGET: Toggle vote for option: $optionId ===');

    // Check if already voted for this option
    final alreadyVoted = _userVotes.any((vote) => vote.optionId == optionId);
    if (alreadyVoted) {
      debugPrint('=== POLL WIDGET: Unvoting for option: $optionId ===');
      _unvoteForOption(optionId);
      return;
    }

    // Add to pending and immediately submit
    setState(() {
      _pendingVotes.add(optionId);
      debugPrint('=== POLL WIDGET: Added to pending votes. Total: ${_pendingVotes.length} ===');
    });

    // Automatically submit the vote
    _submitSingleVote(optionId);
  }

  Future<void> _unvoteForOption(String optionId) async {
    setState(() => _isSubmitting = true);

    try {
      final success = await widget.pollService.unvote(optionId);
      if (success) {
        await _loadPollData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Vote removed'),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      } else {
        _showErrorSnackBar('Failed to remove vote');
      }
    } catch (e) {
      debugPrint('Error removing vote: $e');
      _showErrorSnackBar('Failed to remove vote');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  Future<void> _submitSingleVote(String optionId) async {
    debugPrint('=== POLL WIDGET: Submitting single vote for: $optionId ===');

    try {
      final success = await widget.pollService.vote(optionId);
      debugPrint('=== POLL WIDGET: Vote result: $success ===');

      setState(() {
        _pendingVotes.remove(optionId);
      });

      if (success) {
        await _loadPollData();

        // Mark poll as completed (stop animation)
        widget.onPollCompleted?.call();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Vote submitted!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 1),
            ),
          );
        }
      } else {
        _showErrorSnackBar('Failed to submit vote');
      }
    } catch (e) {
      debugPrint('=== POLL WIDGET: Error submitting vote: $e ===');
      setState(() {
        _pendingVotes.remove(optionId);
      });
      _showErrorSnackBar('Failed to submit vote');
    }
  }

  Future<void> _submitVotes() async {
    debugPrint('=== POLL WIDGET: Submit votes called. Pending: ${_pendingVotes.length} ===');
    if (_pendingVotes.isEmpty) {
      debugPrint('=== POLL WIDGET: No pending votes to submit ===');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Submit all votes in batch
      bool allSuccessful = true;
      debugPrint('=== POLL WIDGET: Starting to submit ${_pendingVotes.length} votes ===');
      for (final optionId in _pendingVotes) {
        debugPrint('=== POLL WIDGET: Submitting vote for option: $optionId ===');
        final success = await widget.pollService.vote(optionId);
        debugPrint('=== POLL WIDGET: Vote result for $optionId: $success ===');
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

        // Mark poll as completed (stop animation)
        widget.onPollCompleted?.call();

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

    // Обновляем текущий язык перед добавлением опции
    final currentLanguage = Localizations.localeOf(context).languageCode;

    // Добавляем вариант опроса
    final optionId = await widget.pollService.addCustomOption(text, currentLanguage);
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

    // Mark poll as completed (stop animation)
    widget.onPollCompleted?.call();

    // Запускаем асинхронный перевод на остальные языки (не блокируем UI)
    _triggerTranslation(optionId, text, currentLanguage);

    await _loadPollData();
  }

  /// Запускает перевод варианта опроса на остальные языки
  /// Это асинхронная операция, которая не блокирует UI
  void _triggerTranslation(String optionId, String text, String sourceLanguage) {
    final translationService = PollTranslationService();

    // Запускаем перевод в фоне
    translationService.translateAndSave(optionId, text, sourceLanguage).then(
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

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(AppDimensions.radius24),
        topRight: Radius.circular(AppDimensions.radius24),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: context.colors.background,
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
      ),
    );
  }

  void _showPollHelp(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius16),
        ),
        contentPadding: EdgeInsets.all(AppDimensions.space24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Developer avatar and name (like in chat)
            Row(
              children: [
                // Avatar placeholder (circular container with icon)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: context.colors.primary.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    color: context.colors.primary,
                    size: 24,
                  ),
                ),
                AppSpacer.h12(),
                Text(
                  l10n.developer,
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colors.onBackground,
                  ),
                ),
              ],
            ),
            AppSpacer.v16(),
            // Message text
            Container(
              padding: EdgeInsets.all(AppDimensions.space16),
              decoration: BoxDecoration(
                color: context.colors.cardBackground,
                borderRadius: BorderRadius.circular(AppDimensions.radius12),
              ),
              child: Text(
                l10n.pollHelpDescription,
                style: AppTheme.body.copyWith(
                  color: context.colors.onBackground,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: TextStyle(color: context.colors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(child: _buildFilterChip(l10n.filterNewest, PollFilter.newest)),
          AppSpacer.h8(),
          Expanded(child: _buildFilterChip(l10n.filterTopVoted, PollFilter.topVoted)),
          AppSpacer.h8(),
          Expanded(child: _buildFilterChip(l10n.filterMyOption, PollFilter.myOption)),
        ],
      ),
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

    return GestureDetector(
      onTap: () => _toggleVote(option.id),
      child: Container(
        margin: EdgeInsets.only(bottom: AppDimensions.space12),
        padding: EdgeInsets.all(AppDimensions.space12),
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
      height: 48,
      child: OutlinedButton(
        onPressed: () => setState(() => _showAddOption = true),
        style: OutlinedButton.styleFrom(
          foregroundColor: context.colors.primary,
          side: BorderSide(color: context.colors.primary),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radius12),
          ),
        ),
        child: Text(l10n.addYourOption),
      ),
    );
  }

  Widget _buildAddOptionForm(AppLocalizations l10n) {
    return TextField(
      controller: _customOptionController,
      enabled: !_isSubmitting,
      decoration: InputDecoration(
        hintText: l10n.enterYourOption,
        filled: true,
        fillColor: context.colors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius12),
          borderSide: BorderSide(color: context.colors.primary, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space12,
        ),
        // Cancel button (prefix icon)
        prefixIcon: IconButton(
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
            size: 20,
            color: _isSubmitting
                ? context.colors.onSecondary.withValues(alpha: 0.3)
                : context.colors.onSecondary,
          ),
        ),
        // Accept button (suffix icon)
        suffixIcon: IconButton(
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
                  size: 20,
                  color: context.colors.primary,
                ),
        ),
      ),
      maxLength: 100,
      buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
    );
  }

  Widget _buildVoteButton(AppLocalizations l10n) {
    return ElevatedButton.icon(
      onPressed: _isSubmitting ? null : _submitVotes,
      style: ElevatedButton.styleFrom(
        backgroundColor: context.colors.primary,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: AppDimensions.space16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius12),
        ),
        minimumSize: const Size(double.infinity, 0),
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
    );
  }
}
