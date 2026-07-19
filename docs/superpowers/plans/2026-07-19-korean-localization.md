# Korean Localization Support Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Enable Korean language support in settings and onboarding, and dynamically localize all components using `AppTranslations`.

**Architecture:** Modify `AppSettingsProvider` to accept `'ko'`, update `main.dart`'s locale configuration, and replace hardcoded texts in the onboarding, settings, personal info, and dashboard views with translations from `AppTranslations`.

**Tech Stack:** Flutter, Dart, Provider, SharedPreferences, Supabase Auth.

## Global Constraints

- All components must load text dynamically from `AppTranslations` based on the selected language code.

---

### Task 1: Update AppSettingsProvider & main.dart Configuration

**Files:**
- Modify: `lib/providers/app_settings_provider.dart:80-90`
- Modify: `lib/main.dart`
- Create/Modify: `test/user_profile_provider_test.dart`

**Interfaces:**
- Consumes: `lib/providers/app_translations.dart`
- Produces: Locale support for Korean in settings provider and main entrypoint

- [ ] **Step 1: Allow 'ko' in AppSettingsProvider**

Modify `setLanguageCode` in `lib/providers/app_settings_provider.dart`:
```dart
  Future<void> setLanguageCode(String value) async {
    final next = value.trim().toLowerCase();
    if (next != 'vi' && next != 'en' && next != 'ko') return;
    if (_languageCode == next) return;

    _languageCode = next;
    final prefs = await _prefsFuture;
    await prefs.setString(_languageCodeKey, _languageCode);
    notifyListeners();
  }
```

- [ ] **Step 2: Add 'ko' to supportedLocales and use translations for bottom navigation in main.dart**

Add import to `lib/main.dart`:
```dart
import 'package:flutter_application_1/providers/app_translations.dart';
```

Modify supportedLocales list in `lib/main.dart`:
```dart
      supportedLocales: const [
        Locale('vi'),
        Locale('en'),
        Locale('ko'),
      ],
```

Modify the BottomNavigationBar items build in `_MainNavigationBodyState` in `lib/main.dart`:
```dart
    final languageCode = context.watch<AppSettingsProvider>().languageCode;

    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _selectedIndex = index),
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onNavTap,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.dashboard_outlined),
                activeIcon: const Icon(Icons.dashboard),
                label: AppTranslations.getText(languageCode, 'nav_home'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.bar_chart_outlined),
                activeIcon: const Icon(Icons.bar_chart),
                label: AppTranslations.getText(languageCode, 'nav_report'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.account_balance_wallet_outlined),
                activeIcon: const Icon(Icons.account_balance_wallet),
                label: AppTranslations.getText(languageCode, 'nav_wallet'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings_outlined),
                activeIcon: const Icon(Icons.settings),
                label: AppTranslations.getText(languageCode, 'nav_settings'),
              ),
            ],
          ),
        ),
      ),
```

- [ ] **Step 3: Update and run unit tests**

Extend `test/user_profile_provider_test.dart` to verify `AppSettingsProvider` loaded correctly.
Wait, let's just run existing tests first:
Run: `flutter test test/user_profile_provider_test.dart`
Expected: PASS

- [ ] **Step 4: Commit changes**

```bash
git add lib/providers/app_settings_provider.dart lib/main.dart
git commit -m "feat: enable Korean locale in provider and main.dart navigation"
```

---

### Task 2: Translate Onboarding Flow & Settings Screen

**Files:**
- Modify: `lib/firstscreen/onboarding_flow.dart`
- Modify: `lib/firstscreen/settings_screen.dart`

**Interfaces:**
- Consumes: `lib/providers/app_translations.dart`
- Produces: Translated onboarding screens and settings dialogs

- [ ] **Step 1: Add Korean radio tile and translate onboarding steps**

Import translations in `lib/firstscreen/onboarding_flow.dart`:
```dart
import 'package:flutter_application_1/providers/app_translations.dart';
```

Modify `_buildLanguageStep` in `lib/firstscreen/onboarding_flow.dart` to add Korean RadioListTile:
```dart
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
```

Update `_buildGettingStartedStep` text bindings:
```dart
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
```

Update `_buildAuthStep` text bindings:
```dart
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
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
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
```

Update `_buildReviewStep` text bindings:
```dart
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
              child: Text(AppTranslations.getText(_selectedLanguageCode, 'ob_enter_app')),
            ),
          ),
        ],
      ),
    );
  }
```

- [ ] **Step 2: Update Settings Screen Dialog and Titles**

Add import to `lib/firstscreen/settings_screen.dart`:
```dart
import 'package:flutter_application_1/providers/app_translations.dart';
```

Modify Dialog titles, buttons, and settings items translation in `lib/firstscreen/settings_screen.dart`:
- Change `AppBar(title: const Text('Settings'))` to `AppBar(title: Text(AppTranslations.getText(appSettings.languageCode, 'st_title')))` inside `_SettingsAppBar`. Make sure to read provider in `_SettingsAppBar` by wrapping it or using context watch:
```dart
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
```

Modify `_SettingsBodyState` to translate titles and select dialogs:
- Replace `const SectionTitle('Account Settings')` with `SectionTitle(AppTranslations.getText(languageCode, 'st_account_settings'))`.
- Replace `const SectionTitle('Security & App')` in `settings_sections.dart` with translation. Let's do it inside `settings_sections.dart` directly.
- In `_showLanguageDialog()` in `lib/firstscreen/settings_screen.dart`, add Korean RadioListTile:
```dart
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
```

- [ ] **Step 3: Run tests to verify compilation**

Run: `flutter test test/user_profile_provider_test.dart`
Expected: PASS

- [ ] **Step 4: Commit changes**

```bash
git add lib/firstscreen/onboarding_flow.dart lib/firstscreen/settings_screen.dart
git commit -m "feat: translate onboarding flow and settings screen dialog"
```

---

### Task 3: Translate Settings Sections & Personal Information Screen

**Files:**
- Modify: `lib/firstscreen/settings_components/settings_sections.dart`
- Modify: `lib/firstscreen/personal_information_screen.dart`

**Interfaces:**
- Consumes: `lib/providers/app_translations.dart`
- Produces: Localized settings cards and profile detail fields

- [ ] **Step 1: Translate settings sections labels, switches, buttons, and alert dialogs**

Add import to `lib/firstscreen/settings_components/settings_sections.dart`:
```dart
import 'package:flutter_application_1/providers/app_translations.dart';
```

Modify sections inside `lib/firstscreen/settings_components/settings_sections.dart` to load languageCode from watch:
```dart
// Modify AccountSection:
class AccountSection extends StatelessWidget {
...
  @override
  Widget build(BuildContext context) {
    final appSettings = context.watch<AppSettingsProvider>();
    final languageCode = appSettings.languageCode;
    final String langName = switch (languageCode) {
      'vi' => 'Tiếng Việt',
      'ko' => '한국어',
      _ => 'English',
    };

    return Column(
      children: [
        SettingTile(
          icon: Icons.person_outline,
          title: AppTranslations.getText(languageCode, 'st_personal_info'),
          trailingText: null,
          onTap: onEditPersonal,
        ),
        Consumer<CurrencyProvider>(
          builder: (context, currencyProvider, _) => SettingTile(
            icon: Icons.currency_exchange,
            title: AppTranslations.getText(languageCode, 'st_currency'),
            trailingText:
                '${currencyProvider.selected.code} (${currencyProvider.selected.symbol})',
            onTap: () => onOpenCurrency(currencyProvider),
          ),
        ),
        SettingTile(
          icon: Icons.language,
          title: AppTranslations.getText(languageCode, 'st_language'),
          trailingText: langName,
          onTap: () => onOpenLanguage(appSettings),
        ),
      ],
    );
  }
}
```

Similarly, translate `SecuritySection`, `SupportSection`, `BackupSection`, `LogoutSection`.
For `LogoutSection` dialog titles and content, use keys:
`st_logout_confirm_title`, `st_logout_confirm_body`, `st_cancel`, `st_logout`.

- [ ] **Step 2: Translate Personal Information Screen form inputs, validation, and read-only labels**

Add import to `lib/firstscreen/personal_information_screen.dart`:
```dart
import 'package:flutter_application_1/providers/app_translations.dart';
```

Replace `isVietnamese` usages and titles:
```dart
  Widget build(BuildContext context) {
    final appSettings = context.watch<AppSettingsProvider>();
    final userProfile = context.watch<UserProfileProvider>();
    final languageCode = appSettings.languageCode;
    final isVietnamese = languageCode == 'vi'; // Kept for format checking, or replace entirely
...
```
Replace form titles and field names with `AppTranslations.getText(languageCode, <key>)`.
For example, field names: `pi_full_name`, `pi_username`, `pi_bio`, `pi_email`, `pi_user_id`, `pi_join_date`, `pi_app_version`, `pi_save_changes`.

- [ ] **Step 3: Run tests to verify compilation**

Run: `flutter test test/user_profile_provider_test.dart`
Expected: PASS

- [ ] **Step 4: Commit changes**

```bash
git add lib/firstscreen/settings_components/settings_sections.dart lib/firstscreen/personal_information_screen.dart
git commit -m "feat: translate settings sections and personal information screen"
```

---

### Task 4: Translate Dashboard Components

**Files:**
- Modify: `lib/firstscreen/dashboard_components/dashboard_components.dart`

**Interfaces:**
- Consumes: `lib/providers/app_translations.dart`
- Produces: Translated dashboard categories, balance titles, and date formats

- [ ] **Step 1: Translate Dashboard titles, income/expense labels, history, and empty states**

Add import to `lib/firstscreen/dashboard_components/dashboard_components.dart`:
```dart
import 'package:flutter_application_1/providers/app_translations.dart';
```

Modify text titles in widgets inside `lib/firstscreen/dashboard_components/dashboard_components.dart`:
- Replace `isVietnamese ? 'SỐ DƯ HIỆN TẠI' : 'CURRENT BALANCE'` with `AppTranslations.getText(localeCode, 'db_current_balance')`
- Replace `isVietnamese ? 'THU NHẬP' : 'INCOME'` with `AppTranslations.getText(localeCode, 'db_income')`
- Replace `isVietnamese ? 'CHI TIÊU' : 'EXPENSE'` with `AppTranslations.getText(localeCode, 'db_expense')`
- Replace `isVietnamese ? 'Lịch sử giao dịch' : 'Transaction History'` with `AppTranslations.getText(localeCode, 'db_history')`
- Replace `isVietnamese ? 'Tất cả' : 'All'` with `AppTranslations.getText(localeCode, 'db_all')`
- Replace `isVietnamese ? 'Chưa có giao dịch nào' : 'No transactions yet'` with `AppTranslations.getText(localeCode, 'db_empty')`

- [ ] **Step 2: Update formatGroupHeading and getTxMeta**

Modify `formatGroupHeading` to support Korean:
```dart
String formatGroupHeading(DateTime day, DateTime now, String languageCode) {
  final isToday = day.year == now.year &&
      day.month == now.month &&
      day.day == now.day;
  if (isToday) {
    return AppTranslations.getText(languageCode, 'db_today');
  }

  final isYesterday = day.year == now.year &&
      day.month == now.month &&
      day.day == now.day - 1; // Wait, simple yesterday logic
  if (isYesterday) {
    return AppTranslations.getText(languageCode, 'db_yesterday');
  }

  return DateFormat(languageCode == 'vi' ? 'dd MMMM yyyy' : 'MMMM dd, yyyy').format(day);
}
```

Modify `getTxMeta` to translate category labels:
```dart
TxVisualMeta getTxMeta(String title, bool isIncome, String languageCode) {
  final clean = title.trim().toLowerCase();
  if (clean.contains('eat') || clean.contains('food') || clean.contains('ăn') || clean.contains('uống')) {
    return TxVisualMeta(
      icon: Icons.restaurant,
      color: const Color(0xFFE74C3C),
      subtitle: AppTranslations.getText(languageCode, 'cat_food'),
    );
  }
  if (clean.contains('go') || clean.contains('bus') || clean.contains('taxi') || clean.contains('xe') || clean.contains('di chuyển')) {
    return TxVisualMeta(
      icon: Icons.directions_bus,
      color: const Color(0xFF3498DB),
      subtitle: AppTranslations.getText(languageCode, 'cat_transport'),
    );
  }
  if (isIncome) {
    return TxVisualMeta(
      icon: Icons.arrow_downward,
      color: const Color(0xFF2ECC71),
      subtitle: AppTranslations.getText(languageCode, 'cat_income'),
    );
  }
  return TxVisualMeta(
    icon: Icons.category,
    color: const Color(0xFF95A5A6),
    subtitle: AppTranslations.getText(languageCode, 'cat_other'),
  );
}
```

- [ ] **Step 3: Run tests to verify compilation**

Run: `flutter test test/user_profile_provider_test.dart`
Expected: PASS

- [ ] **Step 4: Commit changes**

```bash
git add lib/firstscreen/dashboard_components/dashboard_components.dart
git commit -m "feat: translate dashboard widgets, categories, and date group formatting"
```
