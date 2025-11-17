import 'package:flutter/material.dart';
import 'package:acs/theme/app_theme.dart';
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
      {'code': 'ar', 'country': '', 'flag': '🇸🇦'},
      {'code': 'cs', 'country': '', 'flag': '🇨🇿'},
      {'code': 'da', 'country': '', 'flag': '🇩🇰'},
      {'code': 'de', 'country': '', 'flag': '🇩🇪'},
      {'code': 'el', 'country': '', 'flag': '🇬🇷'},
      {'code': 'en', 'country': '', 'flag': '🇺🇸'},
      {'code': 'es', 'country': 'ES', 'flag': '🇪🇸'},
      {'code': 'es', 'country': '419', 'flag': '🇲🇽'},
      {'code': 'fi', 'country': '', 'flag': '🇫🇮'},
      {'code': 'fr', 'country': '', 'flag': '🇫🇷'},
      {'code': 'hi', 'country': '', 'flag': '🇮🇳'},
      {'code': 'hu', 'country': '', 'flag': '🇭🇺'},
      {'code': 'id', 'country': '', 'flag': '🇮🇩'},
      {'code': 'it', 'country': '', 'flag': '🇮🇹'},
      {'code': 'ja', 'country': '', 'flag': '🇯🇵'},
      {'code': 'ko', 'country': '', 'flag': '🇰🇷'},
      {'code': 'nl', 'country': '', 'flag': '🇳🇱'},
      {'code': 'no', 'country': '', 'flag': '🇳🇴'},
      {'code': 'pl', 'country': '', 'flag': '🇵🇱'},
      {'code': 'pt', 'country': 'BR', 'flag': '🇧🇷'},
      {'code': 'pt', 'country': 'PT', 'flag': '🇵🇹'},
      {'code': 'ro', 'country': '', 'flag': '🇷🇴'},
      {'code': 'ru', 'country': '', 'flag': '🇷🇺'},
      {'code': 'sv', 'country': '', 'flag': '🇸🇪'},
      {'code': 'th', 'country': '', 'flag': '🇹🇭'},
      {'code': 'tr', 'country': '', 'flag': '🇹🇷'},
      {'code': 'uk', 'country': '', 'flag': '🇺🇦'},
      {'code': 'vi', 'country': '', 'flag': '🇻🇳'},
      {'code': 'zh', 'country': 'CN', 'flag': '🇨🇳'},
      {'code': 'zh', 'country': 'TW', 'flag': '🇹🇼'},
    ];

    final List<Map<String, String>> sortedLanguages = [];
    final currentLanguageCode = currentLocale.languageCode;
    final currentCountryCode = currentLocale.countryCode ?? '';

    // Add current language first
    final currentLanguage = allLanguages.firstWhere(
      (lang) => lang['code'] == currentLanguageCode && lang['country'] == currentCountryCode,
      orElse: () => allLanguages.firstWhere(
        (lang) => lang['code'] == currentLanguageCode,
        orElse: () => allLanguages.first,
      ),
    );
    sortedLanguages.add(currentLanguage);

    // Add the rest of the languages (excluding the current one)
    for (final lang in allLanguages) {
      if (!(lang['code'] == currentLanguageCode && lang['country'] == currentCountryCode)) {
        sortedLanguages.add(lang);
      }
    }

    return sortedLanguages;
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // Create staggered animations for language cards
    // With 31 elements (30 languages + 1 button), each starting at 0.04 intervals
    _animations = List.generate(31, (index) {
      final startTime = index * 0.04; // 24ms delay between elements
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

    String getLanguageName(String code, String country) {
      // Native language names (hardcoded for consistency across all locales)
      String baseName;
      switch (code) {
        case 'ar':
          baseName = 'العربية';
          break;
        case 'cs':
          baseName = 'Čeština';
          break;
        case 'da':
          baseName = 'Dansk';
          break;
        case 'de':
          baseName = 'Deutsch';
          break;
        case 'el':
          baseName = 'Ελληνικά';
          break;
        case 'en':
          baseName = 'English';
          break;
        case 'es':
          baseName = 'Español';
          break;
        case 'fi':
          baseName = 'Suomi';
          break;
        case 'fr':
          baseName = 'Français';
          break;
        case 'hi':
          baseName = 'हिन्दी';
          break;
        case 'hu':
          baseName = 'Magyar';
          break;
        case 'id':
          baseName = 'Bahasa Indonesia';
          break;
        case 'it':
          baseName = 'Italiano';
          break;
        case 'ja':
          baseName = '日本語';
          break;
        case 'ko':
          baseName = '한국어';
          break;
        case 'nl':
          baseName = 'Nederlands';
          break;
        case 'no':
          baseName = 'Norsk';
          break;
        case 'pl':
          baseName = 'Polski';
          break;
        case 'pt':
          baseName = 'Português';
          break;
        case 'ro':
          baseName = 'Română';
          break;
        case 'ru':
          baseName = 'Русский';
          break;
        case 'sv':
          baseName = 'Svenska';
          break;
        case 'th':
          baseName = 'ไทย';
          break;
        case 'tr':
          baseName = 'Türkçe';
          break;
        case 'uk':
          baseName = 'Українська';
          break;
        case 'vi':
          baseName = 'Tiếng Việt';
          break;
        case 'zh':
          baseName = '中文';
          break;
        default:
          baseName = code.toUpperCase();
      }

      // Add regional suffix if needed (hardcoded for consistency)
      if (country.isNotEmpty) {
        switch (country) {
          case 'ES':
            return '$baseName (España)';
          case '419':
            return '$baseName (Latinoamérica)';
          case 'BR':
            return '$baseName (Brasil)';
          case 'PT':
            return '$baseName (Portugal)';
          case 'CN':
            return '$baseName (简体)'; // Simplified
          case 'TW':
            return '$baseName (繁體)'; // Traditional
        }
      }

      return baseName;
    }

    String getSaveButtonText() {
      // Get the 'save' text in the language of the selected locale
      if (_selectedLocale == null) {
        return l10n.save;
      }

      final selectedLanguageCode = _selectedLocale!.languageCode;
      switch (selectedLanguageCode) {
        case 'ar':
          return 'حفظ';
        case 'cs':
          return 'Uložit';
        case 'da':
          return 'Gem';
        case 'de':
          return 'Speichern';
        case 'el':
          return 'Αποθήκευση';
        case 'en':
          return 'Save';
        case 'es':
          return 'Guardar';
        case 'fi':
          return 'Tallenna';
        case 'fr':
          return 'Enregistrer';
        case 'hi':
          return 'सहेजें';
        case 'hu':
          return 'Mentés';
        case 'id':
          return 'Simpan';
        case 'it':
          return 'Salva';
        case 'ja':
          return '保存';
        case 'ko':
          return '저장';
        case 'nl':
          return 'Opslaan';
        case 'no':
          return 'Lagre';
        case 'pl':
          return 'Zapisz';
        case 'pt':
          return 'Guardar';
        case 'ro':
          return 'Salvează';
        case 'ru':
          return 'Сохранить';
        case 'sv':
          return 'Spara';
        case 'th':
          return 'บันทึก';
        case 'tr':
          return 'Kaydet';
        case 'uk':
          return 'Зберегти';
        case 'vi':
          return 'Lưu';
        case 'zh':
          return '保存';
        default:
          return l10n.save;
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
                              final locale = Locale(lang['code']!, lang['country']!.isEmpty ? null : lang['country']!);
                              final isSelected =
                                  currentLocale.languageCode == locale.languageCode &&
                                  (currentLocale.countryCode ?? '') == (locale.countryCode ?? '');

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
                                                      lang['country']!,
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
                                  getSaveButtonText(),
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
