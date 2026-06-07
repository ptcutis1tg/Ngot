import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/app_settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLaunchGate extends StatefulWidget {
  final Widget child;

  const AppLaunchGate({super.key, required this.child});

  @override
  State<AppLaunchGate> createState() => _AppLaunchGateState();
}

class _AppLaunchGateState extends State<AppLaunchGate> {
  bool _isLoading = true;
  bool _completed = false;

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
      _completed = completed;
      _isLoading = false;
    });
  }

  Future<void> _handleFinish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (!mounted) return;
    setState(() => _completed = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_completed) {
      return widget.child;
    }

    return OnboardingFlow(onCompleted: _handleFinish);
  }
}

class OnboardingFlow extends StatefulWidget {
  final Future<void> Function() onCompleted;

  const OnboardingFlow({super.key, required this.onCompleted});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _step = 0;
  String? _authMode;
  String _selectedLanguageCode = 'vi';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedLanguageCode =
        context.read<AppSettingsProvider>().languageCode == 'en' ? 'en' : 'vi';
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
    super.dispose();
  }

  Future<void> _handleAuthContinue() async {
    if (_authMode == null) return;

    if (_authMode == 'login') {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui long nhap email va mat khau')),
        );
        return;
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('authMode', 'login');
      await prefs.setString('userEmail', email);
      await prefs.setString('userName', email.split('@').first);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('authMode', 'guest');
    }

    if (!mounted) return;
    setState(() => _step = 3);
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
            'Chon ngon ngu de tiep tuc',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          RadioListTile<String>(
            value: 'vi',
            groupValue: _selectedLanguageCode,
            title: const Text('Tieng Viet'),
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
              child: Text(isVietnamese ? 'Tiep tuc' : 'Continue'),
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
            'Theo doi chi tieu hang ngay, quan ly vi tien va xem thong ke nhanh trong mot ung dung.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => setState(() => _step = 2),
              child: const Text('Bat dau'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthStep() {
    final isLogin = _authMode == 'login';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Text(
            'Dang nhap hoac dung Guest',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Ban can chon mot che do de tiep tuc vao app.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          RadioListTile<String>(
            value: 'login',
            groupValue: _authMode,
            title: const Text('Dang nhap'),
            subtitle: const Text('Su dung tai khoan cua ban'),
            onChanged: (value) => setState(() => _authMode = value),
          ),
          RadioListTile<String>(
            value: 'guest',
            groupValue: _authMode,
            title: const Text('Guest user'),
            subtitle: const Text('Vao nhanh ma khong can tai khoan'),
            onChanged: (value) => setState(() => _authMode = value),
          ),
          if (isLogin) ...[
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Mat khau'),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              OutlinedButton(
                onPressed: () => setState(() => _step = 1),
                child: const Text('Quay lai'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _authMode == null ? null : _handleAuthContinue,
                child: const Text('Tiep tuc'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStep() {
    final features = [
      ('Ghi giao dich nhanh', 'Them thu chi trong vai giay voi nut +'),
      ('Thong ke truc quan', 'Theo doi xu huong chi tieu theo thoi gian'),
      ('Quan ly vi tien', 'To chuc tai khoan va xem tong so du'),
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          const Text(
            'Review nhanh tinh nang',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Day la 3 tinh nang chinh de bat dau su dung app nhanh hon.',
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
                      backgroundColor: const Color(0xFF2ECC71).withOpacity(0.12),
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
              child: const Text('Vao ung dung'),
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
            2 => _buildAuthStep(),
            _ => _buildReviewStep(),
          },
        ),
      ),
    );
  }
}
