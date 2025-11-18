import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path/path.dart' as path;

/// Контроллер для создания скриншотов в режиме скриншотов
class ScreenshotController extends ChangeNotifier {
  String _currentLocale = 'en';
  int _screenshotCounter = 1;
  String? _lastSavedPath;
  bool _isSaving = false;

  String get currentLocale => _currentLocale;
  int get screenshotCounter => _screenshotCounter;
  String? get lastSavedPath => _lastSavedPath;
  bool get isSaving => _isSaving;

  /// Список доступных языков
  static const Map<String, String> availableLocales = {
    'en': 'English',
    'ru': 'Русский',
    'uk': 'Українська',
    'de': 'Deutsch',
    'fr': 'Français',
    'es': 'Español',
    'it': 'Italiano',
    'pt': 'Português',
    'pl': 'Polski',
    'zh': '中文',
    'ja': '日本語',
    'ko': '한국어',
    'ar': 'العربية',
    'cs': 'Čeština',
    'da': 'Dansk',
    'el': 'Ελληνικά',
    'fi': 'Suomi',
    'hi': 'हिन्दी',
    'hu': 'Magyar',
    'id': 'Bahasa Indonesia',
    'nl': 'Nederlands',
    'no': 'Norsk',
    'ro': 'Română',
    'sv': 'Svenska',
    'th': 'ไทย',
    'tr': 'Türkçe',
    'vi': 'Tiếng Việt',
  };

  void setLocale(String locale) {
    _currentLocale = locale;
    _screenshotCounter = 1;
    _lastSavedPath = null;
    notifyListeners();
  }

  void incrementCounter() {
    _screenshotCounter++;
    notifyListeners();
  }

  void resetCounter() {
    _screenshotCounter = 1;
    notifyListeners();
  }

  /// Создать скриншот и сохранить в файл
  Future<String?> captureAndSave(GlobalKey key) async {
    if (_isSaving) return null;

    // Веб не поддерживает сохранение в файловую систему
    if (kIsWeb) {
      debugPrint('Screenshot saving is not supported on web. Please use browser screenshot tools (F12 -> Device toolbar -> Screenshot)');
      return null;
    }

    _isSaving = true;
    notifyListeners();

    try {
      // Получаем boundary для рендеринга
      final RenderRepaintBoundary boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary;

      // Создаём изображение
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      // Определяем путь для сохранения
      final projectPath = await _getProjectPath();
      final screenshotsDir = Directory(
        path.join(projectPath, 'store_listings', 'screenshots', _currentLocale),
      );

      if (!screenshotsDir.existsSync()) {
        screenshotsDir.createSync(recursive: true);
      }

      // Сохраняем файл
      final filePath = path.join(
        screenshotsDir.path,
        'screenshot_$_screenshotCounter.png',
      );
      final file = File(filePath);
      await file.writeAsBytes(pngBytes);

      _lastSavedPath = filePath;
      _screenshotCounter++;
      notifyListeners();

      return filePath;
    } catch (e) {
      debugPrint('Error capturing screenshot: $e');
      return null;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  /// Получить путь к проекту
  Future<String> _getProjectPath() async {
    // Для Windows получаем путь к exe и поднимаемся выше
    final exePath = Platform.resolvedExecutable;
    final exeDir = Directory(path.dirname(exePath));

    // Поднимаемся на несколько уровней вверх от build/windows/x64/runner/...
    var current = exeDir;
    while (current.path.contains('build') && current.parent.path != current.path) {
      current = current.parent;
    }

    return current.path;
  }

  /// Открыть папку со скриншотами
  Future<void> openScreenshotsFolder() async {
    try {
      final projectPath = await _getProjectPath();
      final screenshotsDir = path.join(
        projectPath,
        'store_listings',
        'screenshots',
        _currentLocale,
      );

      if (Platform.isWindows) {
        await Process.run('explorer', [screenshotsDir]);
      }
    } catch (e) {
      debugPrint('Error opening folder: $e');
    }
  }
}
