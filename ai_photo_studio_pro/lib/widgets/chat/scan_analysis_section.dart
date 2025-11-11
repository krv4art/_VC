import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/scan_result.dart';
import '../../models/analysis_result.dart';
import '../../widgets/scan_analysis_card.dart';

/// Callback when scan card is tapped
typedef OnScanCardTap = void Function(
  AnalysisResult analysisResult,
  String imagePath,
);

/// A wrapper widget for displaying scan analysis results
class ScanAnalysisSection extends StatelessWidget {
  final ScanResult scanResult;
  final AnalysisResult analysisResult;
  final OnScanCardTap? onTap;

  const ScanAnalysisSection({
    Key? key,
    required this.scanResult,
    required this.analysisResult,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScanAnalysisCard(
      imagePath: scanResult.imagePath,
      analysisResult: analysisResult,
      onTap: onTap != null
          ? () => onTap!(analysisResult, scanResult.imagePath)
          : () {
              // Default navigation to analysis screen
              context.push(
                '/analysis',
                extra: {
                  'result': analysisResult,
                  'imagePath': scanResult.imagePath,
                },
              );
            },
    );
  }
}
