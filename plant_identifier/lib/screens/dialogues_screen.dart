import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/dialogue.dart';
import '../models/chat_message.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';
import '../theme/theme_extensions.dart';
import '../constants/app_dimensions.dart';
import '../providers/theme_provider.dart';

class DialoguesScreen extends StatefulWidget {
  const DialoguesScreen({super.key});

  @override
  State<DialoguesScreen> createState() => _DialoguesScreenState();
}

class _DialoguesScreenState extends State<DialoguesScreen>
    with TickerProviderStateMixin {
  late Future<List<Dialogue>> _dialoguesFuture;
  final DatabaseService _databaseService = DatabaseService();
  late AnimationController _animationController;
  final Map<int, String?> _firstMessagesCache = {};

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _loadDialogues();

    // Start animation after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadDialogues() {
    setState(() {
      _dialoguesFuture = _databaseService.getAllDialogues();
    });
  }

  Future<void> _refreshDialogues() async {
    _firstMessagesCache.clear();
    _loadDialogues();
  }

  void _startNewChat() {
    context.push('/chat');
  }

  void _openChat(int dialogueId) {
    debugPrint('Opening chat with dialogueId: $dialogueId');
    context.push(
      '/chat',
      extra: {
        'dialogueId': dialogueId,
      },
    );
  }

  Future<void> _deleteDialogue(int dialogueId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Chat'),
        content: const Text(
          'Are you sure you want to delete this chat? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Delete',
              style: TextStyle(color: context.colors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _databaseService.deleteDialogue(dialogueId);
      _firstMessagesCache.remove(dialogueId);
      if (mounted) {
        _loadDialogues();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chat deleted')),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dialogueDate = DateTime(date.year, date.month, date.day);

    if (dialogueDate == today) {
      return 'Today';
    } else if (dialogueDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
    }
  }

  Future<String?> _getFirstMessage(int dialogueId) async {
    if (_firstMessagesCache.containsKey(dialogueId)) {
      return _firstMessagesCache[dialogueId];
    }

    try {
      final messages = await _databaseService.getMessagesForDialogue(dialogueId);
      if (messages.isNotEmpty) {
        // Find first user message
        final firstUserMessage = messages.firstWhere(
          (msg) => msg.isUser,
          orElse: () => messages.first,
        );
        _firstMessagesCache[dialogueId] = firstUserMessage.text;
        return firstUserMessage.text;
      }
    } catch (e) {
      debugPrint('Error getting first message: $e');
    }
    return null;
  }

  Widget _buildDialogueCard(
    Dialogue dialogue,
    int index,
  ) {
    final hasPlantImage = dialogue.plantImagePath != null &&
        dialogue.plantImagePath!.isNotEmpty;

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
            position: Tween<Offset>(
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
            child: _buildCard(dialogue, hasPlantImage),
          ),
        );
      },
    );
  }

  Widget _buildCard(
    Dialogue dialogue,
    bool hasPlantImage,
  ) {
    return Dismissible(
      key: Key('dialogue_${dialogue.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppDimensions.space16),
        margin: const EdgeInsets.only(bottom: AppDimensions.space12),
        decoration: BoxDecoration(
          color: context.colors.error,
          borderRadius: BorderRadius.circular(AppDimensions.radius24),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: AppDimensions.iconLarge,
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Chat'),
            content: const Text(
              'Are you sure you want to delete this chat?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Delete',
                  style: TextStyle(color: context.colors.error),
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        _databaseService.deleteDialogue(dialogue.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chat deleted')),
        );
      },
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: AppDimensions.space12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius24),
        ),
        child: InkWell(
          onTap: () => _openChat(dialogue.id),
          borderRadius: BorderRadius.circular(AppDimensions.radius24),
          child: Container(
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radius24),
              boxShadow: [AppTheme.softShadow],
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.space16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail image or default icon
                  if (hasPlantImage)
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radius12),
                      child: Image.file(
                        File(dialogue.plantImagePath!),
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
                  const SizedBox(width: AppDimensions.space12),
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
                                future: _getFirstMessage(dialogue.id),
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
                            const SizedBox(width: AppDimensions.space8),
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
                                const SizedBox(height: AppDimensions.space4),
                                InkWell(
                                  onTap: () => _deleteDialogue(dialogue.id),
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.radius24,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                      AppDimensions.space4,
                                    ),
                                    child: Icon(
                                      Icons.delete_outline,
                                      size: AppDimensions.iconSmall +
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

  @override
  Widget build(BuildContext context) {
    // Watch theme changes to trigger rebuild
    context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Chat History',
          style: TextStyle(
            fontFamily: AppTheme.fontFamilySerif,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/'),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshDialogues,
        child: FutureBuilder<List<Dialogue>>(
          future: _dialoguesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: context.colors.primary,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: context.colors.error,
                    ),
                    const SizedBox(height: AppDimensions.space16),
                    Text(
                      'Error loading chats',
                      style: AppTheme.h4.copyWith(
                        color: context.colors.onBackground,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space8),
                    Text(
                      snapshot.error.toString(),
                      style: AppTheme.bodySmall.copyWith(
                        color: context.colors.onSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 80,
                      color: context.colors.primary.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: AppDimensions.space24),
                    Text(
                      'No chats yet',
                      style: AppTheme.h3.copyWith(
                        color: context.colors.onBackground,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.space8),
                    Text(
                      'Start a new chat with the AI assistant',
                      style: AppTheme.body.copyWith(
                        color: context.colors.onSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            final dialogues = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(AppDimensions.space16),
              itemCount: dialogues.length,
              itemBuilder: (context, index) {
                final dialogue = dialogues[index];
                return _buildDialogueCard(dialogue, index);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startNewChat,
        backgroundColor: context.colors.primaryDark,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
