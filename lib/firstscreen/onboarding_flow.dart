import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firstscreen/pin_lock_screen.dart';
import 'package:flutter_application_1/providers/app_settings_provider.dart';
import 'package:flutter_application_1/providers/app_translations.dart';
import 'package:flutter_application_1/providers/userprofileprovider.dart';
import 'package:flutter_application_1/providers/pin_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppLaunchGate extends StatefulWidget {
  final Widget child;

  const AppLaunchGate({super.key, required this.child});

  @override
  State<AppLaunchGate> createState() => _AppLaunchGateState();
}

class _AppLaunchGateState extends State<AppLaunchGate>
    with WidgetsBindingObserver {
  bool _isLoading = true;
  bool _completedOnboarding = false;
  bool _isUnlocked = false;
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadOnboardingStatus();
    
    // Listen to Supabase auth state changes and sync with UserProfileProvider
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      final user = session?.user;
      if (user != null && mounted) {
        final provider = context.read<UserProfileProvider>();
        provider.setUserEmail(user.email ?? '');
        if (provider.userName.isEmpty) {
          provider.setUserName(user.email?.split('@').first ?? 'User');
        }
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      setState(() => _isUnlocked = false);
    }
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

  void _onPinUnlocked() {
    setState(() => _isUnlocked = true);
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
          final appSettings = context.watch<AppSettingsProvider>();
          final pinProvider = context.watch<PinProvider>();
          // Only show lock screen if PIN lock is enabled and user has a PIN
          if (appSettings.pinLockEnabled &&
              pinProvider.hasPin &&
              !_isUnlocked) {
            return PinLockScreen(onUnlocked: _onPinUnlocked);
          }
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
        if (mounted) {
          await context.read<UserProfileProvider>().setUserEmail(email);
        }
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

    if (otp.isEmpty || otp.length < 6) {
      _showError('Vui lòng nhập mã OTP hợp lệ');
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
    try {
      await context.read<PinProvider>().refresh();
    } catch (_) {}
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
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Text(
            AppTranslations.getText(_selectedLanguageCode, 'ob_choose_language'),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            AppTranslations.getText(_selectedLanguageCode, 'ob_choose_language_sub'),
            style: const TextStyle(fontSize: 16),
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
          RadioListTile<String>(
            value: 'ko',
            groupValue: _selectedLanguageCode,
            title: const Text('한국어'),
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
              child: Text(AppTranslations.getText(_selectedLanguageCode, 'ob_continue')),
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
          Text(
            AppTranslations.getText(_selectedLanguageCode, 'ob_getting_started'),
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            AppTranslations.getText(_selectedLanguageCode, 'ob_getting_started_sub'),
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => setState(() => _step = 2),
              child: Text(AppTranslations.getText(_selectedLanguageCode, 'ob_start')),
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
                ? AppTranslations.getText(_selectedLanguageCode, 'ob_forgot_pw')
                : (_isLoginView 
                    ? AppTranslations.getText(_selectedLanguageCode, 'ob_login') 
                    : AppTranslations.getText(_selectedLanguageCode, 'ob_register')),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            _isForgotPasswordView
                ? AppTranslations.getText(_selectedLanguageCode, 'ob_forgot_pw_sub')
                : AppTranslations.getText(_selectedLanguageCode, 'ob_auth_sub'),
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: AppTranslations.getText(_selectedLanguageCode, 'ob_email'),
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.email),
            ),
          ),
          if (!_isForgotPasswordView) ...[
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: AppTranslations.getText(_selectedLanguageCode, 'ob_password'),
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock),
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
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : Text(_isForgotPasswordView
                      ? AppTranslations.getText(_selectedLanguageCode, 'ob_submit_email')
                      : (_isLoginView 
                          ? AppTranslations.getText(_selectedLanguageCode, 'ob_login') 
                          : AppTranslations.getText(_selectedLanguageCode, 'ob_register'))),
            ),
          ),
          const SizedBox(height: 16),
          if (!_isForgotPasswordView) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_isLoginView 
                    ? AppTranslations.getText(_selectedLanguageCode, 'ob_no_account') 
                    : AppTranslations.getText(_selectedLanguageCode, 'ob_have_account')),
                TextButton(
                  onPressed: () {
                    setState(() => _isLoginView = !_isLoginView);
                  },
                  child: Text(_isLoginView 
                      ? AppTranslations.getText(_selectedLanguageCode, 'ob_register_now') 
                      : AppTranslations.getText(_selectedLanguageCode, 'ob_login')),
                ),
              ],
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() => _isForgotPasswordView = true);
                },
                child: Text(AppTranslations.getText(_selectedLanguageCode, 'ob_forgot_pw_q')),
              ),
            ),
          ] else ...[
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() => _isForgotPasswordView = false);
                },
                child: Text(AppTranslations.getText(_selectedLanguageCode, 'ob_back_login')),
              ),
            ),
          ],
          if (!widget.startAtAuth) ...[
            const SizedBox(height: 24),
            Center(
              child: OutlinedButton(
                onPressed: () => setState(() => _step = 1),
                child: Text(AppTranslations.getText(_selectedLanguageCode, 'ob_back')),
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
            'Nhập mã OTP vừa được gửi đến ${_emailController.text}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            maxLength: 8,
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
      (
        AppTranslations.getText(_selectedLanguageCode, 'ob_review_f1_title'),
        AppTranslations.getText(_selectedLanguageCode, 'ob_review_f1_desc')
      ),
      (
        AppTranslations.getText(_selectedLanguageCode, 'ob_review_f2_title'),
        AppTranslations.getText(_selectedLanguageCode, 'ob_review_f2_desc')
      ),
      (
        AppTranslations.getText(_selectedLanguageCode, 'ob_review_f3_title'),
        AppTranslations.getText(_selectedLanguageCode, 'ob_review_f3_desc')
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Text(
            AppTranslations.getText(_selectedLanguageCode, 'ob_review_title'),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            AppTranslations.getText(_selectedLanguageCode, 'ob_review_sub'),
            style: const TextStyle(fontSize: 16),
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
                      backgroundColor:
                          const Color(0xFF2ECC71).withValues(alpha: 0.12),
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
              child: Text(AppTranslations.getText(_selectedLanguageCode, 'ob_enter_app')),
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
