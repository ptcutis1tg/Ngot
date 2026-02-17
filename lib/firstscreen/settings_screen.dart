import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firstscreen/widget/settings/personal_information_editor.dart';
import 'package:flutter_application_1/providers/app_settings_provider.dart';
import 'package:flutter_application_1/providers/backup_provider.dart';
import 'package:flutter_application_1/providers/currency_provider.dart';
import 'package:flutter_application_1/providers/transaction_provider.dart';
import 'package:flutter_application_1/providers/userprofileprovider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: _SettingsAppBar(),
      body: _SettingsBody(),
    );
  }
}

class _SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _SettingsAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(title: const Text('Settings'));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SettingsBody extends StatefulWidget {
  const _SettingsBody();

  @override
  State<_SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<_SettingsBody> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const _ProfileHeader(),
          const SizedBox(height: 25),
          const _SectionTitle('Account Settings'),
          _AccountSection(
            onEditPersonal: _openPersonalInformationEditor,
            onOpenBankAccounts: _showBankAccountsDialog,
            onOpenCurrency: _showCurrencyDialog,
          ),
          const SizedBox(height: 20),
          _SecuritySection(onChangePassword: _showChangePasswordDialog),
          const SizedBox(height: 20),
          _SupportSection(
            onHelp: _showHelpDialog,
            onAbout: _showAboutDialog,
          ),
          const SizedBox(height: 20),
          _BackupSection(onEditEndpoint: _showEndpointDialog),
          const SizedBox(height: 30),
          const _LogoutSection(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Future<void> _openPersonalInformationEditor() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PersonalInformationEditor(),
    );
  }

  Future<void> _showCurrencyDialog(CurrencyProvider currencyProvider) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Select currency'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: CurrencyProvider.supportedCurrencies
                    .map(
                      (currency) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('${currency.code} (${currency.symbol})'),
                        subtitle: Text(currency.displayName),
                        trailing: currency.code == currencyProvider.selected.code
                            ? const Icon(Icons.check, color: Color(0xFF2ECC71))
                            : null,
                        onTap: () async {
                          await currencyProvider.setCurrencyByCode(currency.code);
                          if (!dialogContext.mounted) return;
                          Navigator.of(dialogContext).pop();
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEndpointDialog(BackupProvider backupProvider) async {
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

  Future<void> _showChangePasswordDialog() async {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Change password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Current password'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: newController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'New password'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: confirmController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Confirm password'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final appSettings = context.read<AppSettingsProvider>();
                final error = await appSettings.changePassword(
                  currentPassword: currentController.text,
                  newPassword: newController.text,
                  confirmPassword: confirmController.text,
                );
                if (!dialogContext.mounted) return;
                if (!mounted) return;
                if (error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error)),
                  );
                  return;
                }
                Navigator.of(dialogContext).pop();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password updated')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showBankAccountsDialog(AppSettingsProvider appSettings) async {
    int count = appSettings.bankAccountsCount;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: const Text('Bank accounts'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Linked accounts: $count'),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: count > 0
                            ? () => setDialogState(() => count--)
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () => setDialogState(() => count++),
                        icon: const Icon(Icons.add),
                        label: const Text('Add account'),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Close'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await appSettings.setBankAccountsCount(count);
                    if (!dialogContext.mounted) return;
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showHelpDialog() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Help center'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('If you need support:'),
            SizedBox(height: 8),
            Text('- Email: support@dailyexpense.app'),
            Text('- Hotline: +84 123 456 789'),
            Text('- Working time: 08:00 - 17:00'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _showAboutDialog() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => const AboutDialog(
        applicationName: 'Daily Expense Diary',
        applicationVersion: '1.0.0',
        applicationLegalese: 'Personal expense tracking app',
      ),
    );
  }
}

class _ProfileHeader extends StatefulWidget {
  const _ProfileHeader();

  @override
  State<_ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<_ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
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
                      userProfile.userName.isNotEmpty ? userProfile.userName : 'Guest',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      userProfile.userEmail.isNotEmpty ? userProfile.userEmail : 'No email',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AccountSection extends StatefulWidget {
  final Future<void> Function() onEditPersonal;
  final Future<void> Function(AppSettingsProvider) onOpenBankAccounts;
  final Future<void> Function(CurrencyProvider) onOpenCurrency;

  const _AccountSection({
    required this.onEditPersonal,
    required this.onOpenBankAccounts,
    required this.onOpenCurrency,
  });

  @override
  State<_AccountSection> createState() => _AccountSectionState();
}

class _AccountSectionState extends State<_AccountSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SettingTile(
          icon: Icons.person_outline,
          title: 'Personal information',
          trailingText: null,
          onTap: widget.onEditPersonal,
        ),
        Consumer<AppSettingsProvider>(
          builder: (context, appSettings, _) => _SettingTile(
            icon: Icons.account_balance_outlined,
            title: 'Bank accounts',
            trailingText: '${appSettings.bankAccountsCount} linked',
            onTap: () => widget.onOpenBankAccounts(appSettings),
          ),
        ),
        Consumer<CurrencyProvider>(
          builder: (context, currencyProvider, _) => _SettingTile(
            icon: Icons.currency_exchange,
            title: 'Currency',
            trailingText:
                '${currencyProvider.selected.code} (${currencyProvider.selected.symbol})',
            onTap: () => widget.onOpenCurrency(currencyProvider),
          ),
        ),
      ],
    );
  }
}

class _SecuritySection extends StatefulWidget {
  final Future<void> Function() onChangePassword;

  const _SecuritySection({required this.onChangePassword});

  @override
  State<_SecuritySection> createState() => _SecuritySectionState();
}

class _SecuritySectionState extends State<_SecuritySection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _SectionTitle('Security & App'),
        _SettingTile(
          icon: Icons.lock_outline,
          title: 'Change password',
          trailingText: null,
          onTap: widget.onChangePassword,
        ),
        Consumer<AppSettingsProvider>(
          builder: (context, appSettings, _) => _SettingSwitchTile(
            icon: Icons.fingerprint,
            title: 'Biometric lock',
            value: appSettings.biometricEnabled,
            onChanged: appSettings.setBiometricEnabled,
          ),
        ),
        Consumer<AppSettingsProvider>(
          builder: (context, appSettings, _) => _SettingSwitchTile(
            icon: Icons.notifications_none,
            title: 'Notifications',
            value: appSettings.notificationsEnabled,
            onChanged: appSettings.setNotificationsEnabled,
          ),
        ),
        Consumer<AppSettingsProvider>(
          builder: (context, appSettings, _) => _SettingSwitchTile(
            icon: Icons.dark_mode_outlined,
            title: 'Dark mode',
            value: appSettings.darkMode,
            onChanged: appSettings.setDarkMode,
          ),
        ),
      ],
    );
  }
}

class _SupportSection extends StatefulWidget {
  final Future<void> Function() onHelp;
  final Future<void> Function() onAbout;

  const _SupportSection({required this.onHelp, required this.onAbout});

  @override
  State<_SupportSection> createState() => _SupportSectionState();
}

class _SupportSectionState extends State<_SupportSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _SectionTitle('Support'),
        _SettingTile(
          icon: Icons.help_outline,
          title: 'Help center',
          trailingText: null,
          onTap: widget.onHelp,
        ),
        _SettingTile(
          icon: Icons.info_outline,
          title: 'About app',
          trailingText: 'v1.0.0',
          onTap: widget.onAbout,
        ),
      ],
    );
  }
}

class _BackupSection extends StatefulWidget {
  final Future<void> Function(BackupProvider) onEditEndpoint;

  const _BackupSection({required this.onEditEndpoint});

  @override
  State<_BackupSection> createState() => _BackupSectionState();
}

class _BackupSectionState extends State<_BackupSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _SectionTitle('Local & Backup'),
        Consumer<BackupProvider>(
          builder: (localContext, backupProvider, _) {
            final lastBackupText = backupProvider.lastBackupAt == null
                ? 'Never'
                : DateFormat('yyyy-MM-dd HH:mm').format(backupProvider.lastBackupAt!);

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
                    leading: const Icon(Icons.cloud_upload_outlined, color: Colors.black87),
                    title: const Text('Backup endpoint'),
                    subtitle: Text(
                      backupProvider.serverUrl.isEmpty
                          ? 'Not configured'
                          : backupProvider.serverUrl,
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () => widget.onEditEndpoint(backupProvider),
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
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    onPressed: backupProvider.isBackingUp
                        ? null
                        : () async {
                            final ok = await localContext.read<BackupProvider>().backupNow(
                                  userProvider: localContext.read<UserProfileProvider>(),
                                  transactionProvider:
                                      localContext.read<TransactionProvider>(),
                                );
                            if (!localContext.mounted) return;
                            ScaffoldMessenger.of(localContext).showSnackBar(
                              SnackBar(
                                content: Text(
                                  ok
                                      ? 'Backup completed successfully'
                                      : 'Backup failed, check endpoint config',
                                ),
                              ),
                            );
                          },
                    icon: backupProvider.isBackingUp
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.backup_outlined),
                    label: const Text('Backup now'),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _LogoutSection extends StatefulWidget {
  const _LogoutSection();

  @override
  State<_LogoutSection> createState() => _LogoutSectionState();
}

class _LogoutSectionState extends State<_LogoutSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () async {
            final ok = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(false),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                ) ??
                false;
            if (!ok || !context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Logged out (mock action)')),
            );
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
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
}

class _SettingTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final Future<void> Function()? onTap;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.trailingText,
    required this.onTap,
  });

  @override
  State<_SettingTile> createState() => _SettingTileState();
}

class _SettingTileState extends State<_SettingTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: Icon(widget.icon, color: Colors.black87),
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.trailingText != null)
              Text(widget.trailingText!, style: const TextStyle(color: Colors.grey)),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
        onTap: widget.onTap == null ? null : () => widget.onTap!(),
      ),
    );
  }
}

class _SettingSwitchTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingSwitchTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  State<_SettingSwitchTile> createState() => _SettingSwitchTileState();
}

class _SettingSwitchTileState extends State<_SettingSwitchTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SwitchListTile(
        secondary: Icon(widget.icon, color: Colors.black87),
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w500)),
        value: widget.value,
        onChanged: widget.onChanged,
      ),
    );
  }
}

ImageProvider _avatarProvider(String avatar) {
  final value = avatar.trim();
  if (value.startsWith('http://') || value.startsWith('https://')) {
    return NetworkImage(value);
  }
  if (value.isEmpty) {
    return const AssetImage('assets/user/anonymous.jpg');
  }
  if (value.startsWith('assets/')) {
    return AssetImage(value);
  }
  if (!kIsWeb) {
    return FileImage(File(value));
  }
  return const AssetImage('assets/user/anonymous.jpg');
}
