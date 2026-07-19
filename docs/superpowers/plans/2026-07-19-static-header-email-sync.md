# Static Header and Email Sync Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Revert the ProfileHeader to a static (non-interactive) component and add automated email synchronization with Supabase signup and login flows.

**Architecture:** Modify `settings_sections.dart` to remove the clickable wrapper and camera badge from `ProfileHeader`. Modify `onboarding_flow.dart` to listen to auth state changes and sync the registered email with `UserProfileProvider` upon successful signup and login.

**Tech Stack:** Flutter, Dart, Provider, SharedPreferences, Supabase Auth.

## Global Constraints

- The settings header will only show static avatar, name, and email (it will not be clickable to navigate to the personal information screen).
- After registration/login, the email in the header will automatically display the registered account email.

---

### Task 1: Revert Settings Screen ProfileHeader to be Static

**Files:**
- Modify: `lib/firstscreen/settings_components/settings_sections.dart`

**Interfaces:**
- Consumes: `lib/providers/userprofileprovider.dart`
- Produces: Static profile header in Settings Screen

- [ ] **Step 1: Revert ProfileHeader back to static Container and remove edit badge**

Modify `ProfileHeader` class in `lib/firstscreen/settings_components/settings_sections.dart`:

```dart
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, userProfile, _) {
        final theme = Theme.of(context);
        return Container(
          padding: const EdgeInsets.all(20),
          color: layerColor(context, 1),
          child: Row(
            children: [
              CircleAvatar(
                key: ValueKey<String>(userProfile.userAvatar),
                radius: 35,
                backgroundImage: avatarProvider(userProfile.userAvatar),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userProfile.userName.isNotEmpty
                          ? userProfile.userName
                          : 'Guest',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      userProfile.userEmail.isNotEmpty
                          ? userProfile.userEmail
                          : 'No email',
                      style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

- [ ] **Step 2: Run tests to verify compilation**

Run: `flutter test test/user_profile_provider_test.dart`
Expected: PASS

- [ ] **Step 3: Commit the changes**

```bash
git add lib/firstscreen/settings_components/settings_sections.dart
git commit -m "feat: revert settings ProfileHeader to static container"
```

---

### Task 2: Synchronize Email on Registration and Login

**Files:**
- Modify: `lib/firstscreen/onboarding_flow.dart`

**Interfaces:**
- Consumes: `lib/providers/userprofileprovider.dart`
- Produces: Automated email synchronization inside Onboarding Flow

- [ ] **Step 1: Add import for UserProfileProvider and register auth subscription**

Import `userprofileprovider.dart` at the top of `lib/firstscreen/onboarding_flow.dart`:
```dart
import 'package:flutter_application_1/providers/userprofileprovider.dart';
```

Modify `_AppLaunchGateState` in `lib/firstscreen/onboarding_flow.dart` to subscribe to auth state changes and update profile provider.

```dart
class _AppLaunchGateState extends State<AppLaunchGate> {
  bool _isLoading = true;
  bool _completedOnboarding = false;
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
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
    _authSubscription?.cancel();
    super.dispose();
  }
```

- [ ] **Step 2: Ensure email is saved locally immediately upon signup**

Add immediate save to profile provider inside `_handleSupabaseAuth()` under `signUp` block in `lib/firstscreen/onboarding_flow.dart`:

```dart
        await Supabase.instance.client.auth.signUp(
          email: email,
          password: password,
        );
        if (mounted) {
          await context.read<UserProfileProvider>().setUserEmail(email);
        }
        _showMessage('Đăng ký thành công! Vui lòng đăng nhập.');
        await _handlePostAuth();
```

- [ ] **Step 3: Run tests to verify compilation**

Run: `flutter test test/user_profile_provider_test.dart`
Expected: PASS

- [ ] **Step 4: Commit the changes**

```bash
git add lib/firstscreen/onboarding_flow.dart
git commit -m "feat: sync email with profile provider on login and signup"
```
