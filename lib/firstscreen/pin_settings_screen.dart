import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/pin_provider.dart';
import '../providers/app_settings_provider.dart';

class PinSettingsScreen extends StatefulWidget {
  final bool isRecovery;

  const PinSettingsScreen({super.key, this.isRecovery = false});

  @override
  State<PinSettingsScreen> createState() => _PinSettingsScreenState();
}

class _PinSettingsScreenState extends State<PinSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPinController = TextEditingController();
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  bool _isSaving = false;
  bool _isRemoving = false;
  String? _errorMessage;

  @override
  void dispose() {
    _currentPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  void _useSuggestedPin(String suggestion) {
    setState(() {
      _newPinController.text = suggestion;
      _confirmPinController.text = suggestion;
    });
  }

  Future<void> _savePin(PinProvider provider) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    final currentPin = widget.isRecovery ? null : _currentPinController.text;
    final pin = _newPinController.text;
    final confirmation = _confirmPinController.text;

    final error = await provider.savePin(
      pin: pin,
      confirmation: confirmation,
      currentPin: currentPin,
    );

    if (!mounted) return;

    setState(() {
      _isSaving = false;
      _errorMessage = error;
    });

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isRecovery
                ? 'Đã đặt lại PIN thành công'
                : (provider.hasPin
                    ? 'Đã đổi PIN thành công'
                    : 'Đã thiết lập PIN thành công'),
          ),
          backgroundColor: const Color(0xFF2ECC71),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> _removePin(PinProvider provider) async {
    final currentPin = _currentPinController.text;
    if (currentPin.isEmpty) {
      setState(() {
        _errorMessage = 'Vui lòng nhập PIN hiện tại để xóa';
      });
      return;
    }

    setState(() {
      _isRemoving = true;
      _errorMessage = null;
    });

    final error = await provider.removePin(currentPin);

    if (!mounted) return;

    setState(() {
      _isRemoving = false;
      _errorMessage = error;
    });

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã xóa PIN thành công'),
          backgroundColor: Color(0xFF2ECC71),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final pinProvider = context.watch<PinProvider>();
    final appSettings = context.watch<AppSettingsProvider>();
    final isVietnamese = appSettings.languageCode == 'vi';

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDarkMode ? Colors.white70 : Colors.black54;
    final textStyle =
        TextStyle(color: isDarkMode ? Colors.white : Colors.black);

    final showCurrentPin = pinProvider.hasPin && !widget.isRecovery;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isRecovery
              ? (isVietnamese ? 'Đặt lại mã PIN' : 'Reset PIN')
              : (pinProvider.hasPin
                  ? (isVietnamese ? 'Thay đổi mã PIN' : 'Change PIN')
                  : (isVietnamese ? 'Thiết lập mã PIN' : 'Setup PIN')),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // PIN Lock Toggle
                  SwitchListTile(
                    title: Text(isVietnamese
                        ? 'Khóa ứng dụng bằng PIN'
                        : 'Lock app with PIN'),
                    subtitle: Text(
                      appSettings.pinLockEnabled
                          ? (isVietnamese
                              ? 'Đã bật - cần nhập PIN khi mở ứng dụng'
                              : 'Enabled - PIN required to open app')
                          : (isVietnamese
                              ? 'Đã tắt - không cần nhập PIN'
                              : 'Disabled - no PIN required'),
                    ),
                    value: appSettings.pinLockEnabled && pinProvider.hasPin,
                    onChanged: pinProvider.hasPin
                        ? (value) async {
                            await appSettings.setPinLockEnabled(value);
                          }
                        : null,
                  ),
                  if (!pinProvider.hasPin)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        isVietnamese
                            ? 'Tạo mã PIN trước để bật tính năng khóa'
                            : 'Create a PIN first to enable lock',
                        style:
                            TextStyle(fontSize: 12, color: Colors.orange[700]),
                      ),
                    ),
                  const Divider(),
                  const SizedBox(height: 16),

                  if (widget.isRecovery) ...[
                    Text(
                      isVietnamese
                          ? 'Bạn đang trong chế độ đặt lại PIN qua email khôi phục.'
                          : 'You are resetting your PIN via recovery email.',
                      style: const TextStyle(
                          color: Colors.amber, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.red.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Current PIN
                  if (showCurrentPin) ...[
                    Text(
                      isVietnamese ? 'Mã PIN hiện tại' : 'Current PIN',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: labelColor),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      key: const Key('current-pin'),
                      controller: _currentPinController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: 6,
                      style: textStyle,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        hintText: isVietnamese
                            ? 'Nhập 6 số PIN hiện tại'
                            : 'Enter 6-digit current PIN',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16)),
                        counterText: '',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return isVietnamese
                              ? 'Vui lòng nhập PIN hiện tại'
                              : 'Please enter current PIN';
                        }
                        if (value.length != 6) {
                          return isVietnamese
                              ? 'PIN phải gồm 6 chữ số'
                              : 'PIN must be 6 digits';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () async {
                          final buildContext = context;
                          final error = await pinProvider.sendRecoveryEmail();
                          if (!buildContext.mounted) return;
                          if (error != null) {
                            ScaffoldMessenger.of(buildContext).showSnackBar(
                              SnackBar(
                                  content: Text(error),
                                  backgroundColor: Colors.red),
                            );
                          } else {
                            showDialog<void>(
                              context: buildContext,
                              builder: (context) => AlertDialog(
                                title: Text(isVietnamese
                                    ? 'Khôi phục PIN'
                                    : 'PIN Recovery'),
                                content: Text(
                                  isVietnamese
                                      ? 'Đã gửi email khôi phục. Vui lòng kiểm tra hộp thư của bạn và nhấn vào liên kết để đặt PIN mới.'
                                      : 'Recovery email sent. Please check your inbox and click the link to set a new PIN.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: Text(
                          isVietnamese ? 'Quên PIN?' : 'Forgot PIN?',
                          style: const TextStyle(
                              color: Color(0xFF2ECC71),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),

                  // New PIN
                  Text(
                    widget.isRecovery
                        ? (isVietnamese ? 'Mã PIN mới' : 'New PIN')
                        : (pinProvider.hasPin
                            ? (isVietnamese ? 'Mã PIN mới' : 'New PIN')
                            : (isVietnamese ? 'Nhập mã PIN' : 'Enter PIN')),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: labelColor),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const Key('pin-input'),
                    controller: _newPinController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 6,
                    style: textStyle,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      hintText: isVietnamese
                          ? 'Nhập 6 số PIN mới'
                          : 'Enter 6-digit PIN',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                      counterText: '',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return isVietnamese
                            ? 'Vui lòng nhập mã PIN'
                            : 'Please enter PIN';
                      }
                      if (value.length != 6) {
                        return isVietnamese
                            ? 'PIN phải gồm 6 chữ số'
                            : 'PIN must be 6 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Confirm PIN
                  Text(
                    isVietnamese ? 'Xác nhận mã PIN' : 'Confirm PIN',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: labelColor),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const Key('pin-confirmation'),
                    controller: _confirmPinController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 6,
                    style: textStyle,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      hintText: isVietnamese
                          ? 'Nhập lại 6 số PIN để xác nhận'
                          : 'Re-enter 6-digit PIN to confirm',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                      counterText: '',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return isVietnamese
                            ? 'Vui lòng xác nhận mã PIN'
                            : 'Please confirm PIN';
                      }
                      if (value != _newPinController.text) {
                        return isVietnamese
                            ? 'PIN xác nhận không khớp'
                            : 'PIN confirmation does not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Suggested PIN Section
                  Card(
                    color: isDarkMode
                        ? const Color(0xFF0C3827)
                        : Colors.green.shade50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isVietnamese ? 'Mã PIN gợi ý' : 'Suggested PIN',
                                style:
                                    TextStyle(fontSize: 12, color: labelColor),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                pinProvider.suggestedPin,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2),
                              ),
                            ],
                          ),
                          TextButton(
                            key: const Key('use-suggested-pin'),
                            onPressed: () =>
                                _useSuggestedPin(pinProvider.suggestedPin),
                            child: Text(
                              isVietnamese ? 'Dùng PIN gợi ý' : 'Use Suggested',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Save Action
                  ElevatedButton(
                    key: const Key('pin-save'),
                    onPressed: _isSaving || _isRemoving
                        ? null
                        : () => _savePin(pinProvider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2ECC71),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 2,
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Text(
                            isVietnamese ? 'Lưu mã PIN' : 'Save PIN',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),

                  // Remove PIN Action
                  if (showCurrentPin) ...[
                    const SizedBox(height: 16),
                    OutlinedButton(
                      key: const Key('pin-remove'),
                      onPressed: _isSaving || _isRemoving
                          ? null
                          : () => _removePin(pinProvider),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: _isRemoving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.red),
                            )
                          : Text(
                              isVietnamese ? 'Xóa mã PIN' : 'Delete PIN',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
