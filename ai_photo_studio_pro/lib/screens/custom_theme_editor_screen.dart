import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/theme_extensions_v2.dart';
import '../theme/custom_colors.dart';
import '../models/custom_theme_data.dart';
import '../providers/theme_provider_v2.dart';
import '../widgets/theme_editor/wysiwyg_color_preview.dart';
import '../widgets/theme_editor/quick_color_edit_dialog.dart';
import '../l10n/app_localizations.dart';
import '../constants/app_dimensions.dart';
import '../widgets/common/app_spacer.dart';

/// Экран создания/редактирования кастомной темы
class CustomThemeEditorScreen extends StatefulWidget {
  /// ID темы для редактирования (null для создания новой)
  final String? themeId;

  const CustomThemeEditorScreen({super.key, this.themeId});

  @override
  State<CustomThemeEditorScreen> createState() =>
      _CustomThemeEditorScreenState();
}

class _CustomThemeEditorScreenState extends State<CustomThemeEditorScreen> {
  late TextEditingController _nameController;
  late CustomColors _editingColors;
  late bool _isDark;
  AppThemeType? _baseTheme;
  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _initializeEditor();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// Инициализация редактора
  void _initializeEditor() {
    final themeProvider = Provider.of<ThemeProviderV2>(context, listen: false);

    if (widget.themeId != null) {
      // Редактирование существующей темы
      final existingTheme = themeProvider.customThemes.firstWhere(
        (t) => t.id == widget.themeId,
        orElse: () => throw Exception('Theme not found'),
      );
      _nameController = TextEditingController(text: existingTheme.name);
      _editingColors = existingTheme.colors;
      _isDark = existingTheme.isDark;
      // Определяем базовую тему из basedOn или используем текущую
      _baseTheme = existingTheme.basedOn != null
          ? _parseThemeType(existingTheme.basedOn!)
          : themeProvider.currentTheme;
    } else {
      // Создание новой темы - базовая тема не выбрана
      _nameController = TextEditingController(text: 'My Custom Theme');
      _editingColors = CustomColors.fromAppColors(themeProvider.currentColors);
      _isDark = themeProvider.isDarkTheme;
      _baseTheme = null; // Пользователь должен выбрать базовую тему
    }
  }

  /// Парсинг строки в AppThemeType
  AppThemeType _parseThemeType(String themeString) {
    try {
      return AppThemeType.values.firstWhere(
        (t) => t.name.toLowerCase() == themeString.toLowerCase(),
      );
    } catch (e) {
      return AppThemeType.natural;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: _editingColors.background,
      body: Stack(
        children: [
          Column(
            children: [
              // Fake AppBar (no border radius)
              _buildFakeAppBar(context),

              // Theme Name and Based On fields
              _buildTopControls(l10n),

              // Main WYSIWYG Preview (scrollable content)
              Expanded(
                child: WysiwygColorPreview(
                  colors: _editingColors,
                  onColorsChanged: (newColors) {
                    setState(() {
                      _editingColors = newColors;
                      _markAsChanged();
                    });
                    // Применяем изменения к интерфейсу
                    final themeProvider = Provider.of<ThemeProviderV2>(
                      context,
                      listen: false,
                    );
                    themeProvider.setTheme(themeProvider.currentTheme);
                  },
                ),
              ),

              // Fake NavBar (no border radius)
              _buildFakeNavBar(context),
            ],
          ),

          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  /// Fake AppBar (кликабельный для редактирования цветов)
  Widget _buildFakeAppBar(BuildContext context) {
    final appBarColor = _editingColors.brightness == Brightness.dark
        ? _editingColors.surface
        : _editingColors.primaryDark;

    return GestureDetector(
      onTap: () {
        // Клик на фон AppBar
        _showColorEditor(
          context,
          _editingColors.brightness == Brightness.dark
              ? 'Surface'
              : 'Primary Dark',
          _editingColors.brightness == Brightness.dark
              ? 'AppBar background in dark mode'
              : 'AppBar background in light mode',
          appBarColor,
          (color) {
            setState(() {
              _editingColors = _editingColors.brightness == Brightness.dark
                  ? _editingColors.copyWith(surface: color)
                  : _editingColors.copyWith(primaryDark: color);
              _markAsChanged();
            });
          },
        );
      },
      child: Container(
        color: appBarColor,
        padding: EdgeInsets.only(
          top:
              MediaQuery.of(context).padding.top +
              AppDimensions
                  .space12, // Добавляем дополнительный отступ сверху (увеличили с 8 до 10)
          left: AppDimensions.space16,
          right: AppDimensions.space16,
          bottom: AppDimensions.space12, // Возвращаем исходный отступ снизу
        ),
        child: Stack(
          children: [
            // Кнопка "назад" слева
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () => _handleBack(),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: AppDimensions.iconMedium,
                ),
              ),
            ),
            // Название по центру
            Center(
              child: Text(
                'Theme Editor',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppDimensions.space16 + AppDimensions.space4,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Кнопка смены режима справа
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () => _handleModeChange(!_isDark),
                child: Icon(
                  _isDark ? Icons.light_mode : Icons.dark_mode,
                  color: Colors.white,
                  size: AppDimensions.iconMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Top controls (Theme Name and Based On)
  Widget _buildTopControls(AppLocalizations l10n) {
    return Container(
      color: _editingColors.background,
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space12,
      ),
      child: Column(
        children: [
          // Theme Name
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Theme name',
              filled: true,
              fillColor: _editingColors.surface,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppDimensions.space12,
                vertical: AppDimensions.space12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radius12),
                borderSide: BorderSide(
                  color: _editingColors.onSurface.withValues(alpha: 0.2),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radius12),
                borderSide: BorderSide(
                  color: _editingColors.onSurface.withValues(alpha: 0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radius12),
                borderSide: BorderSide(
                  color: _editingColors.primary,
                  width: AppDimensions.space4 / 2,
                ),
              ),
            ),
            style: TextStyle(color: _editingColors.onSurface),
            onChanged: (_) => _markAsChanged(),
          ),
          AppSpacer.v12(),

          // Based On + Reset
          Row(
            children: [
              Expanded(child: _buildBasedOnDropdown(l10n)),
              AppSpacer.h8(),
              IconButton(
                onPressed: _handleResetToBaseTheme,
                icon: Icon(Icons.refresh, color: _editingColors.onSurface),
                tooltip: l10n.resetToBaseTheme,
              ),
              IconButton(
                onPressed: _handleSave,
                icon: Icon(Icons.save, color: _editingColors.primary),
                tooltip: l10n.save,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Fake NavBar (кликабельный для редактирования цветов)
  Widget _buildFakeNavBar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Клик на фон NavBar
        _showColorEditor(
          context,
          'Surface',
          'Navigation Bar background',
          _editingColors.surface,
          (color) {
            setState(() {
              _editingColors = _editingColors.copyWith(surface: color);
              _markAsChanged();
            });
          },
        );
      },
      child: Container(
        color: _editingColors.surface,
        padding: EdgeInsets.only(
          bottom:
              MediaQuery.of(context).padding.bottom +
              AppDimensions.space8, // Добавляем дополнительный отступ снизу
          top: AppDimensions.space12 + AppDimensions.space4,
        ),
        child: SizedBox(
          height: AppDimensions.buttonLarge + AppDimensions.space8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Активная иконка
              GestureDetector(
                onTap: () {
                  _showColorEditor(
                    context,
                    'Primary',
                    'Active icon color in navigation',
                    _editingColors.primary,
                    (color) {
                      setState(() {
                        _editingColors = _editingColors.copyWith(
                          primary: color,
                        );
                        _markAsChanged();
                      });
                    },
                  );
                },
                child: Icon(
                  Icons.home,
                  color: _editingColors.primary,
                  size: AppDimensions.iconLarge,
                ),
              ),
              // Неактивные иконки
              GestureDetector(
                onTap: () {
                  _showColorEditor(
                    context,
                    'On Surface',
                    'Inactive icon color',
                    _editingColors.onSurface,
                    (color) {
                      setState(() {
                        _editingColors = _editingColors.copyWith(
                          onSurface: color,
                        );
                        _markAsChanged();
                      });
                    },
                  );
                },
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: _editingColors.onSurface.withValues(alpha: 0.5),
                  size: AppDimensions.iconLarge,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showColorEditor(
                    context,
                    'On Surface',
                    'Inactive icon color',
                    _editingColors.onSurface,
                    (color) {
                      setState(() {
                        _editingColors = _editingColors.copyWith(
                          onSurface: color,
                        );
                        _markAsChanged();
                      });
                    },
                  );
                },
                child: Icon(
                  Icons.chat_bubble_outline,
                  color: _editingColors.onSurface.withValues(alpha: 0.5),
                  size: AppDimensions.iconLarge,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showColorEditor(
                    context,
                    'On Surface',
                    'Inactive icon color',
                    _editingColors.onSurface,
                    (color) {
                      setState(() {
                        _editingColors = _editingColors.copyWith(
                          onSurface: color,
                        );
                        _markAsChanged();
                      });
                    },
                  );
                },
                child: Icon(
                  Icons.person_outline,
                  color: _editingColors.onSurface.withValues(alpha: 0.5),
                  size: AppDimensions.iconLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Показать редактор цвета
  void _showColorEditor(
    BuildContext context,
    String colorName,
    String description,
    Color currentColor,
    Function(Color) onColorChanged,
  ) {
    showDialog(
      context: context,
      builder: (context) => QuickColorEditDialog(
        colorName: colorName,
        colorDescription: description,
        currentColor: currentColor,
        onColorChanged: onColorChanged,
      ),
    );
  }

  /// Based on dropdown (extracted for reuse)
  Widget _buildBasedOnDropdown(AppLocalizations l10n) {
    final List<AppThemeType> availableThemes = AppThemeType.values
        .where(
          (theme) =>
              !theme.name.startsWith('dark') && theme != AppThemeType.dark,
        )
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: _editingColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        border: Border.all(
          color: _editingColors.onSurface.withValues(alpha: 0.2),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<AppThemeType>(
          value: _baseTheme,
          hint: Text(
            l10n.basedOn,
            style: TextStyle(
              color: _editingColors.onSurface.withValues(alpha: 0.5),
            ),
          ),
          isExpanded: true,
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.space12,
            vertical: AppDimensions.space8,
          ),
          dropdownColor: _editingColors.surface,
          style: TextStyle(color: _editingColors.onSurface),
          items: availableThemes.map((theme) {
            return DropdownMenuItem<AppThemeType>(
              value: theme,
              child: Text(_getThemeDisplayName(theme, l10n)),
            );
          }).toList(),
          onChanged: (AppThemeType? newTheme) {
            if (newTheme != null) {
              final themeProvider = Provider.of<ThemeProviderV2>(
                context,
                listen: false,
              );

              AppThemeType targetTheme = newTheme;
              if (_isDark) {
                targetTheme = _getDarkVariant(newTheme);
              }

              themeProvider.setTheme(targetTheme);

              setState(() {
                _baseTheme = newTheme;
                _editingColors = CustomColors.fromAppColors(
                  themeProvider.currentColors,
                );
                _markAsChanged();
              });
            }
          },
        ),
      ),
    );
  }

  /// Секция с названием темы и переключателем режима

  /// Группа цветов с заголовком

  /// Создать ColorPickerTile

  /// Обновить цвет

  /// Отметить что были изменения
  void _markAsChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  /// Сохранить тему
  Future<void> _handleSave() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      _showError('Please enter a theme name');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final themeProvider = Provider.of<ThemeProviderV2>(
        context,
        listen: false,
      );

      CustomThemeData theme;

      if (widget.themeId != null) {
        // Обновление существующей темы
        final existing = themeProvider.customThemes.firstWhere(
          (t) => t.id == widget.themeId,
        );
        theme = existing.copyWith(
          name: name,
          colors: _editingColors,
          isDark: _isDark,
          basedOn: _baseTheme?.name,
        );
        await themeProvider.updateCustomTheme(theme);
      } else {
        // Создание новой темы
        theme = CustomThemeData.create(
          name: name,
          colors: _editingColors,
          isDark: _isDark,
          basedOn: _baseTheme?.name,
        );

        final canAdd = await themeProvider.canAddMoreThemes();
        if (!canAdd) {
          _showError('Maximum of 10 custom themes reached');
          setState(() {
            _isLoading = false;
          });
          return;
        }

        await themeProvider.addCustomTheme(theme);
      }

      // Применить созданную/обновленную тему
      await themeProvider.setCustomTheme(theme);

      if (!mounted) return;

      // Вернуться назад
      context.pop();
    } catch (e) {
      _showError('Error saving theme: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Обработка кнопки назад
  void _handleBack() {
    if (_hasChanges) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Discard changes?'),
          content: const Text(
            'You have unsaved changes. Are you sure you want to leave?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.pop();
              },
              child: const Text('Discard'),
            ),
          ],
        ),
      );
    } else {
      context.pop();
    }
  }

  /// Обработка смены режима Light/Dark
  void _handleModeChange(bool isDark) {
    final themeProvider = Provider.of<ThemeProviderV2>(context, listen: false);

    // Если базовая тема не выбрана, используем текущую тему провайдера
    AppThemeType targetTheme;
    if (_baseTheme == null) {
      // Используем текущую тему провайдера и переключаем её режим
      final currentTheme = themeProvider.currentTheme;
      if (isDark) {
        targetTheme = _getDarkVariant(currentTheme);
      } else {
        targetTheme = _getLightVariant(currentTheme);
      }
    } else {
      // Определяем какую тему применить на основе базовой темы
      targetTheme = _baseTheme!;
      if (isDark) {
        // Переключили на Dark
        targetTheme = _getDarkVariant(_baseTheme!);
      }
    }

    // Применяем тему для preview интерфейса
    themeProvider.setTheme(targetTheme);

    // Обновляем цвета в редакторе (для color pickers и preview)
    setState(() {
      _isDark = isDark;
      _editingColors = CustomColors.fromAppColors(themeProvider.currentColors);
      _markAsChanged();
    });
  }

  /// Обработка генерации с AI (заглушка)

  /// Обработка сброса к базовой теме
  void _handleResetToBaseTheme() {
    // Если базовая тема не выбрана, показываем ошибку
    if (_baseTheme == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a base theme first'),
          backgroundColor: context.colors.error,
        ),
      );
      return;
    }

    final themeProvider = Provider.of<ThemeProviderV2>(context, listen: false);

    // Определяем какую тему загружать (светлую или темную версию)
    AppThemeType targetTheme = _baseTheme!;
    if (_isDark) {
      targetTheme = _getDarkVariant(_baseTheme!);
    }

    // Применяем тему временно чтобы получить её цвета
    final previousTheme = themeProvider.currentTheme;
    themeProvider.setTheme(targetTheme);

    setState(() {
      _editingColors = CustomColors.fromAppColors(themeProvider.currentColors);
      _markAsChanged();
    });

    // Восстанавливаем предыдущую тему
    themeProvider.setTheme(previousTheme);

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.colorsResetTo(_getThemeDisplayName(targetTheme, l10n)),
        ),
        backgroundColor: context.colors.success,
      ),
    );
  }

  /// Получить темную версию светлой темы
  AppThemeType _getDarkVariant(AppThemeType lightTheme) {
    switch (lightTheme) {
      case AppThemeType.natural:
        return AppThemeType.dark;
      case AppThemeType.ocean:
        return AppThemeType.darkOcean;
      case AppThemeType.forest:
        return AppThemeType.darkForest;
      case AppThemeType.sunset:
        return AppThemeType.darkSunset;
      case AppThemeType.vibrant:
        return AppThemeType.darkVibrant;
      default:
        return AppThemeType.dark;
    }
  }

  /// Получить светлую версию темной темы
  AppThemeType _getLightVariant(AppThemeType theme) {
    switch (theme) {
      case AppThemeType.dark:
        return AppThemeType.natural;
      case AppThemeType.darkOcean:
        return AppThemeType.ocean;
      case AppThemeType.darkForest:
        return AppThemeType.forest;
      case AppThemeType.darkSunset:
        return AppThemeType.sunset;
      case AppThemeType.darkVibrant:
        return AppThemeType.vibrant;
      // Если уже светлая, возвращаем как есть
      default:
        return theme;
    }
  }

  /// Получить отображаемое имя темы
  String _getThemeDisplayName(AppThemeType theme, AppLocalizations l10n) {
    switch (theme) {
      case AppThemeType.natural:
        return l10n.naturalTheme;
      case AppThemeType.dark:
        return l10n.darkTheme;
      case AppThemeType.ocean:
        return l10n.oceanTheme;
      case AppThemeType.darkOcean:
        return 'Dark Ocean';
      case AppThemeType.forest:
        return l10n.forestTheme;
      case AppThemeType.darkForest:
        return 'Dark Forest';
      case AppThemeType.sunset:
        return l10n.sunsetTheme;
      case AppThemeType.darkSunset:
        return 'Dark Sunset';
      case AppThemeType.vibrant:
        return l10n.vibrantTheme;
      case AppThemeType.darkVibrant:
        return 'Dark Vibrant';
    }
  }

  /// Показать ошибку
  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: context.colors.error),
    );
  }
}
