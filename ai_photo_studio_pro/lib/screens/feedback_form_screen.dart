import 'package:flutter/material.dart';
import '../services/feedback_service.dart';

/// Feedback and bug report form screen
class FeedbackFormScreen extends StatefulWidget {
  final bool isBugReport;

  const FeedbackFormScreen({
    Key? key,
    this.isBugReport = false,
  }) : super(key: key);

  @override
  State<FeedbackFormScreen> createState() => _FeedbackFormScreenState();
}

class _FeedbackFormScreenState extends State<FeedbackFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stepsController = TextEditingController();
  final _expectedController = TextEditingController();
  final _actualController = TextEditingController();

  // late FeedbackService _feedbackService;

  FeedbackType _selectedType = FeedbackType.general;
  BugSeverity _selectedSeverity = BugSeverity.medium;
  int _rating = 0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _stepsController.dispose();
    _expectedController.dispose();
    _actualController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isBugReport ? 'Report a Bug' : 'Send Feedback'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (!widget.isBugReport) ..._buildFeedbackFields() else ..._buildBugReportFields(),
            const SizedBox(height: 24),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFeedbackFields() {
    return [
      // Type Selector
      const Text(
        'Feedback Type',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      DropdownButtonFormField<FeedbackType>(
        value: _selectedType,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items: FeedbackType.values.map((type) {
          return DropdownMenuItem(
            value: type,
            child: Text(_getFeedbackTypeLabel(type)),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() => _selectedType = value);
          }
        },
      ),
      const SizedBox(height: 20),

      // Rating (for general feedback)
      if (_selectedType == FeedbackType.general || _selectedType == FeedbackType.praise) ...[
        const Text(
          'How would you rate your experience?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _buildRatingStars(),
        const SizedBox(height: 20),
      ],

      // Title
      const Text(
        'Title',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      TextFormField(
        controller: _titleController,
        decoration: const InputDecoration(
          hintText: 'Brief summary of your feedback',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a title';
          }
          return null;
        },
      ),
      const SizedBox(height: 20),

      // Description
      const Text(
        'Description',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      TextFormField(
        controller: _descriptionController,
        decoration: const InputDecoration(
          hintText: 'Tell us more about your feedback',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(16),
        ),
        maxLines: 5,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a description';
          }
          return null;
        },
      ),
    ];
  }

  List<Widget> _buildBugReportFields() {
    return [
      // Severity
      const Text(
        'Severity',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      DropdownButtonFormField<BugSeverity>(
        value: _selectedSeverity,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items: BugSeverity.values.map((severity) {
          return DropdownMenuItem(
            value: severity,
            child: Row(
              children: [
                Icon(
                  _getSeverityIcon(severity),
                  color: _getSeverityColor(severity),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(_getSeverityLabel(severity)),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() => _selectedSeverity = value);
          }
        },
      ),
      const SizedBox(height: 20),

      // Title
      const Text(
        'Bug Title',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      TextFormField(
        controller: _titleController,
        decoration: const InputDecoration(
          hintText: 'Brief description of the bug',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a title';
          }
          return null;
        },
      ),
      const SizedBox(height: 20),

      // Description
      const Text(
        'What happened?',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      TextFormField(
        controller: _descriptionController,
        decoration: const InputDecoration(
          hintText: 'Describe the bug in detail',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(16),
        ),
        maxLines: 4,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a description';
          }
          return null;
        },
      ),
      const SizedBox(height: 20),

      // Steps to reproduce
      const Text(
        'Steps to Reproduce',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      TextFormField(
        controller: _stepsController,
        decoration: const InputDecoration(
          hintText: '1. Open app\n2. Go to gallery\n3. Tap on photo',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(16),
        ),
        maxLines: 4,
      ),
      const SizedBox(height: 20),

      // Expected behavior
      const Text(
        'Expected Behavior',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      TextFormField(
        controller: _expectedController,
        decoration: const InputDecoration(
          hintText: 'What should have happened?',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(16),
        ),
        maxLines: 2,
      ),
      const SizedBox(height: 20),

      // Actual behavior
      const Text(
        'Actual Behavior',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      TextFormField(
        controller: _actualController,
        decoration: const InputDecoration(
          hintText: 'What actually happened?',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(16),
        ),
        maxLines: 2,
      ),
    ];
  }

  Widget _buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          iconSize: 40,
          icon: Icon(
            index < _rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            setState(() => _rating = index + 1);
          },
        );
      }),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isSubmitting ? null : _submitForm,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: _isSubmitting
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Text(
              'Submit',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Initialize service
      // final db = await DatabaseService.instance.database;
      // _feedbackService = FeedbackService(db);

      int? resultId;

      if (widget.isBugReport) {
        // Submit bug report
        // resultId = await _feedbackService.submitBugReport(
        //   title: _titleController.text,
        //   description: _descriptionController.text,
        //   stepsToReproduce: _stepsController.text.isNotEmpty ? _stepsController.text : null,
        //   expectedBehavior: _expectedController.text.isNotEmpty ? _expectedController.text : null,
        //   actualBehavior: _actualController.text.isNotEmpty ? _actualController.text : null,
        //   severity: _selectedSeverity,
        // );
        resultId = 1; // Mock
      } else {
        // Submit feedback
        // resultId = await _feedbackService.submitFeedback(
        //   type: _selectedType,
        //   title: _titleController.text,
        //   description: _descriptionController.text,
        //   rating: _rating > 0 ? _rating : null,
        // );
        resultId = 1; // Mock
      }

      if (resultId != null) {
        _showSuccessDialog();
      } else {
        _showErrorSnackBar('Failed to submit. Please try again.');
      }
    } catch (e) {
      debugPrint('Error submitting form: $e');
      _showErrorSnackBar('An error occurred. Please try again.');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              widget.isBugReport ? 'Bug Report Submitted!' : 'Feedback Submitted!',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Thank you for helping us improve!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close form screen
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  String _getFeedbackTypeLabel(FeedbackType type) {
    switch (type) {
      case FeedbackType.general:
        return 'General Feedback';
      case FeedbackType.feature_request:
        return 'Feature Request';
      case FeedbackType.improvement:
        return 'Improvement Suggestion';
      case FeedbackType.complaint:
        return 'Complaint';
      case FeedbackType.praise:
        return 'Praise';
    }
  }

  String _getSeverityLabel(BugSeverity severity) {
    switch (severity) {
      case BugSeverity.low:
        return 'Low - Minor issue';
      case BugSeverity.medium:
        return 'Medium - Noticeable issue';
      case BugSeverity.high:
        return 'High - Major problem';
      case BugSeverity.critical:
        return 'Critical - App unusable';
    }
  }

  Color _getSeverityColor(BugSeverity severity) {
    switch (severity) {
      case BugSeverity.low:
        return Colors.blue;
      case BugSeverity.medium:
        return Colors.orange;
      case BugSeverity.high:
        return Colors.deepOrange;
      case BugSeverity.critical:
        return Colors.red;
    }
  }

  IconData _getSeverityIcon(BugSeverity severity) {
    switch (severity) {
      case BugSeverity.low:
        return Icons.info;
      case BugSeverity.medium:
        return Icons.warning;
      case BugSeverity.high:
        return Icons.error;
      case BugSeverity.critical:
        return Icons.dangerous;
    }
  }
}
