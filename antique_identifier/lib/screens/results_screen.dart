import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/analysis_result.dart';
import '../providers/analysis_provider.dart';
import '../providers/collection_provider.dart';
import '../widgets/animated_entrance.dart';
import '../widgets/visual_matches_widget.dart';
import '../services/pdf_export_service.dart';
import '../services/collection_service.dart';

/// Экран с результатами анализа антиквариата
class ResultsScreen extends StatelessWidget {
  final String? resultId;

  const ResultsScreen({Key? key, this.resultId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareResults(context),
          ),
        ],
      ),
      body: Consumer<AnalysisProvider>(
        builder: (context, provider, _) {
          final result = provider.currentAnalysis;

          if (result == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.info, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No analysis results available'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/'),
                    child: const Text('Go Home'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with fade animation
                AnimatedEntrance(
                  delay: Duration.zero,
                  duration: const Duration(milliseconds: 500),
                  child: _buildHeader(context, result),
                ),
                const SizedBox(height: 24),

                // Warnings Banner with staggered animation
                if (result.warnings.isNotEmpty)
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 100),
                    duration: const Duration(milliseconds: 500),
                    child: _buildWarningsBanner(context, result),
                  ),
                if (result.warnings.isNotEmpty) const SizedBox(height: 24),

                // Description
                AnimatedEntrance(
                  delay: const Duration(milliseconds: 200),
                  duration: const Duration(milliseconds: 500),
                  child: _buildSection(
                    context,
                    'Description',
                    Icons.description,
                    _buildDescriptionContent(result),
                  ),
                ),
                const SizedBox(height: 16),

                // Materials
                if (result.materials.isNotEmpty)
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 300),
                    duration: const Duration(milliseconds: 500),
                    child: _buildSection(
                      context,
                      'Materials',
                      Icons.construction,
                      _buildMaterialsList(result),
                    ),
                  ),
                if (result.materials.isNotEmpty) const SizedBox(height: 16),

                // Historical Context
                if (result.historicalContext.isNotEmpty)
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 400),
                    duration: const Duration(milliseconds: 500),
                    child: _buildSection(
                      context,
                      'Historical Context',
                      Icons.history,
                      _buildHistoricalContext(context, result),
                    ),
                  ),
                if (result.historicalContext.isNotEmpty) const SizedBox(height: 16),

                // Price Estimate
                if (result.priceEstimate != null)
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 500),
                    duration: const Duration(milliseconds: 500),
                    child: _buildSection(
                      context,
                      'Estimated Value',
                      Icons.attach_money,
                      _buildPriceEstimate(context, result),
                    ),
                  ),
                if (result.priceEstimate != null) const SizedBox(height: 16),

                // Visual Matches (Market Search)
                if (result.visualMatches.isNotEmpty)
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 550),
                    duration: const Duration(milliseconds: 500),
                    child: _buildSection(
                      context,
                      'Visual Matches',
                      Icons.shopping_bag,
                      VisualMatchesWidget(
                        itemName: result.itemName,
                        category: result.category ?? 'antique',
                        visualMatches: result.visualMatches,
                      ),
                    ),
                  ),
                if (result.visualMatches.isNotEmpty) const SizedBox(height: 16),

                // Similar Items
                if (result.similarItems.isNotEmpty)
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 600),
                    duration: const Duration(milliseconds: 500),
                    child: _buildSection(
                      context,
                      'Similar Items',
                      Icons.compare,
                      _buildSimilarItems(result),
                    ),
                  ),
                const SizedBox(height: 32),

                // Chat Button
                AnimatedEntrance(
                  delay: const Duration(milliseconds: 700),
                  duration: const Duration(milliseconds: 500),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () => context.push('/chat?dialogueId=1'),
                      icon: const Icon(Icons.chat_bubble),
                      label: const Text('Chat with AI Expert'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Save Button
                AnimatedEntrance(
                  delay: const Duration(milliseconds: 800),
                  duration: const Duration(milliseconds: 500),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: () => _saveToCollection(context, result),
                      icon: const Icon(Icons.bookmark_add),
                      label: const Text('Save to Collection'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AnalysisResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          result.itemName,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (result.category != null)
          Chip(
            label: Text(result.category!),
            backgroundColor: Colors.amber.shade100,
          ),
        const SizedBox(height: 8),
        if (result.estimatedPeriod != null)
          Text(
            'Period: ${result.estimatedPeriod}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        if (result.estimatedOrigin != null)
          Text(
            'Origin: ${result.estimatedOrigin}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
      ],
    );
  }

  Widget _buildWarningsBanner(BuildContext context, AnalysisResult result) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning, color: Colors.orange.shade700),
              const SizedBox(width: 8),
              Text(
                'Important Notes',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.orange.shade900,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...result.warnings.map((warning) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(color: Colors.orange.shade700)),
                Expanded(
                  child: Text(
                    warning,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.orange.shade900,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    Widget content,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.amber.shade700),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  Widget _buildDescriptionContent(AnalysisResult result) {
    return Text(
      result.description,
      style: const TextStyle(height: 1.6),
    );
  }

  Widget _buildMaterialsList(AnalysisResult result) {
    return Column(
      children: result.materials
          .map((material) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  material.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  material.description,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
          ))
          .toList(),
    );
  }

  Widget _buildHistoricalContext(BuildContext context, AnalysisResult result) {
    return Text(
      result.historicalContext,
      style: const TextStyle(height: 1.6),
    );
  }

  Widget _buildPriceEstimate(BuildContext context, AnalysisResult result) {
    final estimate = result.priceEstimate!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            estimate.getFormattedRange(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.amber.shade900,
            ),
          ),
          const SizedBox(height: 12),
          _buildEstimateInfo('Confidence', estimate.confidence),
          _buildEstimateInfo('Based on', estimate.basedOn),
          const SizedBox(height: 12),
          Text(
            '* This is an estimate based on AI analysis. Professional appraisal recommended for significant items.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstimateInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarItems(AnalysisResult result) {
    return Column(
      children: result.similarItems
          .map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.compare, color: Colors.grey.shade600),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(item, style: const TextStyle(height: 1.5)),
                  ),
                ],
              ),
            ),
          ))
          .toList(),
    );
  }

  Future<void> _shareResults(BuildContext context) async {
    final provider = Provider.of<AnalysisProvider>(context, listen: false);
    final result = provider.currentAnalysis;

    if (result == null) return;

    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Generating PDF...'),
                ],
              ),
            ),
          ),
        ),
      );

      final pdfService = PdfExportService();
      final pdfBytes = await pdfService.generatePdfReport(result);

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Share or save PDF
      if (context.mounted) {
        await pdfService.sharePdf(pdfBytes, '${result.itemName}_analysis.pdf');
      }
    } catch (e) {
      // Close loading dialog if still open
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error exporting PDF: $e')),
        );
      }
    }
  }

  Future<void> _saveToCollection(BuildContext context, AnalysisResult result) async {
    try {
      final collectionService = CollectionService();
      final success = await collectionService.saveToCollection(result);

      if (success) {
        // Update provider if available
        final collectionProvider = Provider.of<CollectionProvider>(context, listen: false);
        await collectionProvider.loadCollection();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('${result.itemName} saved to collection!'),
                ],
              ),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.green.shade700,
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save to collection')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}
