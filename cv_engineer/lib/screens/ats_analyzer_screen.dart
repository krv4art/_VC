// screens/ats_analyzer_screen.dart
// Screen for ATS analysis with job description input

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cv_engineer/models/ats_analysis.dart';
import 'package:cv_engineer/models/job_description.dart';
import 'package:cv_engineer/providers/resume_provider.dart';
import 'package:cv_engineer/services/ats_service.dart';
import 'package:cv_engineer/screens/ats_checker_screen.dart';
import 'package:uuid/uuid.dart';

class ATSAnalyzerScreen extends StatefulWidget {
  const ATSAnalyzerScreen({super.key});

  @override
  State<ATSAnalyzerScreen> createState() => _ATSAnalyzerScreenState();
}

class _ATSAnalyzerScreenState extends State<ATSAnalyzerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _jobDescriptionController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _companyNameController = TextEditingController();
  bool _isAnalyzing = false;

  @override
  void dispose() {
    _jobDescriptionController.dispose();
    _jobTitleController.dispose();
    _companyNameController.dispose();
    super.dispose();
  }

  Future<void> _analyzeResume() async {
    if (!_formKey.currentState!.validate()) return;

    final resumeProvider = context.read<ResumeProvider>();
    final currentResume = resumeProvider.currentResume;

    if (currentResume == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No resume loaded')),
        );
      }
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

    try {
      // Create job description
      final jobDescription = JobDescription.fromRawText(
        id: const Uuid().v4(),
        rawText: _jobDescriptionController.text,
      ).copyWith(
        jobTitle: _jobTitleController.text,
        companyName: _companyNameController.text,
      );

      // Analyze resume
      final analysis = await ATSService.analyzeResume(
        resume: currentResume,
        jobDescription: jobDescription,
      );

      if (mounted) {
        // Navigate to results screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ATSResultsScreen(analysis: analysis),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Analysis failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ATS Checker'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Card(
                color: theme.colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.analytics,
                        size: 48,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'ATS Compatibility Checker',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Analyze your resume against a job description to see how well it matches ATS requirements',
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Job Title (optional)
              TextFormField(
                controller: _jobTitleController,
                decoration: const InputDecoration(
                  labelText: 'Job Title (Optional)',
                  hintText: 'e.g., Senior Software Engineer',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.work),
                ),
              ),

              const SizedBox(height: 16),

              // Company Name (optional)
              TextFormField(
                controller: _companyNameController,
                decoration: const InputDecoration(
                  labelText: 'Company Name (Optional)',
                  hintText: 'e.g., Google',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                ),
              ),

              const SizedBox(height: 16),

              // Job Description
              TextFormField(
                controller: _jobDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Job Description *',
                  hintText: 'Paste the full job description here...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 15,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a job description';
                  }
                  if (value.trim().length < 50) {
                    return 'Job description too short (min 50 characters)';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Info card
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Copy and paste the complete job description from the job posting for best results.',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Analyze button
              ElevatedButton.icon(
                onPressed: _isAnalyzing ? null : _analyzeResume,
                icon: _isAnalyzing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.analytics),
                label: Text(
                  _isAnalyzing ? 'Analyzing...' : 'Analyze Resume',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: theme.textTheme.titleMedium,
                ),
              ),

              const SizedBox(height: 16),

              // Tips
              ExpansionTile(
                title: const Text('Tips for Better Results'),
                leading: const Icon(Icons.lightbulb_outline),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTipItem('Include the complete job description with requirements and qualifications'),
                        _buildTipItem('Make sure your resume is complete before analyzing'),
                        _buildTipItem('Review the keyword matches and add missing skills to your resume'),
                        _buildTipItem('Use action verbs and quantifiable achievements in your resume'),
                        _buildTipItem('Keep your resume format simple and ATS-friendly'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// Results Screen
class ATSResultsScreen extends StatelessWidget {
  final ATSAnalysis analysis;

  const ATSResultsScreen({super.key, required this.analysis});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ATS Analysis Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Score Card
            ATSScoreCard(analysis: analysis),

            const SizedBox(height: 16),

            // Critical Issues
            if (analysis.criticalIssues.isNotEmpty)
              _buildIssuesCard(
                theme,
                'Critical Issues',
                analysis.criticalIssues,
                Colors.red,
                Icons.error,
              ),

            const SizedBox(height: 16),

            // Matched Keywords
            KeywordMatchList(
              keywords: analysis.matchedKeywords.take(20).toList(),
              title: 'Matched Keywords (${analysis.matchedKeywords.length})',
            ),

            const SizedBox(height: 16),

            // Missing Keywords
            if (analysis.missingKeywords.isNotEmpty)
              KeywordMatchList(
                keywords: analysis.missingKeywords,
                title: 'Missing Keywords (${analysis.missingKeywords.length})',
                showOnlyMissing: true,
              ),

            const SizedBox(height: 16),

            // Recommendations
            _buildRecommendationsCard(theme),

            const SizedBox(height: 16),

            // Strengths
            if (analysis.strengthAreas.isNotEmpty)
              _buildStrengthsCard(theme),

            const SizedBox(height: 24),

            // Action button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.edit),
              label: const Text('Improve Resume'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIssuesCard(
    ThemeData theme,
    String title,
    List<String> issues,
    Color color,
    IconData icon,
  ) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...issues.map((issue) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.warning, size: 16, color: color),
                      const SizedBox(width: 8),
                      Expanded(child: Text(issue)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Recommendations',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...analysis.recommendations.map((rec) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.arrow_right, size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text(rec)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildStrengthsCard(ThemeData theme) {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
            ...analysis.strengthAreas.map((strength) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle, size: 16, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(child: Text(strength)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

// Import ATSScoreCard and KeywordMatchList
import 'package:cv_engineer/screens/ats_checker_screen.dart';
import 'package:cv_engineer/widgets/keyword_match_list.dart';
