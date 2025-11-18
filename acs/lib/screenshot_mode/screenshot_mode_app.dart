import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:acs/l10n/app_localizations.dart';
import 'package:acs/screens/homepage_screen.dart';
import 'package:acs/theme/app_theme.dart';
import 'package:acs/theme/app_colors.dart';
import 'package:acs/providers/user_state.dart';
import 'package:acs/providers/theme_provider_v2.dart';
import 'screenshot_controller.dart';
import 'screenshot_toolbar.dart';

/// Приложение в режиме создания скриншотов
class ScreenshotModeApp extends StatefulWidget {
  final String? initialLocale;

  const ScreenshotModeApp({
    super.key,
    this.initialLocale,
  });

  @override
  State<ScreenshotModeApp> createState() => _ScreenshotModeAppState();
}

class _ScreenshotModeAppState extends State<ScreenshotModeApp> {
  late ScreenshotController _controller;
  final GlobalKey _screenshotKey = GlobalKey();
  bool _showToolbar = true;

  @override
  void initState() {
    super.initState();
    _controller = ScreenshotController();
    if (widget.initialLocale != null) {
      _controller.setLocale(widget.initialLocale!);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      // F9 - сделать скриншот
      if (event.logicalKey == LogicalKeyboardKey.f9) {
        _captureScreenshot();
      }
      // F10 - переключить панель инструментов
      else if (event.logicalKey == LogicalKeyboardKey.f10) {
        setState(() {
          _showToolbar = !_showToolbar;
        });
      }
      // F11 - открыть папку со скриншотами
      else if (event.logicalKey == LogicalKeyboardKey.f11) {
        _controller.openScreenshotsFolder();
      }
    }
  }

  Future<void> _captureScreenshot() async {
    final path = await _controller.captureAndSave(_screenshotKey);
    if (path != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Скриншот сохранён: $path'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserState()),
        ChangeNotifierProvider(create: (_) => ThemeProviderV2()),
      ],
      child: KeyboardListener(
        focusNode: FocusNode()..requestFocus(),
        onKeyEvent: _handleKeyEvent,
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, child) {
            return MaterialApp(
              title: 'ACS - Screenshot Mode',
              debugShowCheckedModeBanner: false,
              locale: Locale(_controller.currentLocale),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              theme: AppTheme.getThemeData(NaturalColors(), false),
              darkTheme: AppTheme.getThemeData(DarkColors(), true),
              themeMode: ThemeMode.system,
              home: Scaffold(
                body: Stack(
                  children: [
                    // Основное приложение для скриншота
                    RepaintBoundary(
                      key: _screenshotKey,
                      child: const HomepageScreen(),
                    ),
                    // Панель инструментов
                    if (_showToolbar)
                      ScreenshotToolbar(
                        controller: _controller,
                        onCapture: _captureScreenshot,
                        onToggleToolbar: () {
                          setState(() {
                            _showToolbar = false;
                          });
                        },
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
