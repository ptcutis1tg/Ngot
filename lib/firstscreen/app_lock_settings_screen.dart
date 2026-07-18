import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/app_settings_provider.dart';
import 'package:provider/provider.dart';

class AppLockSettingsScreen extends StatefulWidget {
  const AppLockSettingsScreen({super.key});

  @override
  State<AppLockSettingsScreen> createState() => _AppLockSettingsScreenState();
}

class _AppLockSettingsScreenState extends State<AppLockSettingsScreen> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  bool _isLoading = false;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onNewPasswordChanged(String value) {
    setState(() {}); // Trigger rebuild for strength indicator
  }

  Future<void> _savePassword() async {
    final appSettings = context.read<AppSettingsProvider>();
    
    // Basic pre-validation
    if (_newController.text.isEmpty) {
      _showError('Vui lòng nhập mật khẩu mới');
      return;
    }
    if (_newController.text != _confirmController.text) {
      _showError('Mật khẩu xác nhận không khớp');
      return;
    }

    setState(() => _isLoading = true);

    final error = await appSettings.changePassword(
      currentPassword: _currentController.text,
      newPassword: _newController.text,
      confirmPassword: _confirmController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error != null) {
      // Map common errors to Vietnamese or show as is
      String displayError = error;
      if (error.contains('must be at least 4 characters')) {
        displayError = 'Mật khẩu phải có ít nhất 4 ký tự';
      } else if (error.contains('does not match')) {
        displayError = 'Mật khẩu xác nhận không khớp';
      } else if (error.contains('incorrect')) {
        displayError = 'Mật khẩu hiện tại không đúng';
      }
      _showError(displayError);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cập nhật mã khoá thành công'),
          backgroundColor: Color(0xFF27AE60),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  Widget _buildStrengthIndicator(String password) {
    int strength = 0;
    if (password.isNotEmpty) strength++;
    if (password.length >= 4) strength++;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[a-zA-Z]'))) strength++;

    Color color = Colors.grey.withOpacity(0.3);
    String text = '';
    double widthFactor = 0.0;

    if (password.isEmpty) {
      text = 'Vui lòng nhập mật khẩu';
    } else if (strength <= 2) {
      color = Colors.redAccent;
      text = 'Yếu';
      widthFactor = 0.33;
    } else if (strength <= 4) {
      color = Colors.orangeAccent;
      text = 'Trung bình';
      widthFactor = 0.66;
    } else {
      color = const Color(0xFF1CF07B);
      text = 'Mạnh';
      widthFactor = 1.0;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: widthFactor,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 6,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    ValueChanged<String>? onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0C3827) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF11653F) : Colors.grey.shade300,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        onChanged: onChanged,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            onPressed: onToggleVisibility,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appSettings = context.watch<AppSettingsProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasPassword = appSettings.hasPassword;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF031F16) : Colors.white,
      appBar: AppBar(
        title: Text(hasPassword ? 'Đổi mã khoá' : 'Tạo mã khoá'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Icon(
                CupertinoIcons.lock_shield,
                size: 80,
                color: isDark ? const Color(0xFF1CF07B) : const Color(0xFF2ECC71),
              ),
              const SizedBox(height: 24),
              Text(
                hasPassword
                    ? 'Bảo vệ ứng dụng của bạn bằng cách cập nhật mã khoá cục bộ.'
                    : 'Thiết lập mã khoá cục bộ để bảo vệ dữ liệu riêng tư của bạn.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              if (hasPassword) ...[
                _buildPasswordField(
                  controller: _currentController,
                  label: 'Mật khẩu hiện tại',
                  obscureText: _obscureCurrent,
                  onToggleVisibility: () =>
                      setState(() => _obscureCurrent = !_obscureCurrent),
                ),
                const SizedBox(height: 16),
              ],
              _buildPasswordField(
                controller: _newController,
                label: 'Mật khẩu mới',
                obscureText: _obscureNew,
                onChanged: _onNewPasswordChanged,
                onToggleVisibility: () =>
                    setState(() => _obscureNew = !_obscureNew),
              ),
              _buildStrengthIndicator(_newController.text),
              const SizedBox(height: 16),
              _buildPasswordField(
                controller: _confirmController,
                label: 'Xác nhận mật khẩu',
                obscureText: _obscureConfirm,
                onToggleVisibility: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
              const SizedBox(height: 48),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _savePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2ECC71),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          hasPassword ? 'Cập nhật' : 'Tạo mã khoá',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
