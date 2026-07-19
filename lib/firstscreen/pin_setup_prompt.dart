import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pin_provider.dart';
import '../providers/app_settings_provider.dart';
import 'pin_settings_screen.dart';

void showPinSetupPrompt(BuildContext context) {
  final pinProvider = context.read<PinProvider>();
  if (pinProvider.hasPin) return;

  final appSettings = context.read<AppSettingsProvider>();
  final isVietnamese = appSettings.languageCode == 'vi';

  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(isVietnamese ? 'Thiết lập mã PIN' : 'Set up PIN Code'),
        content: Text(
          isVietnamese
              ? 'Tài khoản của bạn chưa thiết lập mã PIN bảo mật. Thiết lập ngay để tăng cường bảo mật cho tài khoản của bạn.'
              : 'Your account has not set up a security PIN. Set up now to enhance your account security.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(isVietnamese ? 'Để sau' : 'Maybe Later'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2ECC71),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PinSettingsScreen(),
                ),
              );
            },
            child: Text(isVietnamese ? 'Thiết lập PIN' : 'Set up PIN'),
          ),
        ],
      );
    },
  );
}
