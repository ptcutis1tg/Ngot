import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/pin_provider.dart';
import '../providers/app_settings_provider.dart';

class PinLockScreen extends StatefulWidget {
  final VoidCallback onUnlocked;

  const PinLockScreen({super.key, required this.onUnlocked});

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  final _pinController = TextEditingController();
  String? _errorMessage;
  String? _recoveryMessage;
  int _attempts = 0;
  bool _isSendingRecovery = false;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _sendRecoveryEmail() async {
    setState(() {
      _isSendingRecovery = true;
      _recoveryMessage = null;
    });

    final pinProvider = context.read<PinProvider>();
    final error = await pinProvider.sendRecoveryEmail();

    if (!mounted) return;

    setState(() {
      _isSendingRecovery = false;
      if (error == null) {
        _recoveryMessage =
            'Đã gửi email khôi phục. Vui lòng kiểm tra hộp thư và nhấn vào liên kết để đặt PIN mới.';
      } else {
        _recoveryMessage = error;
      }
    });
  }

  void _onPinChanged(String value) {
    if (_errorMessage != null) {
      setState(() => _errorMessage = null);
    }

    if (value.length == 6) {
      _verifyPin(value);
    }
  }

  void _verifyPin(String pin) {
    final pinProvider = context.read<PinProvider>();
    final isValid = pinProvider.verifyPin(pin);

    if (isValid) {
      widget.onUnlocked();
    } else {
      setState(() {
        _attempts++;
        _errorMessage = _attempts >= 3
            ? 'Sai PIN quá nhiều lần. Vui lòng thử lại sau.'
            : 'Mã PIN không đúng';
        _pinController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appSettings = context.watch<AppSettingsProvider>();
    final isVietnamese = appSettings.languageCode == 'vi';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF031F16) : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                size: 64,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
              const SizedBox(height: 24),
              Text(
                isVietnamese ? 'Nhập mã PIN' : 'Enter PIN',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isVietnamese
                    ? 'Nhập mã PIN 6 số để mở khóa ứng dụng'
                    : 'Enter 6-digit PIN to unlock the app',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  letterSpacing: 8,
                  color: isDark ? Colors.white : Colors.black,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: _onPinChanged,
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '● ● ● ● ● ●',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: isDark ? Colors.white24 : Colors.black12,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFF2ECC71),
                      width: 2,
                    ),
                  ),
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: Colors.red.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              TextButton(
                onPressed: _isSendingRecovery ? null : _sendRecoveryEmail,
                child: _isSendingRecovery
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        isVietnamese ? 'Quên PIN?' : 'Forgot PIN?',
                        style: const TextStyle(
                          color: Color(0xFF2ECC71),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              if (_recoveryMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  _recoveryMessage!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF2ECC71),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
