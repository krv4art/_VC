import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import '../models/scan_result.dart';
import '../services/local_data_service.dart';
import '../models/analysis_result.dart';
import '../l10n/app_localizations.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/scaffold_with_drawer.dart';
import '../widgets/bottom_navigation_wrapper.dart';
import '../theme/theme_extensions_v2.dart';
import '../providers/subscription_provider.dart';
import '../services/usage_tracking_service.dart';
import 'package:provider/provider.dart';
import '../constants/app_dimensions.dart';
import '../widgets/common/app_spacer.dart';

class ScanHistoryScreen extends StatefulWidget {
  const ScanHistoryScreen({super.key});

  @override
  State<ScanHistoryScreen> createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends State<ScanHistoryScreen>
    with TickerProviderStateMixin {
  late Future<List<ScanResult>> _scanHistoryFuture;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadScanHistory();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Start animations after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  void _loadScanHistory() {
    _scanHistoryFuture = LocalDataService.instance.getAllScanResults();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _deleteScan(int id) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteScan),
        content: Text(l10n.deleteScanConfirmation),
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
      await LocalDataService.instance.deleteScanResult(id);
      setState(() {
        _loadScanHistory();
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  Widget _buildScanCard(
    ScanResult scan,
    AnalysisResult analysisResult,
    AppLocalizations l10n,
    int index,
  ) {
    // Фильтруем пустые/испорченные ингредиенты
    final validHighRiskIngredients = analysisResult.highRiskIngredients
        .where((ing) => ing.name.isNotEmpty)
        .toList();

    // Определяем цвет оценки безопасности
    final scoreColor = analysisResult.overallSafetyScore >= 7
        ? context.colors.success
        : analysisResult.overallSafetyScore >= 4
        ? context.colors.warning
        : context.colors.error;

    // Проверяем доступность элемента истории
    final usageService = UsageTrackingService();

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
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
              .animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(
                    index * 0.1,
                    (index * 0.1) + 0.5,
                    curve: Curves.easeOutCubic,
                  ),
                ),
              ),
          child: Consumer<SubscriptionProvider>(
            builder: (context, subscriptionProvider, child) {
              final isPremium = subscriptionProvider.isPremium;
              final isAccessible =
                  isPremium || usageService.isHistoryItemAccessible(index);

              return Stack(
                children: [
                  // Main card with fade animation
                  FadeTransition(
                    opacity: cardAnimation,
                    child: GestureDetector(
                      onTap: isAccessible
                          ? () {
                              debugPrint(
                                '=== HISTORY DEBUG: Card tapped! Scan ID: ${scan.id} ===',
                              );
                              debugPrint(
                                '=== HISTORY DEBUG: Image path: ${scan.imagePath} ===',
                              );
                              debugPrint(
                                '=== HISTORY DEBUG: Navigating to /analysis ===',
                              );
                              context.push(
                                '/analysis',
                                extra: {
                                  'result': analysisResult,
                                  'imagePath': scan.imagePath,
                                  'source': 'history',
                                },
                              );
                              debugPrint(
                                '=== HISTORY DEBUG: Navigation call completed ===',
                              );
                            }
                          : null,
                      child: Container(
                        margin: EdgeInsets.only(bottom: AppDimensions.space12),
                        decoration: BoxDecoration(
                          color: context.colors.surface,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radius24,
                          ),
                          boxShadow: [AppTheme.shadow],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(AppDimensions.space16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Thumbnail image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radius12,
                                ),
                                child: scan.imagePath.isNotEmpty
                                    ? Image.file(
                                        File(scan.imagePath),
                                        width: AppDimensions.space64,
                                        height: AppDimensions.space64,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                width: AppDimensions.space64,
                                                height: AppDimensions.space64,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade300,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        AppDimensions.radius12,
                                                      ),
                                                ),
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                  color: Colors.grey.shade600,
                                                ),
                                              );
                                            },
                                      )
                                    : Container(
                                        width: AppDimensions.space64,
                                        height: AppDimensions.space64,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions.radius12,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.photo,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                              ),
                              AppSpacer.h12(),
                              // Content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${analysisResult.ingredients.length} ${l10n.ingredientsFound}',
                                                style: AppTheme.bodyLarge
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              AppSpacer.v4(),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.shield_outlined,
                                                    size:
                                                        AppDimensions
                                                            .iconSmall -
                                                        2,
                                                    color: scoreColor,
                                                  ),
                                                  AppSpacer.h4(),
                                                  Text(
                                                    '${analysisResult.overallSafetyScore.toStringAsFixed(1)}/10',
                                                    style: AppTheme.caption
                                                        .copyWith(
                                                          color: scoreColor,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        AppSpacer.h8(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              _formatDate(scan.scanDate),
                                              style: AppTheme.caption.copyWith(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            AppSpacer.v4(),
                                            InkWell(
                                              onTap: () =>
                                                  _deleteScan(scan.id!),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    AppDimensions.radius24,
                                                  ),
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                  AppDimensions.space4,
                                                ),
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
                                    if (validHighRiskIngredients
                                        .isNotEmpty) ...[
                                      AppSpacer.v8(),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: AppDimensions.space8,
                                          vertical: AppDimensions.space4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: context.colors.error
                                              .withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions.radius8,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.warning_amber_rounded,
                                              size: AppDimensions.iconSmall - 2,
                                              color: context.colors.error,
                                            ),
                                            AppSpacer.h4(),
                                            Flexible(
                                              child: Text(
                                                '${validHighRiskIngredients.length} ${l10n.highRisk}',
                                                style: AppTheme.caption
                                                    .copyWith(
                                                      fontSize: 11,
                                                      color:
                                                          context.colors.error,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Blur overlay for inaccessible cards
                  if (!isAccessible)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radius24,
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              color: context.colors.surface.withValues(
                                alpha: 0.3,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radius24,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext dialogContext) =>
                                        AlertDialog(
                                          title: Row(
                                            children: [
                                              Icon(
                                                Icons.lock,
                                                color: context.colors.warning,
                                              ),
                                              AppSpacer.h12(),
                                              Text(l10n.premiumFeature),
                                            ],
                                          ),
                                          content: Text(
                                            l10n.historyLimitReachedMessage,
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(
                                                dialogContext,
                                              ).pop(),
                                              child: Text(l10n.cancel),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(
                                                  dialogContext,
                                                ).pop();
                                                context.push('/modern-paywall');
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    context.colors.primary,
                                              ),
                                              child: Text(
                                                l10n.upgradeToPremium,
                                              ),
                                            ),
                                          ],
                                        ),
                                  );
                                },
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.lock,
                                        size: AppDimensions.space48,
                                        color: context.colors.primary,
                                      ),
                                      AppSpacer.v8(),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: AppDimensions.space16,
                                          vertical: AppDimensions.space8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: context.colors.primary,
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions.space16 +
                                                AppDimensions.space4,
                                          ),
                                        ),
                                        child: Text(
                                          l10n.upgradeToView,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BottomNavigationWrapper(
      currentIndex: -1, // Не выделяем ни одну кнопку, так как это экран истории
      child: ScaffoldWithDrawer(
        appBar: CustomAppBar(title: l10n.scanHistory, showBackButton: true),
        body: FutureBuilder<List<ScanResult>>(
          future: _scanHistoryFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.space16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: AppDimensions.space48,
                        color: Colors.red,
                      ),
                      AppSpacer.v16(),
                      Text(
                        l10n.serverError,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppSpacer.v8(),
                      Text(
                        '${snapshot.error}',
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      AppSpacer.v16(),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _loadScanHistory();
                          });
                        },
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text(l10n.noScanHistoryFound));
            }

            final scanHistory = snapshot.data!;

            return ListView.builder(
              padding: EdgeInsets.all(AppDimensions.space16),
              itemCount: scanHistory.length,
              itemBuilder: (context, index) {
                try {
                  final scan = scanHistory[index];
                  final analysisData = scan.analysisResult;

                  // Используем AnalysisResult.fromJson напрямую - он сам распарсит все данные
                  final analysisResult = AnalysisResult.fromJson(analysisData);

                  return _buildScanCard(scan, analysisResult, l10n, index);
                } catch (e) {
                  // Показываем ошибку для конкретной карточки
                  return Card(
                    margin: EdgeInsets.only(bottom: AppDimensions.space12),
                    color: Colors.red.shade50,
                    child: Padding(
                      padding: EdgeInsets.all(AppDimensions.space16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.error, color: Colors.red),
                              AppSpacer.h8(),
                              Expanded(
                                child: Text(
                                  'Ошибка загрузки записи #$index',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          AppSpacer.v8(),
                          Text(
                            'Error: $e',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
