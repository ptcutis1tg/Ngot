import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firstscreen/app_lock_settings_screen.dart';
import 'package:flutter_application_1/providers/app_settings_provider.dart';
import 'package:flutter_application_1/providers/backup_provider.dart';
import 'package:flutter_application_1/providers/currency_provider.dart';
import 'package:flutter_application_1/providers/transaction_provider.dart';
import 'package:flutter_application_1/providers/userprofileprovider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

Color layerColor(BuildContext context, int level) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  if (!isDark) {
    return switch (level) {
      0 => const Color(0xFFF8F9FA),
      1 => Colors.white,
      2 => const Color(0xFFFFFFFF),
      _ => const Color(0xFFFFFFFF),
    };
  }
  return switch (level) {
    0 => const Color(0xFF031F16),
    1 => const Color(0xFF052E1F),
    2 => const Color(0xFF0C3827),
    _ => const Color(0xFF104A33),
  };
}

ImageProvider avatarProvider(String avatar) {
  var value = avatar.trim();
  if (value.startsWith('memory:')) {
    final encoded = value.substring('memory:'.length);
    try {
      return MemoryImage(base64Decode(encoded));
    } catch (_) {
      return const AssetImage('assets/user/anonymous.jpg');
    }
  }
  if (value.startsWith('file://')) {
    value = Uri.parse(value).toFilePath();
  }
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
    if (!File(value).existsSync()) {
      return const AssetImage('assets/user/anonymous.jpg');
    }
    return FileImage(File(value));
  }
  return const AssetImage('assets/user/anonymous.jpg');
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurfaceVariant,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }
}

class SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final Future<void> Function()? onTap;

  const SettingTile({
    super.key,
    required this.icon,
    required this.title,
    required this.trailingText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: layerColor(context, 2),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.onSurfaceVariant),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailingText != null)
              Text(
                trailingText!,
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
            Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
          ],
        ),
        onTap: onTap == null ? null : () => onTap!(),
      ),
    );
  }
}

class SettingSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: layerColor(context, 2),
      child: SwitchListTile(
        secondary: Icon(icon, color: theme.colorScheme.onSurfaceVariant),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, userProfile, _) {
        final theme = Theme.of(context);
        return Container(
          padding: const EdgeInsets.all(20),
          color: layerColor(context, 1),
          child: Row(
            children: [
              CircleAvatar(
                key: ValueKey<String>(userProfile.userAvatar),
                radius: 35,
                backgroundImage: avatarProvider(userProfile.userAvatar),
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
                      style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
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

class AccountSection extends StatelessWidget {
  final Future<void> Function() onEditPersonal;
  final Future<void> Function(CurrencyProvider) onOpenCurrency;
  final Future<void> Function(AppSettingsProvider) onOpenLanguage;

  const AccountSection({
    super.key,
    required this.onEditPersonal,
    required this.onOpenCurrency,
    required this.onOpenLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingTile(
          icon: Icons.person_outline,
          title: 'Personal information',
          trailingText: null,
          onTap: onEditPersonal,
        ),
        Consumer<CurrencyProvider>(
          builder: (context, currencyProvider, _) => SettingTile(
            icon: Icons.currency_exchange,
            title: 'Currency',
            trailingText:
                '${currencyProvider.selected.code} (${currencyProvider.selected.symbol})',
            onTap: () => onOpenCurrency(currencyProvider),
          ),
        ),
        Consumer<AppSettingsProvider>(
          builder: (context, appSettings, _) => SettingTile(
            icon: Icons.language,
            title: 'Language',
            trailingText:
                appSettings.languageCode == 'vi' ? 'Tiếng Việt' : 'English',
            onTap: () => onOpenLanguage(appSettings),
          ),
        ),
      ],
    );
  }
}

class SecuritySection extends StatelessWidget {
  const SecuritySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionTitle('Security & App'),
        SettingTile(
          icon: Icons.lock_outline,
          title: 'Mã khoá ứng dụng',
          trailingText: null,
          onTap: () async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AppLockSettingsScreen(),
              ),
            );
          },
        ),
        const SettingTile(
          icon: Icons.fingerprint,
          title: 'Biometric lock',
          trailingText: 'Coming soon',
          onTap: null,
        ),
        Consumer<AppSettingsProvider>(
          builder: (context, appSettings, _) => SettingSwitchTile(
            icon: Icons.notifications_none,
            title: 'Notifications',
            value: appSettings.notificationsEnabled,
            onChanged: appSettings.setNotificationsEnabled,
          ),
        ),
        Consumer<AppSettingsProvider>(
          builder: (context, appSettings, _) => SettingSwitchTile(
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

class SupportSection extends StatelessWidget {
  final Future<void> Function() onHelp;
  final Future<void> Function() onAbout;

  const SupportSection({super.key, required this.onHelp, required this.onAbout});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionTitle('Support'),
        SettingTile(
          icon: Icons.help_outline,
          title: 'Help center',
          trailingText: null,
          onTap: onHelp,
        ),
        SettingTile(
          icon: Icons.info_outline,
          title: 'About app',
          trailingText: 'v1.0.0',
          onTap: onAbout,
        ),
      ],
    );
  }
}

class BackupSection extends StatelessWidget {
  final Future<void> Function(BackupProvider) onEditEndpoint;

  const BackupSection({super.key, required this.onEditEndpoint});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        const SectionTitle('Local & Backup'),
        Consumer<BackupProvider>(
          builder: (localContext, backupProvider, _) {
            final lastBackupText = backupProvider.lastBackupAt == null
                ? 'Never'
                : DateFormat('yyyy-MM-dd HH:mm')
                    .format(backupProvider.lastBackupAt!);

            return Column(
              children: [
                Container(
                  color: layerColor(context, 1),
                  child: SwitchListTile(
                    title: const Text('Enable server backup'),
                    value: backupProvider.enabled,
                    onChanged: backupProvider.setEnabled,
                  ),
                ),
                Container(
                  color: layerColor(context, 2),
                  child: ListTile(
                    leading: Icon(
                      Icons.cloud_upload_outlined,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    title: const Text('Backup endpoint'),
                    subtitle: Text(
                      backupProvider.serverUrl.isEmpty
                          ? 'Not configured'
                          : backupProvider.serverUrl,
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () => onEditEndpoint(backupProvider),
                  ),
                ),
                Container(
                  color: layerColor(context, 2),
                  child: ListTile(
                    leading: Icon(
                      Icons.history,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    title: const Text('Last backup'),
                    subtitle: Text(
                        '$lastBackupText - ${backupProvider.lastBackupStatus}'),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: layerColor(context, 3),
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    onPressed: backupProvider.isBackingUp
                        ? null
                        : () async {
                            final ok = await localContext
                                .read<BackupProvider>()
                                .backupNow(
                                  userProvider:
                                      localContext.read<UserProfileProvider>(),
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

class LogoutSection extends StatelessWidget {
  const LogoutSection({super.key});

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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Logout',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
