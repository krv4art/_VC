import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/scaffold_with_drawer.dart';
import '../theme/theme_extensions_v2.dart';
import '../widgets/animated/animated_card.dart';
import '../widgets/animated/animated_button.dart' as btn;
import '../constants/app_dimensions.dart';
import '../widgets/common/app_spacer.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen>
    with TickerProviderStateMixin {
  Locale? _selectedLocale;
  Locale? _originalLocale;
  bool _isSaved = false;
  late AnimationController _animationController;
  late List<Animation<double>> _animations;
  List<Map<String, String>> _displayLanguages = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final localeProvider = context.read<LocaleProvider>();
      final currentLocale =
          localeProvider.locale ?? Localizations.localeOf(context);

      setState(() {
        _originalLocale = currentLocale;
        _selectedLocale = _originalLocale;

        // Initialize and sort languages only once on page load
        _displayLanguages = _getSortedLanguages(currentLocale);
      });
    });
  }

  List<Map<String, String>> _getSortedLanguages(Locale currentLocale) {
    final List<Map<String, String>> allLanguages = [
      {'code': 'ar', 'flag': '🇸🇦'},
      {'code': 'cs', 'flag': '🇨🇿'},
      {'code': 'da', 'flag': '🇩🇰'},
      {'code': 'de', 'flag': '🇩🇪'},
      {'code': 'el', 'flag': '🇬🇷'},
      {'code': 'en', 'flag': '🇺🇸'},
      {'code': 'es', 'flag': '🇪🇸'},
      {'code': 'fi', 'flag': '🇫🇮'},
      {'code': 'fr', 'flag': '🇫🇷'},
      {'code': 'hi', 'flag': '🇮🇳'},
      {'code': 'hu', 'flag': '🇭🇺'},
      {'code': 'id', 'flag': '🇮🇩'},
      {'code': 'it', 'flag': '🇮🇹'},
      {'code': 'ja', 'flag': '🇯🇵'},
      {'code': 'ko', 'flag': '🇰🇷'},
      {'code': 'nl', 'flag': '🇳🇱'},
      {'code': 'no', 'flag': '🇳🇴'},
      {'code': 'pl', 'flag': '🇵🇱'},
      {'code': 'pt', 'flag': '🇧🇷'},
      {'code': 'ro', 'flag': '🇷🇴'},
      {'code': 'ru', 'flag': '🇷🇺'},
      {'code': 'sv', 'flag': '🇸🇪'},
      {'code': 'th', 'flag': '🇹🇭'},
      {'code': 'tr', 'flag': '🇹🇷'},
      {'code': 'uk', 'flag': '🇺🇦'},
      {'code': 'vi', 'flag': '🇻🇳'},
      {'code': 'zh', 'flag': '🇨🇳'},
    ];

    final List<Map<String, String>> sortedLanguages = [];
    final currentLanguageCode = currentLocale.languageCode;

    // Add current language first
    final currentLanguage = allLanguages.firstWhere(
      (lang) => lang['code'] == currentLanguageCode,
      orElse: () => allLanguages.first,
    );
    sortedLanguages.add(currentLanguage);

    // Add the rest of the languages (excluding the current one)
    for (final lang in allLanguages) {
      if (lang['code'] != currentLanguageCode) {
        sortedLanguages.add(lang);
      }
    }

    return sortedLanguages;
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Create staggered animations for language cards
    // With 28 elements (27 languages + 1 button), each starting at 0.03 intervals
    _animations = List.generate(28, (index) {
      final startTime = index * 0.03; // 36ms delay between elements
      final endTime = (startTime + 0.35).clamp(
        0.0,
        1.0,
      ); // 420ms duration for each animation

      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            startTime.clamp(0.0, 1.0),
            endTime,
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
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = context.watch<LocaleProvider>();
    final currentLocale =
        _selectedLocale ??
        (localeProvider.locale ?? Localizations.localeOf(context));

    String getLanguageName(String code) {
      switch (code) {
        case 'ar':
          return l10n.language_ar;
        case 'cs':
          return l10n.language_cs;
        case 'da':
          return l10n.language_da;
        case 'de':
          return l10n.language_de;
        case 'el':
          return l10n.language_el;
        case 'en':
          return l10n.language_en;
        case 'es':
          return l10n.language_es;
        case 'fi':
          return l10n.language_fi;
        case 'fr':
          return l10n.language_fr;
        case 'hi':
          return l10n.language_hi;
        case 'hu':
          return l10n.language_hu;
        case 'id':
          return l10n.language_id;
        case 'it':
          return l10n.language_it;
        case 'ja':
          return l10n.language_ja;
        case 'ko':
          return l10n.language_ko;
        case 'nl':
          return l10n.language_nl;
        case 'no':
          return l10n.language_no;
        case 'pl':
          return l10n.language_pl;
        case 'pt':
          return l10n.language_pt;
        case 'ro':
          return l10n.language_ro;
        case 'ru':
          return l10n.language_ru;
        case 'sv':
          return l10n.language_sv;
        case 'th':
          return l10n.language_th;
        case 'tr':
          return l10n.language_tr;
        case 'uk':
          return l10n.language_uk;
        case 'vi':
          return l10n.language_vi;
        case 'zh':
          return l10n.language_zh;
        default:
          return code;
      }
    }

    return ScaffoldWithDrawer(
      backgroundColor: context.colors.background,
      appBar: CustomAppBar(
        title: l10n.language,
        showBackButton: true,
        onBackPressed: () {
          if (!_isSaved && _originalLocale != null) {
            final localeProvider = Provider.of<LocaleProvider>(
              context,
              listen: false,
            );
            localeProvider.setLocale(_originalLocale!);
          }
          if (context.mounted && context.canPop()) {
            context.pop();
          }
        },
      ),
      body: SafeArea(
        child: _displayLanguages.isEmpty
            ? const SizedBox.shrink()
            : AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Stack(
                    children: [
                      // Весь скроллируемый контент с анимациями
                      SingleChildScrollView(
                        padding: EdgeInsets.only(
                          bottom: AppDimensions.space64 + AppDimensions.space16,
                          left: AppDimensions.space16,
                          right: AppDimensions.space16,
                          top: AppDimensions.space16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Анимация 0: Текст описания
                            FadeTransition(
                              opacity: _animations[0],
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.3),
                                  end: Offset.zero,
                                ).animate(_animations[0]),
                                child: Text(
                                  l10n.selectYourPreferredLanguage,
                                  style: AppTheme.body.copyWith(
                                    color: context.colors.onBackground,
                                  ),
                                ),
                              ),
                            ),
                            AppSpacer.v12(),

                            // Анимации 1-7: Карточки языков
                            ...List.generate(_displayLanguages.length, (index) {
                              final lang = _displayLanguages[index];
                              final locale = Locale(lang['code']!);
                              final isSelected =
                                  currentLocale.languageCode ==
                                  locale.languageCode;

                              return FadeTransition(
                                opacity: _animations[index + 1],
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.3),
                                    end: Offset.zero,
                                  ).animate(_animations[index + 1]),
                                  child: AnimatedCard(
                                    elevation: isSelected ? 4 : 2,
                                    margin: EdgeInsets.only(
                                      bottom: AppDimensions.space12,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.radius16,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedLocale = locale;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(
                                          AppDimensions.space16 +
                                              AppDimensions.space4,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: isSelected
                                              ? context.colors.primaryGradient
                                              : null,
                                          color: isSelected
                                              ? null
                                              : context.colors.surface,
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions.radius16,
                                          ),
                                          border: Border.all(
                                            color: isSelected
                                                ? context.colors.primary
                                                : context.colors.onBackground
                                                      .withValues(alpha: 0.2),
                                            width: isSelected ? 2 : 1,
                                          ),
                                          boxShadow: isSelected
                                              ? [
                                                  AppTheme.getColoredShadow(
                                                    context.colors.shadowColor,
                                                  ),
                                                ]
                                              : null,
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width:
                                                  AppDimensions.buttonLarge + 2,
                                              height:
                                                  AppDimensions.buttonLarge + 2,
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? Colors.white.withValues(
                                                        alpha: 0.2,
                                                      )
                                                    : context.colors.primary
                                                          .withValues(
                                                            alpha: 0.15,
                                                          ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      AppDimensions.radius12,
                                                    ),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                lang['flag']!,
                                                style: const TextStyle(
                                                  fontSize: 28,
                                                ),
                                              ),
                                            ),
                                            AppSpacer.h16(),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    getLanguageName(
                                                      lang['code']!,
                                                    ),
                                                    style: AppTheme.h4.copyWith(
                                                      color: isSelected
                                                          ? (context
                                                                    .colors
                                                                    .isDark
                                                                ? const Color(
                                                                    0xFF1A1A1A,
                                                                  ) // Very dark gray for dark theme
                                                                : Colors
                                                                      .white) // White for light theme
                                                          : context
                                                                .colors
                                                                .onBackground,
                                                    ),
                                                  ),
                                                  AppSpacer.v4(),
                                                  Text(
                                                    getLanguageName(
                                                      lang['code']!,
                                                    ),
                                                    style: AppTheme.bodySmall.copyWith(
                                                      color: isSelected
                                                          ? (context
                                                                    .colors
                                                                    .isDark
                                                                ? const Color(
                                                                        0xFF1A1A1A,
                                                                      ) // Very dark gray for dark theme
                                                                      .withValues(
                                                                        alpha:
                                                                            0.9,
                                                                      )
                                                                : Colors.white
                                                                      .withValues(
                                                                        alpha:
                                                                            0.9,
                                                                      ))
                                                          : context
                                                                .colors
                                                                .onBackground
                                                                .withValues(
                                                                  alpha: 0.8,
                                                                ),
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
                                ),
                              );
                            }),
                            AppSpacer.v16(),
                          ],
                        ),
                      ),

                      // Анимация 7: Плавающая кнопка
                      Positioned(
                        bottom: AppDimensions.space16,
                        left: AppDimensions.space16,
                        right: AppDimensions.space16,
                        child: FadeTransition(
                          opacity: _animations[_animations.length - 1],
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.3),
                              end: Offset.zero,
                            ).animate(_animations[_animations.length - 1]),
                            child: SizedBox(
                              height: AppDimensions.buttonLarge + 2,
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
                                  AppDimensions.radius12,
                                ),
                                onPressed: () {
                                  _isSaved = true;
                                  localeProvider.setLocale(
                                    _selectedLocale ??
                                        (localeProvider.locale ??
                                            Localizations.localeOf(context)),
                                  );
                                  if (!context.mounted) return;

                                  // Navigate back
                                  Future.delayed(
                                    const Duration(milliseconds: 150),
                                    () {
                                      if (!context.mounted) return;
                                      if (context.canPop()) {
                                        context.pop();
                                      }
                                    },
                                  );
                                },
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
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
