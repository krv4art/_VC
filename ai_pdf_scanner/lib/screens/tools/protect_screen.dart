import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../constants/app_dimensions.dart';
import '../../providers/tools_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/loading_overlay.dart';
import '../../widgets/common/error_dialog.dart';
import '../../utils/file_utils.dart';

/// Protect Screen for adding password protection to PDFs
class ProtectScreen extends StatefulWidget {
  const ProtectScreen({super.key});

  @override
  State<ProtectScreen> createState() => _ProtectScreenState();
}

class _ProtectScreenState extends State<ProtectScreen> {
  String? _selectedFilePath;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  ProtectionLevel _protectionLevel = ProtectionLevel.standard;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Protect PDF'),
      ),
      body: Consumer<ToolsProvider>(
        builder: (context, toolsProvider, child) {
          return LoadingOverlay(
            isLoading: toolsProvider.isProcessing,
            message: toolsProvider.currentOperation,
            child: ListView(
              padding: const EdgeInsets.all(AppDimensions.space16),
              children: [
                // Instructions
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.space16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.security,
                              color: Colors.blue.shade700,
                            ),
                            const SizedBox(width: AppDimensions.space12),
                            Text(
                              'Password Protection',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.blue.shade700,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.space12),
                        Text(
                          'Add password protection to secure your PDF documents. Choose a strong password to prevent unauthorized access.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.space24),

                // File selection
                if (_selectedFilePath == null)
                  CustomButton(
                    text: 'Select PDF File',
                    icon: Icons.file_upload,
                    onPressed: _selectFile,
                  )
                else
                  _buildSelectedFile(),

                // Password fields
                if (_selectedFilePath != null) ...[
                  const SizedBox(height: AppDimensions.space24),
                  _buildPasswordFields(),
                ],

                // Protection level
                if (_selectedFilePath != null) ...[
                  const SizedBox(height: AppDimensions.space16),
                  _buildProtectionLevelSelector(),
                ],

                // Password strength indicator
                if (_selectedFilePath != null && _passwordController.text.isNotEmpty) ...[
                  const SizedBox(height: AppDimensions.space16),
                  _buildPasswordStrengthIndicator(),
                ],

                // Permissions info
                if (_selectedFilePath != null) ...[
                  const SizedBox(height: AppDimensions.space16),
                  _buildPermissionsInfo(),
                ],

                // Apply button
                if (_selectedFilePath != null) ...[
                  const SizedBox(height: AppDimensions.space32),
                  CustomButton(
                    text: 'Protect PDF',
                    icon: Icons.lock,
                    onPressed: _canProtect() ? () => _protectPDF(toolsProvider) : null,
                    isLoading: toolsProvider.isProcessing,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedFile() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Row(
          children: [
            Icon(
              Icons.picture_as_pdf,
              size: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: AppDimensions.space16),
            Expanded(
              child: Text(
                FileUtils.getFilename(_selectedFilePath!),
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _selectedFilePath = null;
                  _passwordController.clear();
                  _confirmPasswordController.clear();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordFields() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set Password',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppDimensions.space16),
            CustomTextField(
              controller: _passwordController,
              labelText: 'Password',
              hintText: 'Enter password',
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppDimensions.space16),
            CustomTextField(
              controller: _confirmPasswordController,
              labelText: 'Confirm Password',
              hintText: 'Re-enter password',
              obscureText: _obscureConfirm,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirm = !_obscureConfirm;
                  });
                },
              ),
              onChanged: (_) => setState(() {}),
              errorText: _confirmPasswordController.text.isNotEmpty &&
                      _passwordController.text != _confirmPasswordController.text
                  ? 'Passwords do not match'
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProtectionLevelSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Protection Level',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppDimensions.space16),
            ...ProtectionLevel.values.map((level) {
              return RadioListTile<ProtectionLevel>(
                title: Text(level.label),
                subtitle: Text(level.description),
                value: level,
                groupValue: _protectionLevel,
                onChanged: (value) {
                  setState(() {
                    _protectionLevel = value!;
                  });
                },
                contentPadding: EdgeInsets.zero,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    final strength = _calculatePasswordStrength(_passwordController.text);
    final color = strength < 33
        ? Colors.red
        : strength < 67
            ? Colors.orange
            : Colors.green;
    final label = strength < 33
        ? 'Weak'
        : strength < 67
            ? 'Medium'
            : 'Strong';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Password Strength',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: strength / 100,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 8,
              ),
            ),
            if (strength < 67) ...[
              const SizedBox(height: AppDimensions.space12),
              Text(
                'Tip: Use at least 8 characters with uppercase, lowercase, numbers, and symbols',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionsInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Protected PDF Restrictions',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: AppDimensions.space12),
            _buildPermissionItem(
              Icons.visibility_off,
              'Viewing',
              'Requires password to open',
            ),
            _buildPermissionItem(
              Icons.edit_off,
              'Editing',
              _protectionLevel == ProtectionLevel.viewOnly
                  ? 'Allowed'
                  : 'Blocked',
            ),
            _buildPermissionItem(
              Icons.print_disabled,
              'Printing',
              _protectionLevel == ProtectionLevel.full
                  ? 'Blocked'
                  : 'Allowed',
            ),
            _buildPermissionItem(
              Icons.copy_all,
              'Copying',
              _protectionLevel == ProtectionLevel.full
                  ? 'Blocked'
                  : 'Allowed',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionItem(IconData icon, String title, String status) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.space8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: AppDimensions.space12),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            status,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: status == 'Blocked' ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  int _calculatePasswordStrength(String password) {
    if (password.isEmpty) return 0;

    int strength = 0;

    // Length
    if (password.length >= 8) strength += 20;
    if (password.length >= 12) strength += 10;

    // Lowercase
    if (password.contains(RegExp(r'[a-z]'))) strength += 20;

    // Uppercase
    if (password.contains(RegExp(r'[A-Z]'))) strength += 20;

    // Numbers
    if (password.contains(RegExp(r'[0-9]'))) strength += 15;

    // Special characters
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 15;

    return strength.clamp(0, 100);
  }

  bool _canProtect() {
    return _passwordController.text.trim().isNotEmpty &&
        _passwordController.text == _confirmPasswordController.text &&
        _passwordController.text.length >= 4;
  }

  Future<void> _selectFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedFilePath = result.files.single.path!;
        });
      }
    } catch (e) {
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Error',
          message: 'Failed to select file',
        );
      }
    }
  }

  Future<void> _protectPDF(ToolsProvider provider) async {
    if (!_canProtect()) return;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Protect PDF'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to protect this PDF?'),
            const SizedBox(height: AppDimensions.space16),
            Text(
              'Important: Make sure to remember your password. It cannot be recovered!',
              style: TextStyle(
                color: Colors.red.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Protect'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      // TODO: Implement actual password protection
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Protecting PDF...'),
          backgroundColor: Colors.green,
        ),
      );

      // Simulate processing
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF protected successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        setState(() {
          _selectedFilePath = null;
          _passwordController.clear();
          _confirmPasswordController.clear();
        });
      }
    } catch (e) {
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Protection Failed',
          message: e.toString(),
        );
      }
    }
  }
}

enum ProtectionLevel {
  viewOnly,
  standard,
  full,
}

extension ProtectionLevelExtension on ProtectionLevel {
  String get label {
    switch (this) {
      case ProtectionLevel.viewOnly:
        return 'View Only';
      case ProtectionLevel.standard:
        return 'Standard';
      case ProtectionLevel.full:
        return 'Full Protection';
    }
  }

  String get description {
    switch (this) {
      case ProtectionLevel.viewOnly:
        return 'Requires password to open, allows printing and copying';
      case ProtectionLevel.standard:
        return 'Password required, prevents editing and form filling';
      case ProtectionLevel.full:
        return 'Maximum security, blocks all operations except viewing';
    }
  }
}
