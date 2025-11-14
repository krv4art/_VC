import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/analysis_result.dart';
import '../../models/scan_result.dart';
import '../../providers/user_state.dart';
import '../../providers/locale_provider.dart';
import '../../providers/subscription_provider.dart';
import '../../services/gemini_service.dart';
import '../../services/local_data_service.dart';
import '../../services/usage_tracking_service.dart';
import '../../services/rating_service.dart';
import '../../widgets/rating_request_dialog.dart';
import '../../exceptions/api_exceptions.dart';
import '../scanning/scan_usage_validator.dart';
import '../scanning/prompt_builder_service.dart';
import '../scanning/image_compression_service.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/theme_extensions_v2.dart';

/// Result of image analysis with navigation info
class ImageAnalysisResult {
  final bool shouldShowJoke;
  final String? jokeText;
  final AnalysisResult? analysisResult;
  final String? imagePath;

  const ImageAnalysisResult({
    required this.shouldShowJoke,
    this.jokeText,
    this.analysisResult,
    this.imagePath,
  });
}

/// Service for processing and analyzing images
class ImageAnalysisService {
  const ImageAnalysisService();

  /// Process image from camera or gallery with unified logic
  Future<ImageAnalysisResult> processImage(
    XFile imageFile, {
    required BuildContext context,
    bool showSlowInternetMessage = false,
    VoidCallback? onSlowInternetMessage,
  }) async {
    // Проверка лимита сканирования для бесплатных пользователей
    final subscriptionProvider = context.read<SubscriptionProvider>();
    final usageValidator = const ScanUsageValidator();

    if (!subscriptionProvider.isPremium) {
      final canScan = await usageValidator.canUserScan(false);

      if (!canScan) {
        if (!context.mounted) {
          return const ImageAnalysisResult(shouldShowJoke: false);
        }

        // Показываем диалог с предложением оформить подписку
        final shouldUpgrade = await _showScanLimitDialog(context);

        if (shouldUpgrade == true && context.mounted) {
          context.push('/modern-paywall');
        }

        return const ImageAnalysisResult(shouldShowJoke: false);
      }
    }

    // Запускаем таймер для показа сообщения о медленном интернете через 7 секунд
    Timer? slowInternetTimer;
    if (onSlowInternetMessage != null) {
      slowInternetTimer = Timer(const Duration(seconds: 7), () {
        if (context.mounted) {
          onSlowInternetMessage();
        }
      });
    }

    try {
      // Save image locally
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = p.basename(imageFile.path);
      final String savedImagePath = p.join(appDir.path, fileName);
      await imageFile.saveTo(savedImagePath);

      // Compress image before sending to AI (reduces bandwidth and API costs)
      final Uint8List compressedBytes = await ImageCompressionService.compressImageFile(savedImagePath);
      final String base64Image = base64Encode(compressedBytes);

      if (!context.mounted) {
        return ImageAnalysisResult(
          shouldShowJoke: false,
          imagePath: savedImagePath,
        );
      }

      final userState = context.read<UserState>();
      final geminiService = context.read<GeminiService>();
      final localeProvider = context.read<LocaleProvider>();
      final l10n = AppLocalizations.of(context)!;

      // Get current language code
      final languageCode = localeProvider.locale?.languageCode ?? 'en';

      // Construct detailed prompt with all user parameters
      final userProfileParts = <String>[];
      if (userState.name != null && userState.name!.isNotEmpty) {
        userProfileParts.add('Name: ${userState.name}');
      }
      userProfileParts.add('Age: ${userState.ageRange ?? l10n.notSet}');
      userProfileParts.add('Skin Type: ${userState.skinType ?? l10n.notSet}');

      final String userProfilePrompt =
          'USER PROFILE: ${userProfileParts.join(', ')}';

      final promptBuilder = const PromptBuilderService();
      final String fullPrompt = promptBuilder.buildAnalysisPrompt(
        userProfilePrompt,
        languageCode,
      );

      final AnalysisResult result = await geminiService.analyzeImage(
        base64Image,
        fullPrompt,
        languageCode: languageCode,
      );

      slowInternetTimer?.cancel();

      if (!context.mounted) {
        return ImageAnalysisResult(
          shouldShowJoke: false,
          analysisResult: result,
          imagePath: savedImagePath,
        );
      }

      // Check if it's a cosmetic label
      if (!result.isCosmeticLabel && result.humorousMessage != null) {
        return ImageAnalysisResult(
          shouldShowJoke: true,
          jokeText: result.humorousMessage!,
        );
      }

      // Сохраняем в БД автоматически
      await _saveScanResult(result, savedImagePath);

      // Увеличиваем счетчик сканов для бесплатных пользователей
      if (!subscriptionProvider.isPremium) {
        await UsageTrackingService().incrementScansCount();
      }

      // Проверяем контекст перед диалогом оценки
      if (!context.mounted) {
        return const ImageAnalysisResult(shouldShowJoke: false);
      }

      // Проверяем, нужно ли показать диалог оценки
      await _handleRatingDialog(context);

      return ImageAnalysisResult(
        shouldShowJoke: false,
        analysisResult: result,
        imagePath: savedImagePath,
      );
    } on ApiException catch (e) {
      if (!context.mounted) {
        return const ImageAnalysisResult(shouldShowJoke: false);
      }
      final l10n = AppLocalizations.of(context)!;
      _showError(context, _getLocalizedErrorMessage(e, l10n));
      return const ImageAnalysisResult(shouldShowJoke: false);
    } catch (e) {
      if (!context.mounted) {
        return const ImageAnalysisResult(shouldShowJoke: false);
      }
      final l10n = AppLocalizations.of(context)!;
      _showError(context, l10n.analysisFailed);
      return const ImageAnalysisResult(shouldShowJoke: false);
    }
  }

  /// Save scan result to database
  Future<void> _saveScanResult(AnalysisResult result, String imagePath) async {
    final scanResult = ScanResult(
      imagePath: imagePath,
      analysisResult: {
        'ingredients': result.ingredients,
        'overall_safety_score': result.overallSafetyScore,
        'high_risk_ingredients': result.highRiskIngredients
            .map((e) => e.toJson())
            .toList(),
        'moderate_risk_ingredients': result.moderateRiskIngredients
            .map((e) => e.toJson())
            .toList(),
        'low_risk_ingredients': result.lowRiskIngredients
            .map((e) => e.toJson())
            .toList(),
        'personalized_warnings': result.personalizedWarnings,
        'benefits_analysis': result.benefitsAnalysis,
        'recommended_alternatives': result.recommendedAlternatives
            .map(
              (alt) => {
                'name': alt.name,
                'description': alt.description,
                'reason': alt.reason,
              },
            )
            .toList(),
      },
      scanDate: DateTime.now(),
    );

    await LocalDataService.instance.findOrCreateScanResult(scanResult);
  }

  /// Handle rating dialog logic
  Future<void> _handleRatingDialog(BuildContext context) async {
    final ratingService = RatingService();
    final shouldShow = await ratingService.shouldShowRatingDialog();

    if (shouldShow) {
      // Увеличиваем счетчик показов
      await ratingService.incrementRatingDialogShows();

      // Показываем диалог оценки
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false, // Нельзя закрыть по клику вне диалога
          builder: (context) => const RatingRequestDialog(),
        );
      }
    }
  }

  /// Show scan limit dialog
  Future<bool?> _showScanLimitDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    // Сохраняем цвета перед асинхронной операцией
    final warningColor = context.colors.warning;
    final primaryColor = context.colors.primary;

    return showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.lock, color: warningColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.scanLimitReached,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
        content: Text(l10n.scanLimitReachedMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            child: Text(l10n.upgradeToPremium),
          ),
        ],
      ),
    );
  }

  /// Show error message
  void _showError(BuildContext context, String message) {
    if (context.mounted) {
      final messenger = ScaffoldMessenger.of(context);
      final errorColor = context.colors.error;
      messenger.showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: errorColor,
          duration: const Duration(seconds: 10),
          action: SnackBarAction(
            label: '',
            onPressed: () {
              messenger.hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }

  /// Returns a localized error message based on exception type
  String _getLocalizedErrorMessage(ApiException e, AppLocalizations l10n) {
    if (e is ServiceOverloadedException) {
      return l10n.errorServiceOverloaded;
    } else if (e is RateLimitException) {
      return l10n.errorRateLimitExceeded;
    } else if (e is TimeoutException) {
      return l10n.errorTimeout;
    } else if (e is NetworkException) {
      return l10n.errorNetwork;
    } else if (e is AuthenticationException) {
      return l10n.errorAuthentication;
    } else if (e is InvalidResponseException) {
      return l10n.errorInvalidResponse;
    } else if (e is ServerException) {
      return l10n.errorServer;
    }
    return l10n.analysisFailed;
  }
}
