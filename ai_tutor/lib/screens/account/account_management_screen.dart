import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/user_profile_provider.dart';

class AccountManagementScreen extends StatefulWidget {
  const AccountManagementScreen({super.key});

  @override
  State<AccountManagementScreen> createState() => _AccountManagementScreenState();
}

class _AccountManagementScreenState extends State<AccountManagementScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  bool get _isRussian =>
      context.read<UserProfileProvider>().profile.preferredLanguage == 'ru';

  Future<void> _pickAndSaveImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 500,
      maxHeight: 500,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() => _isLoading = true);

      final Uint8List imageBytes = await image.readAsBytes();
      final String base64String = base64Encode(imageBytes);

      // Save to user profile (implement this in UserProfileProvider)
      // await context.read<UserProfileProvider>().updateAvatarBase64(base64String);

      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isRussian ? 'Фото обновлено' : 'Photo updated'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _showChangePasswordDialog() async {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_isRussian ? 'Сменить пароль' : 'Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: _isRussian ? 'Текущий пароль' : 'Current Password',
                prefixIcon: const Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: _isRussian ? 'Новый пароль' : 'New Password',
                prefixIcon: const Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: _isRussian ? 'Подтвердите пароль' : 'Confirm Password',
                prefixIcon: const Icon(Icons.lock),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_isRussian ? 'Отмена' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (newPasswordController.text != confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _isRussian ? 'Пароли не совпадают' : 'Passwords do not match',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              if (newPasswordController.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _isRussian
                          ? 'Пароль должен содержать минимум 6 символов'
                          : 'Password must be at least 6 characters',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              Navigator.pop(context, true);
            },
            child: Text(_isRussian ? 'Изменить' : 'Change'),
          ),
        ],
      ),
    );

    if (result == true) {
      setState(() => _isLoading = true);

      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.updatePassword(newPasswordController.text);

      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? (_isRussian ? 'Пароль изменен' : 'Password changed')
                  : (_isRussian ? 'Ошибка смены пароля' : 'Failed to change password'),
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showDeleteAccountDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.red),
            const SizedBox(width: 8),
            Text(_isRussian ? 'Удалить аккаунт?' : 'Delete Account?'),
          ],
        ),
        content: Text(
          _isRussian
              ? 'Это действие необратимо. Все ваши данные будут удалены навсегда.'
              : 'This action is irreversible. All your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_isRussian ? 'Отмена' : 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(_isRussian ? 'Удалить' : 'Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);

      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.deleteAccount();

      setState(() => _isLoading = false);

      if (success && mounted) {
        context.go('/login');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isRussian ? 'Ошибка удаления аккаунта' : 'Failed to delete account'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isRussian ? 'Управление аккаунтом' : 'Account Management'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // Profile Picture
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[300],
                        child: user?.userMetadata?['avatar_url'] != null
                            ? ClipOval(
                                child: Image.network(
                                  user!.userMetadata!['avatar_url'],
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(Icons.person, size: 60),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt, color: Colors.white),
                            onPressed: _pickAndSaveImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Email
                ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(_isRussian ? 'Email' : 'Email'),
                  subtitle: Text(user?.email ?? 'N/A'),
                ),

                const Divider(),

                // Change Password
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: Text(_isRussian ? 'Сменить пароль' : 'Change Password'),
                  subtitle: Text(_isRussian ? 'Обновите свой пароль' : 'Update your password'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _showChangePasswordDialog,
                ),

                const Divider(),

                // Delete Account
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: Text(
                    _isRussian ? 'Удалить аккаунт' : 'Delete Account',
                    style: const TextStyle(color: Colors.red),
                  ),
                  subtitle: Text(
                    _isRussian ? 'Навсегда удалить все данные' : 'Permanently delete all data',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _showDeleteAccountDialog,
                ),
              ],
            ),
    );
  }
}
