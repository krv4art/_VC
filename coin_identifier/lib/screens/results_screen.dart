import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/analysis_result.dart';
import '../providers/analysis_provider.dart';
import '../providers/collection_provider.dart';
import '../widgets/animated_entrance.dart';
import 'dart:math' as math;

/// Screen displaying detailed coin/banknote analysis results
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
            tooltip: 'Share Results',
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_add),
            onPressed: () => _saveToCollection(context),
            tooltip: 'Save to Collection',
          ),
        ],
      ),
      floatingActionButton: AnimatedEntrance(
        delay: const Duration(milliseconds: 800),
        child: FloatingActionButton.extended(
          onPressed: () => context.push('/chat?dialogueId=1'),
          icon: const Icon(Icons.chat_bubble),
          label: const Text('Ask AI Expert'),
          backgroundColor: const Color(0xFFD4AF37),
        ),
      ),
      body: Consumer<AnalysisProvider>(
        builder: (context, provider, _) {
          final result = provider.currentAnalysis;

          if (result == null) {
            return _buildNoResultsState(context);
          }

          // Check if it's not a coin/banknote
          if (!result.isCoinOrBanknote) {
            return _buildNotCoinState(context, result);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Hero Card with Basic Info (0ms)
                AnimatedEntrance(
                  delay: Duration.zero,
                  child: _buildHeroCard(context, result),
                ),
                const SizedBox(height: 16),

                // 2. Rarity & Value Card (60ms)
                AnimatedEntrance(
                  delay: const Duration(milliseconds: 60),
                  child: _buildRarityValueCard(context, result),
                ),
                const SizedBox(height: 16),

                // 3. AI Summary (120ms)
                if (result.aiSummary != null && result.aiSummary!.isNotEmpty)
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 120),
                    child: _buildAISummaryCard(context, result),
                  ),
                if (result.aiSummary != null && result.aiSummary!.isNotEmpty)
                  const SizedBox(height: 16),

                // 4. Quick Stats Grid (180ms)
                AnimatedEntrance(
                  delay: const Duration(milliseconds: 180),
                  child: _buildQuickStatsGrid(context, result),
                ),
                const SizedBox(height: 16),

                // 5. Mint Errors Banner (240ms) - Only if errors exist
                if (result.mintErrors.isNotEmpty)
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 240),
                    child: _buildMintErrorsBanner(context, result),
                  ),
                if (result.mintErrors.isNotEmpty) const SizedBox(height: 16),

                // 6. Warnings Banner (300ms) - Only if warnings exist
                if (result.warnings.isNotEmpty)
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 300),
                    child: _buildWarningsBanner(context, result),
                  ),
                if (result.warnings.isNotEmpty) const SizedBox(height: 16),

                // 7. Obverse & Reverse Descriptions (360ms)
                if (result.obverseDescription != null || result.reverseDescription != null)
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 360),
                    child: _buildSidesDescription(context, result),
                  ),
                if (result.obverseDescription != null || result.reverseDescription != null)
                  const SizedBox(height: 16),

                // 8. Materials Composition (420ms)
                if (result.materials.isNotEmpty)
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 420),
                    child: _buildMaterialsCard(context, result),
                  ),
                if (result.materials.isNotEmpty) const SizedBox(height: 16),

                // 9. Physical Characteristics (480ms)
                AnimatedEntrance(
                  delay: const Duration(milliseconds: 480),
                  child: _buildPhysicalCharacteristics(context, result),
                ),
                const SizedBox(height: 16),

                // 10. Historical Context (540ms)
                if (result.historicalContext.isNotEmpty)
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 540),
                    child: _buildHistoricalContext(context, result),
                  ),
                if (result.historicalContext.isNotEmpty) const SizedBox(height: 16),

                // 11. Authenticity Notes (600ms)
                if (result.authenticityNotes != null && result.authenticityNotes!.isNotEmpty)
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 600),
                    child: _buildAuthenticityNotes(context, result),
                  ),
                if (result.authenticityNotes != null && result.authenticityNotes!.isNotEmpty)
                  const SizedBox(height: 16),

                // 12. Similar Coins (660ms)
                if (result.similarCoins.isNotEmpty)
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 660),
                    child: _buildSimilarCoins(context, result),
                  ),
                if (result.similarCoins.isNotEmpty) const SizedBox(height: 16),

                // 13. Expert Advice (720ms)
                if (result.expertAdvice != null && result.expertAdvice!.isNotEmpty)
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 720),
                    child: _buildExpertAdvice(context, result),
                  ),
                if (result.expertAdvice != null && result.expertAdvice!.isNotEmpty)
                  const SizedBox(height: 16),

                // Spacing for FAB
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }

  // State: No results available
  Widget _buildNoResultsState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.monetization_on, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 24),
          Text(
            'No analysis results available',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Scan a coin to see detailed analysis',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.home),
            label: const Text('Go Home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  // State: Not a coin or banknote
  Widget _buildNotCoinState(BuildContext context, AnalysisResult result) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedEntrance(
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber.shade200, width: 2),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.sentiment_satisfied,
                      size: 80,
                      color: Colors.amber.shade700,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Not a Coin or Banknote',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade900,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    if (result.humorousMessage != null)
                      Text(
                        result.humorousMessage!,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.amber.shade800,
                              height: 1.5,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () => context.go('/scan'),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Try Again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 1. Hero Card
  Widget _buildHeroCard(BuildContext context, AnalysisResult result) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFD4AF37).withOpacity(0.1),
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    result.itemType == 'banknote'
                        ? Icons.payments
                        : Icons.monetization_on,
                    size: 32,
                    color: const Color(0xFFD4AF37),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.name,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (result.country != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          result.country!,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (result.yearOfIssue != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Year: ${result.yearOfIssue}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
            if (result.description.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                result.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // 2. Rarity & Value Card
  Widget _buildRarityValueCard(BuildContext context, AnalysisResult result) {
    final rarityColor = _getRarityColor(result.rarityScore);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rarity & Value',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                // Rarity Indicator
                _buildRarityIndicator(context, result, rarityColor),
                const SizedBox(width: 24),
                // Rarity Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.rarityLevel,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: rarityColor,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Score: ${result.rarityScore}/10',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      if (result.collectorInterest != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          result.collectorInterest!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                                height: 1.4,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            // Market Value
            if (result.marketValue != null) ...[
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
              _buildMarketValueSection(context, result.marketValue!),
            ],
          ],
        ),
      ),
    );
  }

  // Rarity Circular Indicator
  Widget _buildRarityIndicator(
    BuildContext context,
    AnalysisResult result,
    Color color,
  ) {
    final progress = result.rarityScore / 10.0;

    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 8,
              valueColor: AlwaysStoppedAnimation(Colors.grey[200]),
            ),
          ),
          // Progress circle
          SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 8,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          // Center text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${result.rarityScore}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
              Text(
                'out of 10',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Market Value Section
  Widget _buildMarketValueSection(BuildContext context, MarketValue marketValue) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFD4AF37).withOpacity(0.1),
            const Color(0xFFD4AF37).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.attach_money, color: Colors.amber[700]),
              const SizedBox(width: 8),
              Text(
                'Market Value',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            marketValue.getFormattedRange(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[900],
                ),
          ),
          const SizedBox(height: 12),
          _buildValueMetadata('Condition', marketValue.condition),
          _buildValueMetadata('Confidence', marketValue.confidence.toUpperCase()),
          _buildValueMetadata('Source', marketValue.source),
          const SizedBox(height: 12),
          Text(
            '* Market values are estimates. Professional appraisal recommended.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildValueMetadata(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black54),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // 3. AI Summary Card
  Widget _buildAISummaryCard(BuildContext context, AnalysisResult result) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  'AI Expert Summary',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              result.aiSummary!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.blue.shade900,
                    height: 1.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  // 4. Quick Stats Grid
  Widget _buildQuickStatsGrid(BuildContext context, AnalysisResult result) {
    final stats = <Map<String, String?>>[];

    if (result.mintMark != null) {
      stats.add({'label': 'Mint Mark', 'value': result.mintMark, 'icon': 'mark'});
    }
    if (result.denomination != null) {
      stats.add({'label': 'Denomination', 'value': result.denomination, 'icon': 'money'});
    }
    if (result.mintageQuantity != null) {
      stats.add({'label': 'Mintage', 'value': result.mintageQuantity, 'icon': 'production'});
    }
    if (result.circulationPeriod != null) {
      stats.add({'label': 'Circulation', 'value': result.circulationPeriod, 'icon': 'time'});
    }

    if (stats.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Stats',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: stats.map((stat) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        stat['label']!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stat['value']!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // 5. Mint Errors Banner
  Widget _buildMintErrorsBanner(BuildContext context, AnalysisResult result) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade100, Colors.purple.shade50],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.shade300),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.shade700,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.error, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Mint Errors Detected',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade900,
                      ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.purple.shade700,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${result.mintErrors.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...result.mintErrors.map((error) => _buildMintErrorItem(context, error)),
        ],
      ),
    );
  }

  Widget _buildMintErrorItem(BuildContext context, MintError error) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.purple.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            error.errorType,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade900,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            error.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.4,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.trending_up, size: 16, color: Colors.green.shade700),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Rarity Impact: ${error.rarityImpact}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          if (error.estimatedValueIncrease != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.monetization_on, size: 16, color: Colors.amber.shade700),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Value Increase: ${error.estimatedValueIncrease}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.amber.shade900,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // 6. Warnings Banner
  Widget _buildWarningsBanner(BuildContext context, AnalysisResult result) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.orange.shade700, size: 24),
              const SizedBox(width: 12),
              Text(
                'Important Warnings',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade900,
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
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.orange.shade900,
                              height: 1.4,
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

  // 7. Obverse & Reverse Descriptions
  Widget _buildSidesDescription(BuildContext context, AnalysisResult result) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Coin Sides',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (result.obverseDescription != null) ...[
              const SizedBox(height: 16),
              _buildSideDescription(
                context,
                'Obverse (Front)',
                result.obverseDescription!,
                Icons.panorama_fish_eye,
              ),
            ],
            if (result.reverseDescription != null) ...[
              const SizedBox(height: 16),
              _buildSideDescription(
                context,
                'Reverse (Back)',
                result.reverseDescription!,
                Icons.flip,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSideDescription(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Colors.grey[700]),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  // 8. Materials Composition
  Widget _buildMaterialsCard(BuildContext context, AnalysisResult result) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.science, color: Colors.amber.shade700),
                const SizedBox(width: 8),
                Text(
                  'Materials Composition',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...result.materials.map((material) => _buildMaterialItem(context, material)),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialItem(BuildContext context, CoinMaterial material) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber.shade50, Colors.amber.shade100],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  material.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  material.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[700],
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber.shade700,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${material.percentage.toStringAsFixed(1)}%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 9. Physical Characteristics
  Widget _buildPhysicalCharacteristics(BuildContext context, AnalysisResult result) {
    final characteristics = <Map<String, String>>[];

    if (result.weight != null) {
      characteristics.add({
        'label': 'Weight',
        'value': '${result.weight!.toStringAsFixed(2)} g',
        'icon': 'weight'
      });
    }
    if (result.diameter != null) {
      characteristics.add({
        'label': 'Diameter',
        'value': '${result.diameter!.toStringAsFixed(2)} mm',
        'icon': 'diameter'
      });
    }
    if (result.edge != null) {
      characteristics.add({'label': 'Edge', 'value': result.edge!, 'icon': 'edge'});
    }

    if (characteristics.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.straighten, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  'Physical Characteristics',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...characteristics.map((char) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        char['label']!,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      Text(
                        char['value']!,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  // 10. Historical Context
  Widget _buildHistoricalContext(BuildContext context, AnalysisResult result) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history_edu, color: Colors.brown.shade700),
                const SizedBox(width: 8),
                Text(
                  'Historical Context',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              result.historicalContext,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  // 11. Authenticity Notes
  Widget _buildAuthenticityNotes(BuildContext context, AnalysisResult result) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.verified_user, color: Colors.green.shade700),
                const SizedBox(width: 8),
                Text(
                  'Authenticity Notes',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              result.authenticityNotes!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.green.shade900,
                    height: 1.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  // 12. Similar Coins
  Widget _buildSimilarCoins(BuildContext context, AnalysisResult result) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.compare_arrows, color: Colors.indigo.shade700),
                const SizedBox(width: 8),
                Text(
                  'Similar Coins',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...result.similarCoins.map((coin) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(Icons.monetization_on,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          coin,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  // 13. Expert Advice
  Widget _buildExpertAdvice(BuildContext context, AnalysisResult result) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.teal.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.teal.shade700),
                const SizedBox(width: 8),
                Text(
                  'Expert Advice',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade900,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              result.expertAdvice!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.teal.shade900,
                    height: 1.6,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper: Get rarity color based on score
  Color _getRarityColor(int score) {
    if (score >= 9) return Colors.purple.shade700; // Extremely Rare
    if (score >= 7) return Colors.orange.shade700; // Very Rare
    if (score >= 5) return Colors.amber.shade700; // Rare
    if (score >= 3) return Colors.blue.shade700; // Uncommon
    return Colors.grey.shade600; // Common
  }

  // Actions
  void _shareResults(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _saveToCollection(BuildContext context) {
    final analysisProvider = context.read<AnalysisProvider>();
    final result = analysisProvider.currentAnalysis;

    if (result != null) {
      _showSaveDialog(context, result);
    }
  }

  void _showSaveDialog(BuildContext context, AnalysisResult result) {
    showDialog(
      context: context,
      builder: (dialogContext) => _SaveCoinDialog(result: result),
    );
  }
}

/// Dialog for saving coin to collection with metadata
class _SaveCoinDialog extends StatefulWidget {
  final AnalysisResult result;

  const _SaveCoinDialog({required this.result});

  @override
  State<_SaveCoinDialog> createState() => _SaveCoinDialogState();
}

class _SaveCoinDialogState extends State<_SaveCoinDialog> {
  final _notesController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _locationController = TextEditingController();
  final _tagController = TextEditingController();

  final List<String> _tags = [];
  bool _saveToWishlist = false;
  bool _markAsFavorite = false;
  DateTime? _purchaseDate;
  bool _isSaving = false;

  @override
  void dispose() {
    _notesController.dispose();
    _purchasePriceController.dispose();
    _locationController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  Future<void> _selectPurchaseDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _purchaseDate = date;
      });
    }
  }

  Future<void> _saveCoin() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final collectionProvider = context.read<CollectionProvider>();

      // Create updated coin with metadata
      final updatedCoin = widget.result.copyWith(
        tags: _tags,
        userNotes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        purchasePrice: _purchasePriceController.text.trim().isEmpty
            ? null
            : double.tryParse(_purchasePriceController.text.trim()),
        purchaseDate: _purchaseDate,
        location: _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
        isInWishlist: _saveToWishlist,
        isFavorite: _markAsFavorite,
        addedAt: DateTime.now(),
      );

      // Save to collection
      await collectionProvider.addCoin(updatedCoin);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _saveToWishlist
                  ? '${widget.result.name} added to wishlist!'
                  : '${widget.result.name} saved to collection!'
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'View',
              textColor: Colors.white,
              onPressed: () {
                context.push(_saveToWishlist ? '/wishlist' : '/history');
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving coin: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.bookmark_add, color: Color(0xFFD4AF37)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Save to Collection',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Coin name preview
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFD4AF37).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.monetization_on, color: Color(0xFFD4AF37)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.result.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (widget.result.country != null)
                            Text(
                              widget.result.country!,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Save options
              SwitchListTile(
                title: const Text('Add to Wishlist'),
                subtitle: const Text('Save as a coin you want to acquire'),
                value: _saveToWishlist,
                onChanged: (value) {
                  setState(() {
                    _saveToWishlist = value;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
              SwitchListTile(
                title: const Text('Mark as Favorite'),
                subtitle: const Text('Add to your favorites'),
                value: _markAsFavorite,
                onChanged: (value) {
                  setState(() {
                    _markAsFavorite = value;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
              const Divider(height: 24),

              // Tags section
              Text(
                'Tags',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _tagController,
                      decoration: const InputDecoration(
                        hintText: 'Add tag...',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _addTag(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addTag,
                    color: const Color(0xFFD4AF37),
                  ),
                ],
              ),
              if (_tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: _tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      onDeleted: () => _removeTag(tag),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 16),

              // Notes
              Text(
                'Notes',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  hintText: 'Add your notes about this coin...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Purchase info
              Text(
                'Purchase Information (Optional)',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _purchasePriceController,
                      decoration: const InputDecoration(
                        labelText: 'Purchase Price',
                        prefixText: '\$ ',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _selectPurchaseDate,
                      icon: const Icon(Icons.calendar_today, size: 16),
                      label: Text(
                        _purchaseDate == null
                            ? 'Date'
                            : '${_purchaseDate!.month}/${_purchaseDate!.day}/${_purchaseDate!.year}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Storage Location',
                  hintText: 'e.g., Safe, Binder 1, Display Case',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          onPressed: _isSaving ? null : _saveCoin,
          icon: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Icon(Icons.save),
          label: Text(_isSaving ? 'Saving...' : 'Save'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD4AF37),
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
