import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/app_settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppLaunchGate extends StatefulWidget {
  final Widget child;

  const AppLaunchGate({super.key, required this.child});

  @override
  State<AppLaunchGate> createState() => _AppLaunchGateState();
}

class _AppLaunchGateState extends State<AppLaunchGate> {
  bool _isLoading = true;
  bool _completedOnboarding = false;

  @override
  void initState() {
    super.initState();
    _loadOnboardingStatus();
  }

  Future<void> _loadOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool('onboarding_completed') ?? false;
    if (!mounted) return;
    setState(() {
      _completedOnboarding = completed;
      _isLoading = false;
    });
  }

  Future<void> _handleFinish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (!mounted) return;
    setState(() => _completedOnboarding = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = Supabase.instance.client.auth.currentSession;
        final isLoggedIn = session != null;

        if (isLoggedIn && _completedOnboarding) {
          return widget.child;
        }

        return OnboardingFlow(
          onCompleted: _handleFinish,
          startAtAuth: _completedOnboarding && !isLoggedIn,
        );
      },
    );
  }
}

class OnboardingFlow extends StatefulWidget {
  final Future<void> Function() onCompleted;
  final bool startAtAuth;

  const OnboardingFlow({
    super.key,
    required this.onCompleted,
    this.startAtAuth = false,
  });

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  late int _step;
  String _selectedLanguageCode = 'vi';
  
  // Auth states
  bool _isLoginView = true;
  bool _isForgotPasswordView = false;
  bool _isVerifyOtpView = false;
  bool _isAuthLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _step = widget.startAtAuth ? 2 : 0;
    _selectedLanguageCode = 'vi';
    _loadInitialLanguageCode();
  }

  Future<void> _loadInitialLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('settings_language_code');
    if (!mounted) return;
    if (saved == 'vi' || saved == 'en') {
      setState(() => _selectedLanguageCode = saved ?? 'vi');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSupabaseAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty) {
      _showError('Vui lòng nhập email');
      return;
    }

    setState(() => _isAuthLoading = true);

    try {
      if (_isForgotPasswordView) {
        await Supabase.instance.client.auth.resetPasswordForEmail(email);
        _showMessage('Đã gửi mã xác nhận qua email');
        setState(() {
          _isForgotPasswordView = false;
          _isVerifyOtpView = true;
        });
      } else if (_isLoginView) {
        if (password.isEmpty) {
          _showError('Vui lòng nhập mật khẩu');
          setState(() => _isAuthLoading = false);
          return;
        }
        await Supabase.instance.client.auth.signInWithPassword(
          email: email,
          password: password,
        );
        await _handlePostAuth();
      } else {
        if (password.isEmpty) {
          _showError('Vui lòng nhập mật khẩu');
          setState(() => _isAuthLoading = false);
          return;
        }
        await Supabase.instance.client.auth.signUp(
          email: email,
          password: password,
        );
        _showMessage('Đăng ký thành công! Vui lòng đăng nhập.');
        await _handlePostAuth();
      }
    } on AuthException catch (e) {
      _showError(e.message);
    } catch (e) {
      _showError('Đã xảy ra lỗi không xác định');
    } finally {
      if (mounted) setState(() => _isAuthLoading = false);
    }
  }

  Future<void> _handleVerifyOtp() async {
    final email = _emailController.text.trim();
    final otp = _otpController.text.trim();
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (otp.isEmpty || otp.length != 6) {
      _showError('Vui lòng nhập mã OTP 6 số');
      return;
    }
    if (newPassword.isEmpty || newPassword.length < 6) {
      _showError('Mật khẩu mới phải từ 6 ký tự trở lên');
      return;
    }
    if (newPassword != confirmPassword) {
      _showError('Nhập lại mật khẩu không khớp');
      return;
    }

    setState(() => _isAuthLoading = true);
    try {
      await Supabase.instance.client.auth.verifyOTP(
        email: email,
        token: otp,
        type: OtpType.recovery,
      );
      
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      
      await Supabase.instance.client.auth.signOut();
      
      _showMessage('Đổi mật khẩu thành công! Vui lòng đăng nhập lại.');
      setState(() {
        _isVerifyOtpView = false;
        _isLoginView = true;
        _passwordController.clear();
        _otpController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      });
    } on AuthException catch (e) {
      _showError(e.message);
    } catch (e) {
      _showError('Đã xảy ra lỗi không xác định');
    } finally {
      if (mounted) setState(() => _isAuthLoading = false);
    }
  }

  Future<void> _handlePostAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authMode', 'login');
    if (!mounted) return;
    if (!widget.startAtAuth) {
      setState(() => _step = 3);
    } else {
      widget.onCompleted();
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  Future<void> _applyLanguageAndContinue() async {
    await context
        .read<AppSettingsProvider>()
        .setLanguageCode(_selectedLanguageCode);
    if (!mounted) return;
    setState(() => _step = 1);
  }

  Widget _buildLanguageStep() {
    final isVietnamese = _selectedLanguageCode == 'vi';
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          const Text(
            'Choose language',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Chọn ngôn ngữ để tiếp tục',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          RadioListTile<String>(
            value: 'vi',
            groupValue: _selectedLanguageCode,
            title: const Text('Tiếng Việt'),
            onChanged: (value) {
              if (value == null) return;
              setState(() => _selectedLanguageCode = value);
            },
          ),
          RadioListTile<String>(
            value: 'en',
            groupValue: _selectedLanguageCode,
            title: const Text('English'),
            onChanged: (value) {
              if (value == null) return;
              setState(() => _selectedLanguageCode = value);
            },
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _applyLanguageAndContinue,
              child: Text(isVietnamese ? 'Tiếp tục' : 'Continue'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGettingStartedStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_graph, size: 64, color: Color(0xFF2ECC71)),
          const SizedBox(height: 24),
          const Text(
            'Getting Started',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Theo dõi chi tiêu hàng ngày, quản lý ví tiền và xem thống kê nhanh trong một ứng dụng.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => setState(() => _step = 2),
              child: const Text('Bắt đầu'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            _isForgotPasswordView
                ? 'Quên mật khẩu'
                : (_isLoginView ? 'Đăng nhập' : 'Đăng ký'),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            _isForgotPasswordView
                ? 'Nhập email để nhận liên kết khôi phục.'
                : 'Vui lòng điền thông tin bên dưới.',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
          ),
          if (!_isForgotPasswordView) ...[
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Mật khẩu',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isAuthLoading ? null : _handleSupabaseAuth,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2ECC71),
                foregroundColor: Colors.white,
              ),
              child: _isAuthLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(_isForgotPasswordView
                      ? 'Gửi Email'
                      : (_isLoginView ? 'Đăng nhập' : 'Đăng ký')),
            ),
          ),
          const SizedBox(height: 16),
          if (!_isForgotPasswordView) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_isLoginView ? 'Chưa có tài khoản?' : 'Đã có tài khoản?'),
                TextButton(
                  onPressed: () {
                    setState(() => _isLoginView = !_isLoginView);
                  },
                  child: Text(_isLoginView ? 'Đăng ký ngay' : 'Đăng nhập'),
                ),
              ],
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() => _isForgotPasswordView = true);
                },
                child: const Text('Quên mật khẩu?'),
              ),
            ),
          ] else ...[
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() => _isForgotPasswordView = false);
                },
                child: const Text('Quay lại Đăng nhập'),
              ),
            ),
          ],
          if (!widget.startAtAuth) ...[
            const SizedBox(height: 24),
            Center(
              child: OutlinedButton(
                onPressed: () => setState(() => _step = 1),
                child: const Text('Quay lại'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVerifyOtpStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Text(
            'Xác nhận mã OTP',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'Nhập mã 6 số vừa được gửi đến ${_emailController.text}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: const InputDecoration(
              labelText: 'Mã xác nhận (OTP)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.security),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _newPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Mật khẩu mới',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Nhập lại mật khẩu mới',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock_outline),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isAuthLoading ? null : _handleVerifyOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2ECC71),
                foregroundColor: Colors.white,
              ),
              child: _isAuthLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Xác nhận đổi mật khẩu'),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () {
                setState(() {
                  _isVerifyOtpView = false;
                  _isForgotPasswordView = true;
                });
              },
              child: const Text('Quay lại'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthStepContainer() {
    if (_isVerifyOtpView) {
      return _buildVerifyOtpStep();
    }
    return _buildAuthStep();
  }

  Widget _buildReviewStep() {
    final features = [
      ('Ghi giao dịch nhanh', 'Thêm thu chi trong vài giây với nút +'),
      ('Thống kê trực quan', 'Theo dõi xu hướng chi tiêu theo thời gian'),
      ('Quản lý ví tiền', 'Tổ chức tài khoản và xem tổng số dư'),
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          const Text(
            'Review nhanh tính năng',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Đây là 3 tính năng chính để bắt đầu sử dụng app nhanh hơn.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: features.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final feature = features[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF2ECC71).withValues(alpha: 0.12),
                      child: Text('${index + 1}'),
                    ),
                    title: Text(feature.$1),
                    subtitle: Text(feature.$2),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onCompleted,
              child: const Text('Vào ứng dụng'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: switch (_step) {
            0 => _buildLanguageStep(),
            1 => _buildGettingStartedStep(),
            2 => _buildAuthStepContainer(),
            _ => _buildReviewStep(),
          },
        ),
      ),
    );
  }
}
