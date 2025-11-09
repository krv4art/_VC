import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../providers/ai_bot_provider.dart';
import '../widgets/bot_description_card.dart';
import '../widgets/animated/animated_button.dart' as btn;
import '../widgets/animated/animated_ai_avatar.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/scaffold_with_drawer.dart';
import '../l10n/app_localizations.dart';
import '../theme/theme_extensions_v2.dart';
import '../theme/app_theme.dart';
import '../constants/app_dimensions.dart';
import '../widgets/common/app_spacer.dart';

class AiBotSettingsScreen extends StatefulWidget {
  const AiBotSettingsScreen({super.key});

  @override
  State<AiBotSettingsScreen> createState() => _AiBotSettingsScreenState();
}

class _AiBotSettingsScreenState extends State<AiBotSettingsScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final TextEditingController _customPromptController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _customPromptFocusNode = FocusNode();
  bool _isCustomPromptEnabled = false;
  late AnimationController _animationController;
  late List<Animation<double>> _animations;
  AvatarAnimationState _avatarState = AvatarAnimationState.idle;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    WidgetsBinding.instance.addObserver(this);

    // Загружаем настройки при инициализации
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AiBotProvider>();
      final l10n = AppLocalizations.of(context)!;
      provider.loadSettings().then((_) {
        if (mounted) {
          setState(() {
            // Если customPrompt пустой, используем значение по умолчанию
            final prompt = provider.customPrompt.isEmpty
                ? l10n.defaultCustomPrompt
                : provider.customPrompt;
            _customPromptController.text = prompt;
            _isCustomPromptEnabled = provider.isCustomPromptEnabled;
          });
        }
      });
    });
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // Скроллим вниз при появлении клавиатуры, если поле ввода в фокусе
    if (_customPromptFocusNode.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _scrollController.hasClients) {
          _scrollController.jumpTo(
            _scrollController.position.maxScrollExtent,
          );
        }
      });
    }
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Create staggered animations for sections
    _animations = List.generate(5, (index) {
      final startTime = index * 0.1; // 100ms delay between elements
      final endTime = startTime + 0.4; // 400ms duration for each animation

      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            startTime,
            endTime.clamp(0.0, 1.0),
            curve: Curves.easeOutCubic,
          ),
        ),
      );
    });

    // Start animations after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _customPromptController.dispose();
    _scrollController.dispose();
    _customPromptFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onCustomPromptChanged(String value) {
    // Handle custom prompt change if needed
  }

  void _onCustomPromptEnabledChanged(bool value) {
    setState(() {
      _isCustomPromptEnabled = value;
    });
  }

  void _cycleAvatarAnimation() {
    setState(() {
      // Циклическое переключение между состояниями
      switch (_avatarState) {
        case AvatarAnimationState.idle:
          _avatarState = AvatarAnimationState.thinking;
          break;
        case AvatarAnimationState.thinking:
          _avatarState = AvatarAnimationState.speaking;
          break;
        case AvatarAnimationState.speaking:
          _avatarState = AvatarAnimationState.idle;
          break;
      }
    });
  }

  Future<void> _showEditNameDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.read<AiBotProvider>();
    final nameController = TextEditingController(text: provider.botName);

    return showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: context.colors.surface,
          title: Text(
            l10n.editName,
            style: TextStyle(color: context.colors.onBackground),
          ),
          content: TextField(
            controller: nameController,
            autofocus: true,
            style: TextStyle(color: context.colors.onBackground),
            decoration: InputDecoration(
              hintText: l10n.enterBotName,
              hintStyle: TextStyle(color: context.colors.onSecondary),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                l10n.cancel,
                style: TextStyle(color: context.colors.onBackground),
              ),
            ),
            TextButton(
              onPressed: () async {
                final newName = nameController.text.trim();
                if (newName.isNotEmpty) {
                  await provider.updateName(newName);
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                  }
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.settingsSaved),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: context.colors.primary,
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: AppTheme.fontFamilySerif,
                ),
              ),
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveSettings() async {
    final provider = context.read<AiBotProvider>();
    final l10n = AppLocalizations.of(context)!;

    try {
      // Сохраняем настройки дополнительного промпта
      await provider.updateCustomPrompt(
        _customPromptController.text,
        _isCustomPromptEnabled,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.settingsSaved),
          backgroundColor: Colors.green,
        ),
      );

      // Возвращаемся на предыдущий экран
      context.pop();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.failedToSaveSettings}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ScaffoldWithDrawer(
      backgroundColor: context.colors.background,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(title: l10n.aiBotSettings, showBackButton: true),
      body: SafeArea(
        child: Consumer<AiBotProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: AppDimensions.iconXLarge + AppDimensions.space16,
                      color: Colors.red[400],
                    ),
                    AppSpacer.v16(),
                    Text(
                      l10n.errorLoadingSettings,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    AppSpacer.v8(),
                    Text(
                      provider.error!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    AppSpacer.v24(),
                    btn.AnimatedButton(
                      onPressed: () => provider.loadSettings(),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              );
            }

            return AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return SingleChildScrollView(
                  controller: _scrollController,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.all(AppDimensions.space16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Анимация 0: Аватар и имя бота
                          FadeTransition(
                            opacity: _animations[0],
                            child: SlideTransition(
                              position:
                                  Tween<Offset>(
                                    begin: const Offset(0, 0.3),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: _animationController,
                                      curve: const Interval(
                                        0.0,
                                        0.4,
                                        curve: Curves.easeOutCubic,
                                      ),
                                    ),
                                  ),
                              child: Column(
                                children: [
                                  AppSpacer.v8(),

                                  // Анимированный аватар бота
                                  GestureDetector(
                                    onTap: _cycleAvatarAnimation,
                                    child: SizedBox(
                                      width: AppDimensions.avatarLarge * 2,
                                      height: AppDimensions.avatarLarge * 2,
                                      child: AnimatedAiAvatar(
                                        size: AppDimensions.avatarLarge * 2,
                                        state: _avatarState,
                                        colors: context.colors.currentColors,
                                      ),
                                    ),
                                  ),

                                  AppSpacer.v16(),

                                  // Имя бота с кнопкой редактирования
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        provider.botName,
                                        style: AppTheme.h2.copyWith(
                                          color: context.colors.onBackground,
                                        ),
                                      ),
                                      btn.AnimatedIconButton(
                                        icon: Icons.edit_outlined,
                                        iconSize: AppDimensions.iconSmall + 4.0,
                                        onPressed: _showEditNameDialog,
                                      ),
                                    ],
                                  ),

                                  AppSpacer.v24(),
                                ],
                              ),
                            ),
                          ),

                          // Анимация 1: Описание бота
                          FadeTransition(
                            opacity: _animations[1],
                            child: SlideTransition(
                              position:
                                  Tween<Offset>(
                                    begin: const Offset(0, 0.3),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: _animationController,
                                      curve: const Interval(
                                        0.1,
                                        0.5,
                                        curve: Curves.easeOutCubic,
                                      ),
                                    ),
                                  ),
                              child: const BotDescriptionCard(),
                            ),
                          ),

                          AppSpacer.v24(),

                          // Анимация 2: Настройка дополнительного промпта
                          FadeTransition(
                            opacity: _animations[2],
                            child: SlideTransition(
                              position:
                                  Tween<Offset>(
                                    begin: const Offset(0, 0.3),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: _animationController,
                                      curve: const Interval(
                                        0.2,
                                        0.6,
                                        curve: Curves.easeOutCubic,
                                      ),
                                    ),
                                  ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: context.colors.surface,
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.radius12,
                                  ),
                                  border: Border.all(
                                    color: context.colors.onSurface.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                padding: EdgeInsets.all(AppDimensions.space16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Заголовок и переключатель
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          l10n.customPrompt,
                                          style: AppTheme.h3.copyWith(
                                            color: context.colors.onBackground,
                                          ),
                                        ),
                                        Switch(
                                          value: _isCustomPromptEnabled,
                                          onChanged:
                                              _onCustomPromptEnabledChanged,
                                          activeColor: context.colors.primary,
                                        ),
                                      ],
                                    ),
                                    AppSpacer.v12(),

                                    // Описание функции
                                    Text(
                                      l10n.customPromptDescription,
                                      style: AppTheme.bodySmall.copyWith(
                                        color: context.colors.onSecondary,
                                      ),
                                    ),
                                    AppSpacer.v16(),

                                    // Поле ввода промпта
                                    TextField(
                                      controller: _customPromptController,
                                      focusNode: _customPromptFocusNode,
                                      enabled: _isCustomPromptEnabled,
                                      maxLines: 3,
                                      style: TextStyle(
                                        color: _isCustomPromptEnabled
                                            ? context.colors.onBackground
                                            : context.colors.onSecondary,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: l10n.customPromptPlaceholder,
                                        hintStyle: TextStyle(
                                          color: context.colors.onSecondary
                                              .withValues(alpha: 0.7),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions.space8,
                                          ),
                                          borderSide: BorderSide(
                                            color: context.colors.onSurface
                                                .withValues(alpha: 0.3),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions.space8,
                                          ),
                                          borderSide: BorderSide(
                                            color: context.colors.onSurface
                                                .withValues(alpha: 0.3),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions.space8,
                                          ),
                                          borderSide: BorderSide(
                                            color: _isCustomPromptEnabled
                                                ? context.colors.primary
                                                : context.colors.onSurface
                                                      .withValues(alpha: 0.3),
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: _isCustomPromptEnabled
                                            ? context.colors.background
                                            : context.colors.surface.withValues(
                                                alpha: 0.3,
                                              ),
                                      ),
                                      onChanged: _onCustomPromptChanged,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          AppSpacer.v24(),

                          // Анимация 4: Кнопка сохранения
                          FadeTransition(
                            opacity: _animations[4],
                            child: SlideTransition(
                              position:
                                  Tween<Offset>(
                                    begin: const Offset(0, 0.3),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: _animationController,
                                      curve: const Interval(
                                        0.4,
                                        0.8,
                                        curve: Curves.easeOutCubic,
                                      ),
                                    ),
                                  ),
                              child: SizedBox(
                                width: double.infinity,
                                height:
                                    AppDimensions.buttonLarge +
                                    AppDimensions.space4,
                                child: btn.AnimatedButton(
                                  buttonType: btn.ButtonType.elevated,
                                  animationStyle: btn.AnimationStyle.scale,
                                  backgroundColor: context.colors.primary,
                                  foregroundColor: context.colors.isDark
                                      ? const Color(
                                          0xFF1A1A1A,
                                        ) // Very dark gray for dark theme
                                      : Colors.white, // White for light theme
                                  borderRadius: BorderRadius.circular(
                                    AppTheme.radiusStandard,
                                  ),
                                  onPressed: _saveSettings,
                                  child: Text(
                                    l10n.save,
                                    style: AppTheme.buttonText.copyWith(
                                      color: context.colors.isDark
                                          ? const Color(
                                              0xFF1A1A1A,
                                            ) // Very dark gray for dark theme
                                          : Colors.white, // White for light theme
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          AppSpacer.v16(),
                        ],
                      ),
                    );
              },
            );
          },
        ),
      ),
    );
  }
}
