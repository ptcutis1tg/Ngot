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
  final _otpController = TextEditingController();
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  String? _errorMessage;
  String? _recoveryMessage;
  int _attempts = 0;
  bool _isSendingRecovery = false;
  bool _isVerifyingOtp = false;
  bool _isResettingPin = false;
  bool _showOtpInput = false;
  bool _showNewPinInput = false;

  @override
  void dispose() {
    _pinController.dispose();
    _otpController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
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
            'Đã gửi mã OTP đến email của bạn. Vui lòng kiểm tra hộp thư.';
        _showOtpInput = true;
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

  Future<void> _verifyOtp() async {
    final otp = _otpController.text;
    if (otp.length != 6) {
      setState(() {
        _errorMessage = 'Mã OTP phải gồm 6 chữ số';
      });
      return;
    }

    setState(() {
      _isVerifyingOtp = true;
      _errorMessage = null;
    });

    final pinProvider = context.read<PinProvider>();
    final isValid = pinProvider.verifyOtp(otp);

    if (!mounted) return;

    setState(() {
      _isVerifyingOtp = false;
      if (isValid) {
        _showOtpInput = false;
        _showNewPinInput = true;
        _recoveryMessage = 'Xác thực thành công. Vui lòng nhập PIN mới.';
      } else {
        _errorMessage = 'Mã OTP không đúng hoặc đã hết hạn';
        _otpController.clear();
      }
    });
  }

  Future<void> _resetPin() async {
    final newPin = _newPinController.text;
    final confirmPin = _confirmPinController.text;

    if (newPin.length != 6) {
      setState(() {
        _errorMessage = 'Mã PIN phải gồm 6 chữ số';
      });
      return;
    }

    if (newPin != confirmPin) {
      setState(() {
        _errorMessage = 'Mã PIN xác nhận không khớp';
      });
      return;
    }

    setState(() {
      _isResettingPin = true;
      _errorMessage = null;
    });

    final pinProvider = context.read<PinProvider>();
    final otp = _otpController.text;
    final error = await pinProvider.resetPinWithOtp(otp, newPin);

    if (!mounted) return;

    setState(() {
      _isResettingPin = false;
      if (error == null) {
        _recoveryMessage =
            'Đặt lại PIN thành công. Vui lòng đăng nhập bằng PIN mới.';
        _showNewPinInput = false;
        _otpController.clear();
        _newPinController.clear();
        _confirmPinController.clear();
        // Clear OTP state in provider
        pinProvider.clearOtp();
      } else {
        _errorMessage = error;
      }
    });
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
          child: SingleChildScrollView(
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
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        isDark ? const Color(0xFF0C3827) : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF2ECC71)
                          : Colors.green.shade200,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: isDark
                            ? const Color(0xFF2ECC71)
                            : Colors.green.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isVietnamese
                              ? 'Gợi ý: Bạn có thể tắt/bật khóa PIN trong Cài đặt nếu thấy bất tiện'
                              : 'Tip: You can enable/disable PIN lock in Settings if inconvenient',
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                isDark ? Colors.white70 : Colors.green.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
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

                // OTP Input Section
                if (_showOtpInput) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0C3827)
                          : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF2196F3)
                            : Colors.blue.shade200,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          isVietnamese
                              ? 'Nhập mã OTP từ email'
                              : 'Enter OTP from email',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _otpController,
                          keyboardType: TextInputType.number,
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
                                color: Color(0xFF2196F3),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isVerifyingOtp ? null : _verifyOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2196F3),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isVerifyingOtp
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    isVietnamese
                                        ? 'Xác thực OTP'
                                        : 'Verify OTP',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed:
                              _isSendingRecovery ? null : _sendRecoveryEmail,
                          child: Text(
                            isVietnamese ? 'Gửi lại mã OTP' : 'Resend OTP',
                            style: const TextStyle(
                              color: Color(0xFF2196F3),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // New PIN Input Section
                if (_showNewPinInput) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0C3827)
                          : Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF2ECC71)
                            : Colors.green.shade200,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          isVietnamese ? 'Nhập PIN mới' : 'Enter New PIN',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _newPinController,
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
                          decoration: InputDecoration(
                            counterText: '',
                            hintText: '● ● ● ● ● ●',
                            labelText: isVietnamese ? 'PIN mới' : 'New PIN',
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
                        const SizedBox(height: 16),
                        TextField(
                          controller: _confirmPinController,
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
                          decoration: InputDecoration(
                            counterText: '',
                            hintText: '● ● ● ● ● ●',
                            labelText:
                                isVietnamese ? 'Xác nhận PIN' : 'Confirm PIN',
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
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isResettingPin ? null : _resetPin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2ECC71),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isResettingPin
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    isVietnamese ? 'Đặt lại PIN' : 'Reset PIN',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
