import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:acs/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/dialogue.dart';
import '../providers/theme_provider_v2.dart';
import '../services/local_data_service.dart';
import '../widgets/bottom_navigation_wrapper.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/scaffold_with_drawer.dart';
import '../l10n/app_localizations.dart';
import '../theme/theme_extensions_v2.dart';
import '../widgets/animated/animated_card.dart';
import '../constants/app_dimensions.dart';
import '../widgets/common/app_spacer.dart';

enum DialogStep { initial, enjoying, feedback }

class DialogueListScreen extends StatefulWidget {
  const DialogueListScreen({super.key});

  @override
  State<DialogueListScreen> createState() => _DialogueListScreenState();
}

class _DialogueListScreenState extends State<DialogueListScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late Future<List<Dialogue>> _dialoguesFuture;
  bool _isInitialized = false;
  StreamSubscription? _dialogueSubscription;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Инициализируем контроллер анимации
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _loadDialogues();
    _isInitialized = true;

    // Подписываемся на изменения в диалогах
    _dialogueSubscription = LocalDataService.dialogueChanges.listen((_) {
      if (mounted) {
        _loadDialogues();
      }
    });

    // Запускаем анимацию после построения
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _dialogueSubscription?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Обновляем данные при каждом изменении зависимостей
    _loadDialogues();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isInitialized) {
      // Обновляем данные, когда приложение возвращается на передний план
      _loadDialogues();
    }
  }

  void _loadDialogues() {
    setState(() {
      _dialoguesFuture = LocalDataService.instance.getAllDialogues().then(
        (dialogues) => dialogues.map((d) => Dialogue.fromMap(d)).toList(),
      );
    });
  }

  void _startNewChat() {
    context.push('/chat');
  }

  void _openChat(int dialogueId) {
    debugPrint(
      '=== DIALOGUE LIST DEBUG: Opening chat with dialogueId: $dialogueId ===',
    );
    context.push('/chat/$dialogueId');
  }

  Future<void> _deleteDialogue(int dialogueId) async {
    // Сохраняем локализацию до асинхронной операции
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteChat),
        content: Text(l10n.deleteChatConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              l10n.delete,
              style: TextStyle(color: context.colors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await LocalDataService.instance.deleteDialogue(dialogueId);
      if (mounted) {
        _loadDialogues();
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  Widget _buildDialogueCard(
    Dialogue dialogue,
    AppLocalizations l10n,
    int index,
  ) {
    final hasScanImage =
        dialogue.scanImagePath != null && dialogue.scanImagePath!.isNotEmpty;

    // Create animation for this card
    final cardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.1, // 100ms delay between cards
          (index * 0.1) + 0.5, // 500ms duration for each animation
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    return AnimatedBuilder(
      animation: cardAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: cardAnimation,
          child: SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(
                      index * 0.1,
                      (index * 0.1) + 0.5,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                ),
            child: _buildCard(dialogue, l10n, hasScanImage),
          ),
        );
      },
    );
  }

  Widget _buildCard(
    Dialogue dialogue,
    AppLocalizations l10n,
    bool hasScanImage,
  ) {
    return AnimatedCard(
      elevation: 0,
      margin: EdgeInsets.only(bottom: AppDimensions.space12),
      onTap: () => _openChat(dialogue.id),
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radius24),
          boxShadow: [AppTheme.shadow],
        ),
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.space16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail image or AI icon
              if (hasScanImage)
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radius12),
                  child: Image.file(
                    File(dialogue.scanImagePath!),
                    width: AppDimensions.space64,
                    height: AppDimensions.space64,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildDefaultIcon();
                    },
                  ),
                )
              else
                _buildDefaultIcon(),
              AppSpacer.h12(),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: FutureBuilder<String?>(
                            future: LocalDataService.instance
                                .getLastUserMessageForDialogue(dialogue.id),
                            builder: (context, snapshot) {
                              String displayText = dialogue.title;
                              if (snapshot.hasData &&
                                  snapshot.data != null &&
                                  snapshot.data!.isNotEmpty) {
                                displayText = snapshot.data!.length > 50
                                    ? '${snapshot.data!.substring(0, 50)}...'
                                    : snapshot.data!;
                              }
                              return Text(
                                displayText,
                                style: AppTheme.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: context.colors.onBackground,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              );
                            },
                          ),
                        ),
                        AppSpacer.h8(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _formatDate(dialogue.createdAt),
                              style: AppTheme.caption.copyWith(
                                color: context.colors.onSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            AppSpacer.v4(),
                            InkWell(
                              onTap: () => _deleteDialogue(dialogue.id),
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radius24,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(AppDimensions.space4),
                                child: Icon(
                                  Icons.delete_outline,
                                  size:
                                      AppDimensions.iconSmall +
                                      AppDimensions.space4,
                                  color: context.colors.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultIcon() {
    return Container(
      width: AppDimensions.space64,
      height: AppDimensions.space64,
      decoration: BoxDecoration(
        color: context.colors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
      ),
      child: Icon(
        Icons.chat_bubble_outline,
        color: context.colors.primary,
        size: AppDimensions.iconMedium + AppDimensions.space4,
      ),
    );
  }

  void _handleBackNavigation() {
    debugPrint('=== DIALOGUE LIST DEBUG: Back navigation triggered ===');
    // При нажатии кнопки "назад" возвращаемся на главную
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Watch theme changes to trigger rebuild
    context.watch<ThemeProviderV2>();

    return PopScope(
      canPop: false, // Запрещаем стандартное поведение кнопки "назад"
      onPopInvokedWithResult: (didPop, result) {
        debugPrint(
          '=== DIALOGUE LIST DEBUG: PopScope onPopInvokedWithResult called ===',
        );
        debugPrint('=== DIALOGUE LIST DEBUG: didPop: $didPop ===');

        if (didPop) return;

        _handleBackNavigation();
      },
      child: BottomNavigationWrapper(
        currentIndex: 2,
        child: ScaffoldWithDrawer(
          appBar: CustomAppBar(title: l10n.aiChats, showBackButton: true),
          body: FutureBuilder<List<Dialogue>>(
            future: _dialoguesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${l10n.serverError} ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    '${l10n.noDialoguesYet}\n${l10n.startANewChat}',
                    textAlign: TextAlign.center,
                  ),
                );
              }

              final dialogues = snapshot.data!;
              return ListView.builder(
                padding: EdgeInsets.all(AppDimensions.space16),
                itemCount: dialogues.length,
                itemBuilder: (context, index) {
                  final dialogue = dialogues[index];
                  return _buildDialogueCard(dialogue, l10n, index);
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _startNewChat,
            backgroundColor: context.colors.primary,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
