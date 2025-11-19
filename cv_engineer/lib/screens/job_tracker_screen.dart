// screens/job_tracker_screen.dart
// Kanban board for job application tracking

import 'package:flutter/material.dart';
import 'package:cv_engineer/models/job_application.dart';
import 'package:cv_engineer/services/job_tracker_service.dart';

class JobTrackerScreen extends StatefulWidget {
  const JobTrackerScreen({super.key});

  @override
  State<JobTrackerScreen> createState() => _JobTrackerScreenState();
}

class _JobTrackerScreenState extends State<JobTrackerScreen> {
  List<JobApplication> _applications = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  void _loadApplications() {
    // TODO: Load from database
    setState(() {
      _applications = [];
    });
  }

  void _addApplication() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddJobApplicationScreen(
          onSave: (application) {
            setState(() {
              _applications.add(application);
            });
          },
        ),
      ),
    );
  }

  void _updateStatus(JobApplication application, ApplicationStatus newStatus) {
    setState(() {
      final index = _applications.indexWhere((app) => app.id == application.id);
      if (index != -1) {
        _applications[index] = JobTrackerService.updateStatus(application, newStatus);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredApps = _searchQuery.isEmpty
        ? _applications
        : JobTrackerService.searchApplications(_applications, _searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () => _showStatistics(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search jobs...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Kanban board
          Expanded(
            child: _applications.isEmpty
                ? _buildEmptyState(theme)
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildColumn(ApplicationStatus.saved, filteredApps, theme),
                        _buildColumn(ApplicationStatus.applied, filteredApps, theme),
                        _buildColumn(ApplicationStatus.phoneScreen, filteredApps, theme),
                        _buildColumn(ApplicationStatus.interview, filteredApps, theme),
                        _buildColumn(ApplicationStatus.offer, filteredApps, theme),
                      ],
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addApplication,
        icon: const Icon(Icons.add),
        label: const Text('Add Job'),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.work_outline,
            size: 80,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No job applications yet',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Start tracking your job search',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumn(
    ApplicationStatus status,
    List<JobApplication> allApps,
    ThemeData theme,
  ) {
    final apps = JobTrackerService.filterByStatus(allApps, status);

    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getStatusColor(status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(_getStatusIcon(status), color: _getStatusColor(status)),
                const SizedBox(width: 8),
                Text(
                  status.displayName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                CircleAvatar(
                  radius: 12,
                  backgroundColor: _getStatusColor(status),
                  child: Text(
                    '${apps.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Cards
          Expanded(
            child: ListView.builder(
              itemCount: apps.length,
              itemBuilder: (context, index) {
                return _buildJobCard(apps[index], theme);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(JobApplication app, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _showJobDetails(app),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                app.positionTitle,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                app.companyName,
                style: theme.textTheme.bodyMedium,
              ),
              if (app.location != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        app.location!,
                        style: theme.textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              if (app.appliedDate != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Applied ${_formatDate(app.appliedDate!)}',
                  style: theme.textTheme.caption,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.saved:
        return Colors.grey;
      case ApplicationStatus.applied:
        return Colors.blue;
      case ApplicationStatus.phoneScreen:
        return Colors.orange;
      case ApplicationStatus.interview:
        return Colors.purple;
      case ApplicationStatus.offer:
        return Colors.green;
      case ApplicationStatus.rejected:
        return Colors.red;
      case ApplicationStatus.accepted:
        return Colors.teal;
      case ApplicationStatus.declined:
        return Colors.brown;
    }
  }

  IconData _getStatusIcon(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.saved:
        return Icons.bookmark;
      case ApplicationStatus.applied:
        return Icons.send;
      case ApplicationStatus.phoneScreen:
        return Icons.phone;
      case ApplicationStatus.interview:
        return Icons.people;
      case ApplicationStatus.offer:
        return Icons.star;
      case ApplicationStatus.rejected:
        return Icons.close;
      case ApplicationStatus.accepted:
        return Icons.check_circle;
      case ApplicationStatus.declined:
        return Icons.thumb_down;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} weeks ago';
    return '${(diff.inDays / 30).floor()} months ago';
  }

  void _showJobDetails(JobApplication app) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => JobDetailsSheet(
        application: app,
        onStatusChange: (newStatus) => _updateStatus(app, newStatus),
      ),
    );
  }

  void _showStatistics() {
    final stats = JobTrackerService.calculateStatistics(_applications);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Statistics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Applications: ${stats['total']}'),
            Text('Interview Rate: ${stats['interviewRate'].toStringAsFixed(1)}%'),
            Text('Offer Rate: ${stats['offerRate'].toStringAsFixed(1)}%'),
            const SizedBox(height: 12),
            Text('Pending: ${stats['pending']}'),
            Text('Active Interviews: ${stats['active']}'),
            Text('Successful: ${stats['successful']}'),
            Text('Unsuccessful: ${stats['unsuccessful']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

// Add Job Screen (simplified)
class AddJobApplicationScreen extends StatefulWidget {
  final Function(JobApplication) onSave;

  const AddJobApplicationScreen({super.key, required this.onSave});

  @override
  State<AddJobApplicationScreen> createState() => _AddJobApplicationScreenState();
}

class _AddJobApplicationScreenState extends State<AddJobApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _positionController = TextEditingController();
  final _locationController = TextEditingController();
  final _urlController = TextEditingController();

  @override
  void dispose() {
    _companyController.dispose();
    _positionController.dispose();
    _locationController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final application = JobTrackerService.createApplication(
      companyName: _companyController.text,
      positionTitle: _positionController.text,
      location: _locationController.text.isEmpty ? null : _locationController.text,
      jobUrl: _urlController.text.isEmpty ? null : _urlController.text,
    );

    widget.onSave(application);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Job Application'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _companyController,
              decoration: const InputDecoration(
                labelText: 'Company *',
                border: OutlineInputBorder(),
              ),
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _positionController,
              decoration: const InputDecoration(
                labelText: 'Position *',
                border: OutlineInputBorder(),
              ),
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Job URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _save,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

// Job Details Sheet (simplified)
class JobDetailsSheet extends StatelessWidget {
  final JobApplication application;
  final Function(ApplicationStatus) onStatusChange;

  const JobDetailsSheet({
    super.key,
    required this.application,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            controller: scrollController,
            children: [
              Text(
                application.positionTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(application.companyName),
              const SizedBox(height: 16),
              const Text('Change Status:'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ApplicationStatus.values.map((status) {
                  return ChoiceChip(
                    label: Text(status.displayName),
                    selected: application.status == status,
                    onSelected: (selected) {
                      if (selected) {
                        onStatusChange(status);
                        Navigator.of(context).pop();
                      }
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
