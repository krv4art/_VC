import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/cover_letter_provider.dart';
import '../providers/resume_provider.dart';
import '../theme/app_theme.dart';
import '../utils/validators.dart';

class CoverLetterEditorScreen extends StatefulWidget {
  const CoverLetterEditorScreen({super.key});

  @override
  State<CoverLetterEditorScreen> createState() => _CoverLetterEditorScreenState();
}

class _CoverLetterEditorScreenState extends State<CoverLetterEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _senderNameController;
  late TextEditingController _senderEmailController;
  late TextEditingController _senderPhoneController;
  late TextEditingController _senderAddressController;
  late TextEditingController _recipientNameController;
  late TextEditingController _recipientTitleController;
  late TextEditingController _companyNameController;
  late TextEditingController _companyAddressController;
  late TextEditingController _salutationController;
  late TextEditingController _bodyController;
  late TextEditingController _closingController;

  @override
  void initState() {
    super.initState();
    final coverLetter = context.read<CoverLetterProvider>().currentCoverLetter;

    _titleController = TextEditingController(text: coverLetter?.title ?? '');
    _senderNameController = TextEditingController(text: coverLetter?.senderName ?? '');
    _senderEmailController = TextEditingController(text: coverLetter?.senderEmail ?? '');
    _senderPhoneController = TextEditingController(text: coverLetter?.senderPhone ?? '');
    _senderAddressController = TextEditingController(text: coverLetter?.senderAddress ?? '');
    _recipientNameController = TextEditingController(text: coverLetter?.recipientName ?? '');
    _recipientTitleController = TextEditingController(text: coverLetter?.recipientTitle ?? '');
    _companyNameController = TextEditingController(text: coverLetter?.companyName ?? '');
    _companyAddressController = TextEditingController(text: coverLetter?.companyAddress ?? '');
    _salutationController = TextEditingController(text: coverLetter?.salutation ?? 'Dear Hiring Manager');
    _bodyController = TextEditingController(text: coverLetter?.body ?? '');
    _closingController = TextEditingController(text: coverLetter?.closing ?? 'Sincerely');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _senderNameController.dispose();
    _senderEmailController.dispose();
    _senderPhoneController.dispose();
    _senderAddressController.dispose();
    _recipientNameController.dispose();
    _recipientTitleController.dispose();
    _companyNameController.dispose();
    _companyAddressController.dispose();
    _salutationController.dispose();
    _bodyController.dispose();
    _closingController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = context.read<CoverLetterProvider>();
    await provider.updateCoverLetter(
      title: _titleController.text.trim(),
      senderName: _senderNameController.text.trim(),
      senderEmail: _senderEmailController.text.trim(),
      senderPhone: _senderPhoneController.text.trim(),
      senderAddress: _senderAddressController.text.trim(),
      recipientName: _recipientNameController.text.trim(),
      recipientTitle: _recipientTitleController.text.trim(),
      companyName: _companyNameController.text.trim(),
      companyAddress: _companyAddressController.text.trim(),
      salutation: _salutationController.text.trim(),
      body: _bodyController.text.trim(),
      closing: _closingController.text.trim(),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cover letter saved')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final coverLetterProvider = context.watch<CoverLetterProvider>();
    final resumeProvider = context.watch<ResumeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Cover Letter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _save,
            tooltip: 'Save',
          ),
          IconButton(
            icon: const Icon(Icons.visibility),
            onPressed: () {
              _save();
              context.push('/cover-letter-preview');
            },
            tooltip: 'Preview',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Cover Letter Details',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: AppTheme.space16),

              // Custom title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title (Optional)',
                  hintText: 'e.g., Google Software Engineer Application',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => _save(),
              ),
              const SizedBox(height: AppTheme.space16),

              // Associated Resume
              if (resumeProvider.savedResumes.isNotEmpty) ...[
                DropdownButtonFormField<String>(
                  value: coverLetterProvider.currentCoverLetter?.associatedResumeId,
                  decoration: const InputDecoration(
                    labelText: 'Associated Resume (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('None'),
                    ),
                    ...resumeProvider.savedResumes.map((resume) {
                      return DropdownMenuItem<String>(
                        value: resume.id,
                        child: Text(
                          resume.personalInfo.fullName.isNotEmpty
                              ? resume.personalInfo.fullName
                              : 'Untitled Resume',
                        ),
                      );
                    }),
                  ],
                  onChanged: (value) async {
                    await coverLetterProvider.updateCoverLetter(
                      associatedResumeId: value,
                    );
                  },
                ),
                const SizedBox(height: AppTheme.space24),
              ],

              // Sender Information
              Text(
                'Your Information',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: AppTheme.space12),

              TextFormField(
                controller: _senderNameController,
                decoration: const InputDecoration(
                  labelText: 'Your Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => Validators.validateRequired(value, fieldName: 'Name'),
                onChanged: (_) => _save(),
              ),
              const SizedBox(height: AppTheme.space16),

              TextFormField(
                controller: _senderEmailController,
                decoration: const InputDecoration(
                  labelText: 'Your Email *',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: Validators.combine([
                  (value) => Validators.validateRequired(value, fieldName: 'Email'),
                  Validators.validateEmail,
                ]),
                onChanged: (_) => _save(),
              ),
              const SizedBox(height: AppTheme.space16),

              TextFormField(
                controller: _senderPhoneController,
                decoration: const InputDecoration(
                  labelText: 'Your Phone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: Validators.validatePhone,
                onChanged: (_) => _save(),
              ),
              const SizedBox(height: AppTheme.space16),

              TextFormField(
                controller: _senderAddressController,
                decoration: const InputDecoration(
                  labelText: 'Your Address',
                  hintText: '123 Main St, City, State ZIP',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                onChanged: (_) => _save(),
              ),
              const SizedBox(height: AppTheme.space24),

              // Recipient Information
              Text(
                'Recipient Information',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: AppTheme.space12),

              TextFormField(
                controller: _recipientNameController,
                decoration: const InputDecoration(
                  labelText: 'Recipient Name *',
                  hintText: 'Hiring Manager or specific name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => Validators.validateRequired(value, fieldName: 'Recipient name'),
                onChanged: (_) => _save(),
              ),
              const SizedBox(height: AppTheme.space16),

              TextFormField(
                controller: _recipientTitleController,
                decoration: const InputDecoration(
                  labelText: 'Recipient Title',
                  hintText: 'e.g., HR Manager',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => _save(),
              ),
              const SizedBox(height: AppTheme.space16),

              TextFormField(
                controller: _companyNameController,
                decoration: const InputDecoration(
                  labelText: 'Company Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => Validators.validateRequired(value, fieldName: 'Company name'),
                onChanged: (_) => _save(),
              ),
              const SizedBox(height: AppTheme.space16),

              TextFormField(
                controller: _companyAddressController,
                decoration: const InputDecoration(
                  labelText: 'Company Address',
                  hintText: '456 Business Ave, City, State ZIP',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                onChanged: (_) => _save(),
              ),
              const SizedBox(height: AppTheme.space24),

              // Letter Content
              Text(
                'Letter Content',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: AppTheme.space12),

              TextFormField(
                controller: _salutationController,
                decoration: const InputDecoration(
                  labelText: 'Salutation',
                  hintText: 'Dear Hiring Manager',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => _save(),
              ),
              const SizedBox(height: AppTheme.space16),

              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(
                  labelText: 'Letter Body *',
                  hintText: 'Write your cover letter here...\n\nParagraph 1: Introduction\nParagraph 2: Why you\'re a good fit\nParagraph 3: Closing statement',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 15,
                validator: (value) => Validators.validateRequired(value, fieldName: 'Letter body'),
                onChanged: (_) => _save(),
              ),
              const SizedBox(height: AppTheme.space16),

              TextFormField(
                controller: _closingController,
                decoration: const InputDecoration(
                  labelText: 'Closing',
                  hintText: 'Sincerely',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => _save(),
              ),
              const SizedBox(height: AppTheme.space32),

              // Tips Card
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.space16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb, color: Colors.blue[700]),
                          const SizedBox(width: AppTheme.space8),
                          Text(
                            'Tips for a Great Cover Letter',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: Colors.blue[900],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.space12),
                      Text(
                        '• Keep it to one page\n'
                        '• Address the recipient by name if possible\n'
                        '• Highlight specific achievements\n'
                        '• Show enthusiasm for the role\n'
                        '• Proofread carefully',
                        style: TextStyle(
                          color: Colors.blue[900],
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
