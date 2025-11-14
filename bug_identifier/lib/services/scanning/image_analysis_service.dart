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
import '../../models/bug_analysis.dart'; // NEW: Insect models
import '../../models/analysis_result.dart'; // Legacy: for database compatibility
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
  final BugAnalysis?
      bugAnalysis; // NEW: Use BugAnalysis instead of AnalysisResult
  final String? imagePath;

  const ImageAnalysisResult({
    required this.shouldShowJoke,
    this.jokeText,
    this.bugAnalysis,
    this.imagePath,
  });

  // Legacy support: convert to AnalysisResult for backward compatibility
  AnalysisResult? get analysisResult =>
      bugAnalysis != null ? _convertToLegacyFormat(bugAnalysis!) : null;

  /// Convert BugAnalysis to legacy AnalysisResult format for database storage
  static AnalysisResult _convertToLegacyFormat(BugAnalysis bug) {
    return AnalysisResult(
      isCosmeticLabel: bug.isInsect, // Map isInsect to isCosmeticLabel for DB
      humorousMessage: bug.humorousMessage,
      ingredients: List<String>.from(
          bug.characteristics), // Characteristics → ingredients
      overallSafetyScore: bug.dangerLevel, // dangerLevel → overallSafetyScore
      highRiskIngredients: bug.dangerousTraits
          .map((t) => IngredientInfo(name: t.name, hint: t.description))
          .toList(),
      moderateRiskIngredients: bug.notableTraits
          .map((t) => IngredientInfo(name: t.name, hint: t.description))
          .toList(),
      lowRiskIngredients: bug.commonTraits
          .map((t) => IngredientInfo(name: t.name, hint: t.description))
          .toList(),
      personalizedWarnings: List<String>.from(bug.personalizedWarnings),
      benefitsAnalysis: bug.ecologicalRole, // ecologicalRole → benefitsAnalysis
      recommendedAlternatives: bug.similarSpecies
          .map((s) => RecommendedAlternative(
                name: s.name,
                description: s.scientificName,
                reason: s.differences,
              ))
          .toList(),
      aiSummary: bug.aiSummary,
      productType: bug.habitat, // habitat → productType
      brandName: bug.scientificName, // scientificName → brandName
    );
  }
}

/// Service for processing and analyzing insect images
class ImageAnalysisService {
  const ImageAnalysisService();

  /// Process image from camera or gallery with unified logic
  Future<ImageAnalysisResult> processImage(
    XFile imageFile, {
    required BuildContext context,
    bool showSlowInternetMessage = false,
    VoidCallback? onSlowInternetMessage,
  }) async {
    // Check scan limit for free users
    final subscriptionProvider = context.read<SubscriptionProvider>();
    final usageValidator = const ScanUsageValidator();

    if (!subscriptionProvider.isPremium) {
      final canScan = await usageValidator.canUserScan(false);

      if (!canScan) {
        if (!context.mounted) {
          return const ImageAnalysisResult(shouldShowJoke: false);
        }

        // Show subscription dialog
        final shouldUpgrade = await _showScanLimitDialog(context);

        if (shouldUpgrade == true && context.mounted) {
          context.push('/modern-paywall');
        }

        return const ImageAnalysisResult(shouldShowJoke: false);
      }
    }

    // Start timer for slow internet message after 7 seconds
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

      // Construct user profile for insect identification
      final userProfileParts = <String>[];
      if (userState.name != null && userState.name!.isNotEmpty) {
        userProfileParts.add('Name: ${userState.name}');
      }

      // TODO: Add location-based preferences when available
      // For now, use generic profile
      userProfileParts
          .add('Interests: Insect identification, nature observation');

      // Use allergies as sensitivity warnings (bee stings, etc.)
      if (userState.allergies.isNotEmpty) {
        userProfileParts
            .add('Sensitivities: ${userState.allergies.join(', ')}');
      }

      final String userProfilePrompt =
          'USER PROFILE: ${userProfileParts.join(', ')}';

      final promptBuilder = const PromptBuilderService();
      final String fullPrompt = promptBuilder.buildInsectAnalysisPrompt(
        userProfilePrompt,
        languageCode,
      );

      // Analyze image with insect identification prompt
      final BugAnalysis result = await geminiService.analyzeBugImage(
        base64Image,
        fullPrompt,
        languageCode: languageCode,
      );

      slowInternetTimer?.cancel();

      if (!context.mounted) {
        return ImageAnalysisResult(
          shouldShowJoke: false,
          bugAnalysis: result,
          imagePath: savedImagePath,
        );
      }

      // Check if it's an insect
      if (!result.isInsect && result.humorousMessage != null) {
        return ImageAnalysisResult(
          shouldShowJoke: true,
          jokeText: result.humorousMessage!,
        );
      }

      // Save to database automatically
      await _saveScanResult(result, savedImagePath);

      // Increment scan count for free users
      if (!subscriptionProvider.isPremium) {
        await UsageTrackingService().incrementScansCount();
      }

      // Check context before showing rating dialog
      if (!context.mounted) {
        return const ImageAnalysisResult(shouldShowJoke: false);
      }

      // Check if we should show rating dialog
      await _handleRatingDialog(context);

      return ImageAnalysisResult(
        shouldShowJoke: false,
        bugAnalysis: result,
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

  /// Save scan result to database using legacy format
  Future<void> _saveScanResult(BugAnalysis result, String imagePath) async {
    // Convert to legacy format for database storage
    final legacyResult = ImageAnalysisResult._convertToLegacyFormat(result);

    final scanResult = ScanResult(
      imagePath: imagePath,
      analysisResult: {
        'is_insect': result.isInsect,
        'characteristics': result.characteristics,
        'danger_level': result.dangerLevel,
        'dangerous_traits':
            result.dangerousTraits.map((e) => e.toJson()).toList(),
        'notable_traits': result.notableTraits.map((e) => e.toJson()).toList(),
        'common_traits': result.commonTraits.map((e) => e.toJson()).toList(),
        'personalized_warnings': result.personalizedWarnings,
        'ecological_role': result.ecologicalRole,
        'similar_species':
            result.similarSpecies.map((s) => s.toJson()).toList(),
        'ai_summary': result.aiSummary,
        'habitat': result.habitat,
        'common_name': result.commonName,
        'scientific_name': result.scientificName,
        'taxonomy_info': result.taxonomyInfo?.toJson(),

        // Legacy format for backward compatibility
        'ingredients': result.characteristics,
        'overall_safety_score': result.dangerLevel,
        'high_risk_ingredients': result.dangerousTraits
            .map((e) => {'name': e.name, 'hint': e.description})
            .toList(),
        'moderate_risk_ingredients': result.notableTraits
            .map((e) => {'name': e.name, 'hint': e.description})
            .toList(),
        'low_risk_ingredients': result.commonTraits
            .map((e) => {'name': e.name, 'hint': e.description})
            .toList(),
        'benefits_analysis': result.ecologicalRole,
        'recommended_alternatives': result.similarSpecies
            .map((s) => {
                  'name': s.name,
                  'description': s.scientificName,
                  'reason': s.differences,
                })
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
      // Increment rating dialog show count
      await ratingService.incrementRatingDialogShows();

      // Show rating dialog
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const RatingRequestDialog(),
        );
      }
    }
  }

  /// Show scan limit dialog
  Future<bool?> _showScanLimitDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    // Save colors before async operation
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
