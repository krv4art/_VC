// screens/resume_analytics_screen.dart
// Resume analytics and quality score display

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cv_engineer/providers/resume_provider.dart';
import 'package:cv_engineer/services/resume_analytics_service.dart';
import 'package:fl_chart/fl_chart.dart';

class ResumeAnalyticsScreen extends StatelessWidget {
  const ResumeAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resumeProvider = context.watch<ResumeProvider>();
    final currentResume = resumeProvider.currentResume;

    if (currentResume == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Resume Analytics')),
        body: const Center(child: Text('No resume loaded')),
      );
    }

    final analytics = ResumeAnalyticsService.analyzeResume(currentResume);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Overall Score Card
            _buildScoreCard(analytics, theme),

            const SizedBox(height: 16),

            // Section Scores
            _buildSectionScoresCard(analytics, theme),

            const SizedBox(height: 16),

            // Completeness Chart
            _buildCompletenessCard(analytics, theme),

            const SizedBox(height: 16),

            // Strengths
            if (analytics.strengths.isNotEmpty)
              _buildStrengthsCard(analytics, theme),

            if (analytics.strengths.isNotEmpty)
              const SizedBox(height: 16),

            // Improvements
            if (analytics.improvements.isNotEmpty)
              _buildImprovementsCard(analytics, theme),

            const SizedBox(height: 16),

            // Content Stats
            _buildContentStatsCard(analytics, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(ResumeAnalytics analytics, ThemeData theme) {
    final scoreColor = _getScoreColor(analytics.overallScore);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Overall Score',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: analytics.overallScore / 100,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${analytics.overallScore.toInt()}',
                      style: theme.textTheme.displayLarge?.copyWith(
                        color: scoreColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _getScoreLabel(analytics.overallScore),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: scoreColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _getScoreDescription(analytics.overallScore),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionScoresCard(ResumeAnalytics analytics, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Section Scores',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...analytics.sectionScores.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatSectionName(entry.key)),
                        Text(
                          '${entry.value.toInt()}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _getScoreColor(entry.value),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: entry.value / 100,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getScoreColor(entry.value),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletenessCard(ResumeAnalytics analytics, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Section Completeness',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final sections = analytics.completeness.keys.toList();
                          if (value.toInt() >= 0 && value.toInt() < sections.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                _abbreviate(sections[value.toInt()]),
                                style: theme.textTheme.bodySmall,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}%');
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(show: true, horizontalInterval: 25),
                  borderData: FlBorderData(show: false),
                  barGroups: analytics.completeness.entries.toList().asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.value.toDouble(),
                          color: _getScoreColor(entry.value.value.toDouble()),
                          width: 16,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStrengthsCard(ResumeAnalytics analytics, ThemeData theme) {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.star, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Strengths',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...analytics.strengths.map((strength) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle, size: 16, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(child: Text(strength)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildImprovementsCard(ResumeAnalytics analytics, ThemeData theme) {
    return Card(
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'Improvements',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...analytics.improvements.map((improvement) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.arrow_forward, size: 16, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(child: Text(improvement)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildContentStatsCard(ResumeAnalytics analytics, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Content Statistics',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatRow('Word Count', '${analytics.wordCount}', theme),
            _buildStatRow(
              'Readability',
              '${analytics.readabilityScore.toInt()}/100',
              theme,
            ),
            _buildStatRow(
              'Action Verbs',
              analytics.hasActionVerbs ? 'Yes ✓' : 'No ✗',
              theme,
            ),
            _buildStatRow(
              'Quantifiable Achievements',
              analytics.hasQuantifiableAchievements ? 'Yes ✓' : 'No ✗',
              theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.lightGreen;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }

  String _getScoreLabel(double score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    return 'Needs Work';
  }

  String _getScoreDescription(double score) {
    if (score >= 80) {
      return 'Your resume is well-crafted and ready for applications!';
    } else if (score >= 60) {
      return 'Your resume is good, but there\'s room for improvement.';
    } else if (score >= 40) {
      return 'Your resume needs some work to be competitive.';
    } else {
      return 'Your resume needs significant improvements.';
    }
  }

  String _formatSectionName(String key) {
    switch (key) {
      case 'personalInfo':
        return 'Personal Info';
      case 'experience':
        return 'Experience';
      case 'education':
        return 'Education';
      case 'skills':
        return 'Skills';
      case 'languages':
        return 'Languages';
      default:
        return key;
    }
  }

  String _abbreviate(String text) {
    if (text.length <= 8) return text;
    return '${text.substring(0, 6)}..';
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Analytics'),
        content: const SingleChildScrollView(
          child: Text(
            'Resume Analytics provides insights into:\n\n'
            '• Overall quality score (0-100)\n'
            '• Section-by-section analysis\n'
            '• Completeness tracking\n'
            '• Content quality metrics\n'
            '• Actionable improvements\n\n'
            'Aim for a score of 80+ for best results.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
