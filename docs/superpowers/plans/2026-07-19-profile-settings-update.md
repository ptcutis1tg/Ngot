# Profile Settings Update Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Modify the profile section in Settings to make it interactive, enabling avatar and username edits via the Personal Information screen while displaying the read-only registered email in both places.

**Architecture:** Wrap the Settings ProfileHeader in an `InkWell` and add a visual edit badge to the avatar. Clicking it navigates to `PersonalInformationScreen`. In `PersonalInformationScreen`, the email remains read-only but is populated using the registered email, while other fields (avatar, username) are editable and sync with `UserProfileProvider`.

**Tech Stack:** Flutter, Dart, Provider, SharedPreferences, Supabase Auth.

## Global Constraints

- The registered email address will remain read-only on the Personal Information screen and will only be displayed as reference, synced with Supabase authentication.

---

### Task 1: Write Unit Tests for UserProfileProvider

**Files:**
- Create: `test/user_profile_provider_test.dart`

**Interfaces:**
- Consumes: `lib/providers/userprofileprovider.dart`
- Produces: Test suite for `UserProfileProvider`

- [ ] **Step 1: Create the test file with unit tests**

Write `test/user_profile_provider_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/providers/userprofileprovider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('UserProfileProvider Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('should load default profile values', () async {
      final provider = UserProfileProvider();
      await provider.loadProfile();
      expect(provider.userName, '');
      expect(provider.userEmail, '');
      expect(provider.userAvatar, 'assets/user/anonymous.jpg');
    });

    test('should update and persist profile values', () async {
      final provider = UserProfileProvider();
      await provider.setUserName('John Doe');
      await provider.setUserEmail('john@example.com');
      await provider.setUserAvatar('custom_avatar.png');

      expect(provider.userName, 'John Doe');
      expect(provider.userEmail, 'john@example.com');
      expect(provider.userAvatar, 'custom_avatar.png');

      // Create a new instance and verify persistence
      final newProvider = UserProfileProvider();
      await newProvider.loadProfile();
      expect(newProvider.userName, 'John Doe');
      expect(newProvider.userEmail, 'john@example.com');
      expect(newProvider.userAvatar, 'custom_avatar.png');
    });
  });
}
```

- [ ] **Step 2: Run the test to verify it passes**

Run: `flutter test test/user_profile_provider_test.dart`
Expected: PASS

- [ ] **Step 3: Commit the test file**

```bash
git add test/user_profile_provider_test.dart
git commit -m "test: add unit tests for UserProfileProvider"
```

---

### Task 2: Make ProfileHeader Interactive and Navigate to Edit Screen

**Files:**
- Modify: `lib/firstscreen/settings_components/settings_sections.dart`

**Interfaces:**
- Consumes: `lib/firstscreen/personal_information_screen.dart`
- Produces: Interactive settings header with navigation and camera badge overlay

- [ ] **Step 1: Wrap ProfileHeader with InkWell and add navigation**

Replace `ProfileHeader` in `lib/firstscreen/settings_components/settings_sections.dart` with interactive wrapper and edit badge overlay.

```dart
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, userProfile, _) {
        final theme = Theme.of(context);
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PersonalInformationScreen(),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            color: layerColor(context, 1),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      key: ValueKey<String>(userProfile.userAvatar),
                      radius: 35,
                      backgroundImage: avatarProvider(userProfile.userAvatar),
                    ),
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFF2ECC71),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
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
          ),
        );
      },
    );
  }
}
```

- [ ] **Step 2: Run the test to ensure no compilation issues**

Run: `flutter test test/user_profile_provider_test.dart`
Expected: PASS

- [ ] **Step 3: Commit the changes**

```bash
git add lib/firstscreen/settings_components/settings_sections.dart
git commit -m "feat: make profile header interactive with edit badge overlay"
```

---

### Task 3: Ensure PersonalInformationScreen correctly displays Email address and updates Name/Avatar

**Files:**
- Modify: `lib/firstscreen/personal_information_screen.dart`

**Interfaces:**
- Consumes: `lib/providers/userprofileprovider.dart`
- Produces: Complete profile edit screen displaying read-only registered email and editable avatar/username

- [ ] **Step 1: Check existing read-only field implementation and ensure it uses correct registered email**

Verify that `personal_information_screen.dart` uses `UserProfileProvider` email or Supabase email as the value of the email field. Since it already has:
```dart
                      // Email
                      _buildReadOnlyField(
                        label: isVietnamese ? 'Địa chỉ Email' : 'Email Address',
                        value: context.read<UserProfileProvider>().userEmail.isNotEmpty
                            ? context.read<UserProfileProvider>().userEmail
                            : (supabaseUser?.email ?? 'N/A'),
                        icon: Icons.email_outlined,
                        bgColor: readOnlyBgColor,
                        labelColor: labelColor,
                        valueColor: textOnCardColor,
                      ),
```
Ensure it matches the specification and loads correctly on launch. Make sure to use `context.watch<UserProfileProvider>()` for state updates so if anything changes, the UI updates.

Modify `_PersonalInformationScreenBody` build method:
```dart
  @override
  Widget build(BuildContext context) {
    final appSettings = context.watch<AppSettingsProvider>();
    final userProfile = context.watch<UserProfileProvider>(); // Use watch for updates
    final isVietnamese = appSettings.languageCode == 'vi';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Theme colors matching the premium look of the app
    final cardBgColor = isDark ? const Color(0xFF0F3124) : const Color(0xFFF0F5F2);
    final borderColor = isDark ? const Color(0xFF165C40) : const Color(0xFFD0E0D8);
    final textOnCardColor = isDark ? const Color(0xFFE5F4EB) : const Color(0xFF103A27);
    final labelColor = isDark ? const Color(0xFF98AF9F) : const Color(0xFF557F67);
    final readOnlyBgColor = isDark ? const Color(0xFF082218) : const Color(0xFFE5EDE9);

    // Get current User Metadata from Supabase
    final supabaseUser = Supabase.instance.client.auth.currentUser;
    final userId = supabaseUser?.id ?? 'Local_User';
    final rawCreatedAt = supabaseUser?.createdAt;
    String joinDate = '';
    if (rawCreatedAt != null) {
      try {
        final parsedDate = DateTime.parse(rawCreatedAt);
        joinDate = DateFormat(isVietnamese ? 'dd/MM/yyyy' : 'MM/dd/yyyy').format(parsedDate);
      } catch (_) {
        joinDate = rawCreatedAt;
      }
    } else {
      joinDate = isVietnamese ? 'Hôm nay' : 'Today';
    }
```
And replace the Email field value with:
```dart
                      // Email
                      _buildReadOnlyField(
                        label: isVietnamese ? 'Địa chỉ Email' : 'Email Address',
                        value: userProfile.userEmail.isNotEmpty
                            ? userProfile.userEmail
                            : (supabaseUser?.email ?? 'N/A'),
                        icon: Icons.email_outlined,
                        bgColor: readOnlyBgColor,
                        labelColor: labelColor,
                        valueColor: textOnCardColor,
                      ),
```

- [ ] **Step 2: Run the test to check health**

Run: `flutter test test/user_profile_provider_test.dart`
Expected: PASS

- [ ] **Step 3: Commit the changes**

```bash
git add lib/firstscreen/personal_information_screen.dart
git commit -m "feat: ensure personal information screen watches user profile state for updates"
```
