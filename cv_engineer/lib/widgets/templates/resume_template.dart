import 'package:flutter/material.dart';
import '../../models/resume.dart';

/// Base class for all resume templates
abstract class ResumeTemplate extends StatelessWidget {
  final Resume resume;

  const ResumeTemplate({
    super.key,
    required this.resume,
  });

  /// Template identifier
  String get templateId;

  /// Template name for display
  String get templateName;

  /// Template description
  String get templateDescription;

  /// Primary color for the template
  Color get primaryColor;

  /// Build the resume content
  @override
  Widget build(BuildContext context);

  /// Helper method to format dates
  String formatDate(DateTime date) {
    return '${date.month}/${date.year}';
  }

  /// Helper method to calculate duration
  String getDuration(DateTime start, DateTime? end) {
    final endDate = end ?? DateTime.now();
    final years = endDate.year - start.year;
    final months = endDate.month - start.month;

    final totalMonths = years * 12 + months;
    if (totalMonths < 12) {
      return '$totalMonths mo';
    }

    final displayYears = totalMonths ~/ 12;
    final displayMonths = totalMonths % 12;

    if (displayMonths == 0) {
      return '$displayYears yr';
    }
    return '$displayYears yr $displayMonths mo';
  }
}
