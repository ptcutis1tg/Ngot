import 'package:flutter/material.dart';
import 'package:flutter_application_1/firstscreen/personal_information_screen.dart';
import 'package:flutter_application_1/providers/app_settings_provider.dart';
import 'package:flutter_application_1/providers/app_translations.dart';
import 'package:flutter_application_1/providers/backup_provider.dart';
import 'package:flutter_application_1/providers/currency_provider.dart';

import 'settings_components/settings_sections.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: _SettingsAppBar(),
      body: _SettingsBody(),
    );
  }
}

class _SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _SettingsAppBar();

  @override
  Widget build(BuildContext context) {
    final languageCode = context.watch<AppSettingsProvider>().languageCode;
    return AppBar(title: Text(AppTranslations.getText(languageCode, 'st_title')));
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
          const ProfileHeader(),
          const SizedBox(height: 25),
          const SectionTitle('Account Settings'),
          AccountSection(
            onEditPersonal: _openPersonalInformationEditor,
            onOpenCurrency: _showCurrencyDialog,
            onOpenLanguage: _showLanguageDialog,
          ),
          const SizedBox(height: 20),
          const SecuritySection(),
          const SizedBox(height: 20),
          SupportSection(
            onHelp: _showHelpDialog,
            onAbout: _showAboutDialog,
          ),
          const SizedBox(height: 20),
          BackupSection(onEditEndpoint: _showEndpointDialog),
          const SizedBox(height: 30),
          const LogoutSection(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Future<void> _openPersonalInformationEditor() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PersonalInformationScreen(),
      ),
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
                        trailing: currency.code ==
                                currencyProvider.selected.code
                            ? const Icon(Icons.check, color: Color(0xFF2ECC71))
                            : null,
                        onTap: () async {
                          await currencyProvider
                              .setCurrencyByCode(currency.code);
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

  Future<void> _showLanguageDialog(AppSettingsProvider appSettings) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(AppTranslations.getText(appSettings.languageCode, 'st_select_language')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                value: 'vi',
                groupValue: appSettings.languageCode,
                title: const Text('Tiếng Việt'),
                onChanged: (value) async {
                  if (value == null) return;
                  await appSettings.setLanguageCode(value);
                  if (!dialogContext.mounted) return;
                  Navigator.of(dialogContext).pop();
                },
              ),
              RadioListTile<String>(
                value: 'en',
                groupValue: appSettings.languageCode,
                title: const Text('English'),
                onChanged: (value) async {
                  if (value == null) return;
                  await appSettings.setLanguageCode(value);
                  if (!dialogContext.mounted) return;
                  Navigator.of(dialogContext).pop();
                },
              ),
              RadioListTile<String>(
                value: 'ko',
                groupValue: appSettings.languageCode,
                title: const Text('한국어'),
                onChanged: (value) async {
                  if (value == null) return;
                  await appSettings.setLanguageCode(value);
                  if (!dialogContext.mounted) return;
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(AppTranslations.getText(appSettings.languageCode, 'st_close')),
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
