// widgets/keyword_match_list.dart
// Widget to display keyword matches and misses

import 'package:flutter/material.dart';
import 'package:cv_engineer/models/ats_analysis.dart';

class KeywordMatchList extends StatelessWidget {
  final List<KeywordMatch> keywords;
  final String title;
  final bool showOnlyMissing;

  const KeywordMatchList({
    super.key,
    required this.keywords,
    required this.title,
    this.showOnlyMissing = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayKeywords = showOnlyMissing
        ? keywords.where((k) => !k.isInResume).toList()
        : keywords;

    if (displayKeywords.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                showOnlyMissing
                    ? 'Great! No missing keywords.'
                    : 'No keywords found.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: displayKeywords.map((keyword) {
                return _buildKeywordChip(context, keyword);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeywordChip(BuildContext context, KeywordMatch keyword) {
    final theme = Theme.of(context);

    Color chipColor;
    Color textColor;
    IconData? icon;

    if (keyword.isInResume) {
      chipColor = Colors.green.shade100;
      textColor = Colors.green.shade900;
      icon = Icons.check_circle;
    } else if (keyword.isRequired) {
      chipColor = Colors.red.shade100;
      textColor = Colors.red.shade900;
      icon = Icons.error;
    } else {
      chipColor = Colors.orange.shade100;
      textColor = Colors.orange.shade900;
      icon = Icons.warning;
    }

    return Chip(
      avatar: Icon(icon, size: 18, color: textColor),
      label: Text(
        keyword.keyword,
        style: theme.textTheme.bodySmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: chipColor,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}
