// widgets/ats_score_card.dart
// Widget to display ATS score with gauge

import 'package:flutter/material.dart';
import 'package:cv_engineer/models/ats_analysis.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ATSScoreCard extends StatelessWidget {
  final ATSAnalysis analysis;

  const ATSScoreCard({
    super.key,
    required this.analysis,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scoreColor = _getScoreColor(analysis.overallScore);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'ATS Compatibility Score',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Score Gauge
            SizedBox(
              height: 200,
              child: SfRadialGauge(
                axes: [
                  RadialAxis(
                    minimum: 0,
                    maximum: 100,
                    ranges: [
                      GaugeRange(
                        startValue: 0,
                        endValue: 40,
                        color: Colors.red,
                        startWidth: 10,
                        endWidth: 10,
                      ),
                      GaugeRange(
                        startValue: 40,
                        endValue: 60,
                        color: Colors.orange,
                        startWidth: 10,
                        endWidth: 10,
                      ),
                      GaugeRange(
                        startValue: 60,
                        endValue: 80,
                        color: Colors.lightGreen,
                        startWidth: 10,
                        endWidth: 10,
                      ),
                      GaugeRange(
                        startValue: 80,
                        endValue: 100,
                        color: Colors.green,
                        startWidth: 10,
                        endWidth: 10,
                      ),
                    ],
                    pointers: [
                      NeedlePointer(
                        value: analysis.overallScore,
                        needleColor: scoreColor,
                      ),
                    ],
                    annotations: [
                      GaugeAnnotation(
                        widget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${analysis.overallScore.toInt()}',
                              style: theme.textTheme.displayLarge?.copyWith(
                                color: scoreColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              analysis.getScoreLevel(),
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: scoreColor,
                              ),
                            ),
                          ],
                        ),
                        angle: 90,
                        positionFactor: 0.5,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Score breakdown
            _buildScoreBreakdown(theme),

            const SizedBox(height: 16),

            // Keyword match percentage
            LinearProgressIndicator(
              value: analysis.getKeywordMatchPercentage() / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Text(
              '${analysis.matchedKeywordsCount}/${analysis.totalKeywords} keywords matched (${analysis.getKeywordMatchPercentage().toStringAsFixed(1)}%)',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBreakdown(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildScoreItem(
          theme,
          'Keywords',
          analysis.keywordMatchScore,
          Icons.key,
        ),
        _buildScoreItem(
          theme,
          'Format',
          analysis.formatScore,
          Icons.format_align_left,
        ),
        _buildScoreItem(
          theme,
          'Content',
          analysis.contentScore,
          Icons.article,
        ),
      ],
    );
  }

  Widget _buildScoreItem(
    ThemeData theme,
    String label,
    double score,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, size: 32, color: _getScoreColor(score)),
        const SizedBox(height: 4),
        Text(
          '${score.toInt()}',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: _getScoreColor(score),
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.lightGreen;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }
}
