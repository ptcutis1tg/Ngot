import 'package:flutter/material.dart';
import 'package:flutter_application_1/firstscreen/widget/settings/personal_information_editor.dart';
import 'package:flutter_application_1/providers/backup_provider.dart';
import 'package:flutter_application_1/providers/transaction_provider.dart';
import 'package:flutter_application_1/providers/userprofileprovider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 1. Profile Header
            Consumer<UserProfileProvider>(
              builder: (context, userProfile, _) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.white,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: _avatarProvider(userProfile.userAvatar),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userProfile.userName.isNotEmpty
                                  ? userProfile.userName
                                  : 'Guest',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              userProfile.userEmail.isNotEmpty
                                  ? userProfile.userEmail
                                  : 'No email',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            // 2. Settings Sections
            _buildSectionTitle('Account Settings'),
            _buildSettingItem(
              context,
              Icons.person_outline,
              'Personal Information',
              null,
              onTap: () => _openPersonalInformationEditor(context),
            ),
            _buildSettingItem(
              context,
              Icons.account_balance_outlined,
              'Bank Accounts',
              '3 linked',
            ),

            const SizedBox(height: 20),

            _buildSectionTitle('Security & App'),
            _buildSettingItem(context, Icons.lock_outline, 'Change Password', null),
            _buildSettingItem(context, Icons.fingerprint, 'Biometric Lock', 'Enabled'),
            _buildSettingItem(context, Icons.notifications_none, 'Notifications', 'On'),
            _buildSettingItem(context, Icons.dark_mode_outlined, 'Dark Mode', 'Off'),

            const SizedBox(height: 20),

            _buildSectionTitle('Support'),
            _buildSettingItem(context, Icons.help_outline, 'Help Center', null),
            _buildSettingItem(context, Icons.info_outline, 'About App', 'v1.0.0'),
            const SizedBox(height: 20),

            _buildSectionTitle('Local & Backup'),
            Consumer<BackupProvider>(
              builder: (context, backupProvider, _) {
                final lastBackupText = backupProvider.lastBackupAt == null
                    ? 'Never'
                    : DateFormat('yyyy-MM-dd HH:mm')
                        .format(backupProvider.lastBackupAt!);
                return Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: SwitchListTile(
                        title: const Text('Enable server backup'),
                        value: backupProvider.enabled,
                        onChanged: backupProvider.setEnabled,
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        leading:
                            const Icon(Icons.cloud_upload_outlined, color: Colors.black87),
                        title: const Text('Backup endpoint'),
                        subtitle: Text(
                          backupProvider.serverUrl.isEmpty
                              ? 'Not configured'
                              : backupProvider.serverUrl,
                        ),
                        trailing:
                            const Icon(Icons.chevron_right, color: Colors.grey),
                        onTap: () => _showEndpointDialog(context, backupProvider),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        leading: const Icon(Icons.history, color: Colors.black87),
                        title: const Text('Last backup'),
                        subtitle: Text('$lastBackupText - ${backupProvider.lastBackupStatus}'),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      color: Colors.white,
                      child: ElevatedButton.icon(
                        onPressed: backupProvider.isBackingUp
                            ? null
                            : () async {
                                final ok = await context
                                    .read<BackupProvider>()
                                    .backupNow(
                                      userProvider:
                                          context.read<UserProfileProvider>(),
                                      transactionProvider:
                                          context.read<TransactionProvider>(),
                                    );
                                if (!context.mounted) return;
                                final messenger = ScaffoldMessenger.of(context);
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      ok
                                          ? 'Sao lưu thành công'
                                          : 'Sao lưu thất bại, kiểm tra cấu hình',
                                    ),
                                  ),
                                );
                              },
                        icon: backupProvider.isBackingUp
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.backup_outlined),
                        label: const Text('Backup now'),
                      ),
                    ),
                  ],
                );
              },
            ),

            // 3. Logout Button
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Logout',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Widget tiêu đề từng phần
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }

  // Widget từng dòng cài đặt
  Widget _buildSettingItem(
    BuildContext context,
    IconData icon,
    String title,
    String? trailingText, {
    VoidCallback? onTap,
  }) {
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: Colors.black87),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailingText != null)
              Text(trailingText, style: const TextStyle(color: Colors.grey)),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  ImageProvider _avatarProvider(String avatar) {
    if (avatar.startsWith('http://') || avatar.startsWith('https://')) {
      return NetworkImage(avatar);
    }
    return AssetImage(avatar);
  }

  Future<void> _showEndpointDialog(
    BuildContext context,
    BackupProvider backupProvider,
  ) async {
    final controller = TextEditingController(text: backupProvider.serverUrl);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Backup endpoint'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'https://your-server.com/backup',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await backupProvider.setServerUrl(controller.text);
                if (!dialogContext.mounted) return;
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openPersonalInformationEditor(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PersonalInformationEditor(),
    );
  }
}
