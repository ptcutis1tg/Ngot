# Account PIN Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox syntax for tracking.

**Goal:** Let each Supabase account optionally create, manage, and recover a synchronized six-digit PIN stored as a salted hash in Auth user metadata.

**Architecture:** A pure-Dart PIN codec owns validation, random suggestions, PBKDF2 records, and verification. A PinProvider owns metadata state behind a small Auth interface, while reusable UI handles setup after login, Profile management, and recovery-session PIN reset.

**Tech Stack:** Flutter, Provider, Supabase Flutter Auth, Dart crypto, flutter_test.

## Global Constraints

- PIN is exactly six ASCII digits, including leading zeroes.
- Store only version, salt, and hash in user_metadata.pin; never store or log a clear PIN.
- This is a convenience confirmation secret, not a strong authentication factor.
- Do not use PIN to change a Supabase password or create any Supabase table, RPC, or Edge Function.
- Preserve unrelated generated-plugin and lockfile changes already in the worktree.

---

### Task 1: Implement a tested PIN codec

**Files:**
- Create: lib/security/pin_codec.dart
- Create: test/security/pin_codec_test.dart

**Interfaces:**
- Produces PinCodec: suggestPin(), isValidPin(String), createRecord(String), verify(String, Object?), and hasValidRecord(Object?).
- createRecord returns a map with version 1, salt, and hash; it throws for invalid PIN.

- [ ] **Step 1: Write the failing tests**

~~~dart
test('accepts exactly six ASCII digits including leading zero', () {
  final codec = PinCodec();
  expect(codec.isValidPin('012345'), isTrue);
  expect(codec.isValidPin('12345'), isFalse);
  expect(codec.isValidPin('1234567'), isFalse);
  expect(codec.isValidPin('12a456'), isFalse);
});

test('creates a non-cleartext record that verifies only the source PIN', () {
  final codec = PinCodec();
  final record = codec.createRecord('012345');
  expect(record['version'], 1);
  expect(record['hash'], isNot('012345'));
  expect(codec.verify('012345', record), isTrue);
  expect(codec.verify('012346', record), isFalse);
});

test('rejects malformed records without throwing', () {
  final codec = PinCodec();
  expect(codec.hasValidRecord(null), isFalse);
  expect(codec.verify('012345', {'version': '1'}), isFalse);
});
~~~

- [ ] **Step 2: Run test to verify it fails**

Run: flutter test test/security/pin_codec_test.dart

Expected: FAIL because PinCodec does not exist.

- [ ] **Step 3: Write minimal implementation**

Create PinCodec using dart:convert, dart:math, and package:crypto/crypto.dart. Validate with RegExp for exactly six digits; generate with Random.secure().nextInt(1000000).toString().padLeft(6, '0'); use a fresh 16-byte salt and PBKDF2-HMAC-SHA256 with 120,000 iterations. Parse base64url records defensively and compare byte lists in constant time. Reuse the existing provider's PBKDF2 block-expansion algorithm only as source, without coupling to its local password state.

- [ ] **Step 4: Run test to verify it passes**

Run: flutter test test/security/pin_codec_test.dart

Expected: PASS, 3 tests.

- [ ] **Step 5: Commit**

~~~powershell
git add lib/security/pin_codec.dart test/security/pin_codec_test.dart
git commit -m "feat: add secure PIN codec"
~~~

### Task 2: Add a testable account-PIN provider

**Files:**
- Create: lib/providers/pin_provider.dart
- Create: test/providers/pin_provider_test.dart
- Modify: lib/main.dart lines 72-79

**Interfaces:**
- Consumes PinCodec.
- Produces PinAuthClient, exposing userMetadata, email, updateMetadata, and sendRecoveryEmail.
- Produces PinProvider with hasPin, suggestedPin, refresh(), savePin(pin, confirmation, currentPin?), removePin(currentPin), and sendRecoveryEmail().

- [ ] **Step 1: Write the failing provider tests**

~~~dart
class FakePinAuthClient implements PinAuthClient {
  FakePinAuthClient({this.metadata = const {}, this.email = 'user@example.com'});
  Map<String, dynamic> metadata;
  String? email;
  Map<String, dynamic>? lastUpdate;
  String? recoveryEmail;

  @override Map<String, dynamic>? get userMetadata => metadata;
  @override Future<void> updateMetadata(Map<String, dynamic> value) async {
    lastUpdate = value;
    metadata = value;
  }
  @override Future<void> sendRecoveryEmail(String value) async => recoveryEmail = value;
}

test('save writes only a valid PIN record to metadata', () async {
  final auth = FakePinAuthClient();
  final provider = PinProvider(auth, codec: PinCodec());
  expect(await provider.savePin(pin: '012345', confirmation: '012345'), isNull);
  expect(auth.lastUpdate!['pin']['hash'], isNot('012345'));
  expect(provider.hasPin, isTrue);
});

test('change and removal require the current correct PIN', () async {
  final codec = PinCodec();
  final auth = FakePinAuthClient(metadata: {'pin': codec.createRecord('012345')});
  final provider = PinProvider(auth, codec: codec);
  await provider.refresh();
  expect(await provider.savePin(pin: '654321', confirmation: '654321', currentPin: '000000'), 'PIN hiện tại không đúng');
  expect(await provider.removePin('012345'), isNull);
  expect(auth.lastUpdate!['pin'], isNull);
});
~~~

- [ ] **Step 2: Run test to verify it fails**

Run: flutter test test/providers/pin_provider_test.dart

Expected: FAIL because PinAuthClient and PinProvider do not exist.

- [ ] **Step 3: Write minimal implementation**

Define a PinAuthClient interface and a SupabasePinAuthClient adapter. The adapter reads Supabase.instance.client.auth.currentUser, merges existing metadata, calls auth.updateUser(UserAttributes(data: metadata)), and calls resetPasswordForEmail(email) for recovery. PinProvider validates confirmation, verifies currentPin before an existing PIN is changed or removed, updates only the pin metadata key, exposes a fresh suggestion on refresh, and returns user-safe Vietnamese errors rather than throwing expected validation errors. Register it in MultiProvider with ChangeNotifierProvider(create: (_) => PinProvider(SupabasePinAuthClient())..refresh()).

- [ ] **Step 4: Run test to verify it passes**

Run: flutter test test/providers/pin_provider_test.dart

Expected: PASS, 2 tests.

- [ ] **Step 5: Commit**

~~~powershell
git add lib/providers/pin_provider.dart lib/main.dart test/providers/pin_provider_test.dart
git commit -m "feat: persist account PIN metadata"
~~~

### Task 3: Build Profile PIN management screen

**Files:**
- Create: lib/firstscreen/pin_settings_screen.dart
- Modify: lib/firstscreen/personal_information_screen.dart lines 15-22 and 396-430
- Create: test/firstscreen/pin_settings_screen_test.dart

**Interfaces:**
- Consumes PinProvider.
- Produces PinSettingsScreen with isRecovery defaulting to false.
- Normal mode supports create/change/remove; recovery mode permits a new PIN without a current-PIN check.

- [ ] **Step 1: Write failing widget tests**

~~~dart
testWidgets('requires matching six-digit PIN confirmation before saving', (tester) async {
  final provider = PinProvider(FakePinAuthClient(), codec: PinCodec());
  await provider.refresh();
  await tester.pumpWidget(ChangeNotifierProvider.value(
    value: provider,
    child: const MaterialApp(home: PinSettingsScreen()),
  ));
  await tester.enterText(find.byKey(const Key('pin-input')), '012345');
  await tester.enterText(find.byKey(const Key('pin-confirmation')), '012346');
  await tester.tap(find.byKey(const Key('pin-save')));
  await tester.pump();
  expect(find.text('PIN xác nhận không khớp'), findsOneWidget);
});

testWidgets('fills entry with displayed suggestion', (tester) async {
  final provider = PinProvider(FakePinAuthClient(), codec: PinCodec());
  await provider.refresh();
  await tester.pumpWidget(ChangeNotifierProvider.value(
    value: provider,
    child: const MaterialApp(home: PinSettingsScreen()),
  ));
  final suggestion = provider.suggestedPin;
  await tester.tap(find.byKey(const Key('use-suggested-pin')));
  expect(tester.widget<TextField>(find.byKey(const Key('pin-input'))).controller!.text, suggestion);
});
~~~

- [ ] **Step 2: Run test to verify it fails**

Run: flutter test test/firstscreen/pin_settings_screen_test.dart

Expected: FAIL because PinSettingsScreen does not exist.

- [ ] **Step 3: Write minimal implementation**

Build the screen with numeric, obscured text fields named by the test keys; use FilteringTextInputFormatter.digitsOnly and maxLength 6; display the suggestion and a Dùng PIN gợi ý action. Save invokes PinProvider.savePin, displays its error, and pops with a success SnackBar. Normal mode with an existing PIN includes current-pin and Xóa PIN, which calls removePin only after current-PIN verification. Recovery mode omits change/removal controls.

Add a tappable Mã PIN card to PersonalInformationScreen immediately after its account-detail card. Use context.watch PinProvider to show Đã thiết lập or Chưa thiết lập and push PinSettingsScreen.

- [ ] **Step 4: Run test to verify it passes**

Run: flutter test test/firstscreen/pin_settings_screen_test.dart

Expected: PASS, 2 tests.

- [ ] **Step 5: Commit**

~~~powershell
git add lib/firstscreen/pin_settings_screen.dart lib/firstscreen/personal_information_screen.dart test/firstscreen/pin_settings_screen_test.dart
git commit -m "feat: add PIN profile management"
~~~

### Task 4: Prompt after login and reset PIN through recovery

**Files:**
- Create: lib/firstscreen/pin_setup_prompt.dart
- Modify: lib/firstscreen/onboarding_flow.dart lines 120-171
- Modify: lib/router/app_router.dart lines 1-35
- Modify: lib/main.dart lines 195-205
- Create: test/firstscreen/pin_setup_prompt_test.dart

**Interfaces:**
- Consumes PinProvider and PinSettingsScreen.
- Produces showPinSetupPrompt(BuildContext), which has no effect for an account with PIN and otherwise shows Thiết lập PIN / Để sau.
- Produces /reset-pin, rendering PinSettingsScreen in recovery mode.

- [ ] **Step 1: Write failing prompt tests**

~~~dart
testWidgets('shows setup prompt when the account has no PIN', (tester) async {
  final provider = PinProvider(FakePinAuthClient(), codec: PinCodec());
  await provider.refresh();
  await tester.pumpWidget(ChangeNotifierProvider.value(
    value: provider,
    child: MaterialApp(home: Builder(builder: (context) => ElevatedButton(
      onPressed: () => showPinSetupPrompt(context),
      child: const Text('open'),
    ))),
  ));
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  expect(find.text('Thiết lập PIN'), findsOneWidget);
  expect(find.text('Để sau'), findsOneWidget);
});
~~~

Add a second test with a valid metadata record and assert no dialog appears.

~~~dart
testWidgets('does not show setup prompt when account has a PIN', (tester) async {
  final codec = PinCodec();
  final provider = PinProvider(
    FakePinAuthClient(metadata: {'pin': codec.createRecord('012345')}),
    codec: codec,
  );
  await provider.refresh();
  await tester.pumpWidget(ChangeNotifierProvider.value(
    value: provider,
    child: MaterialApp(home: Builder(builder: (context) => ElevatedButton(
      onPressed: () => showPinSetupPrompt(context),
      child: const Text('open'),
    ))),
  ));
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  expect(find.text('Thiết lập PIN'), findsNothing);
});
~~~

- [ ] **Step 2: Run test to verify it fails**

Run: flutter test test/firstscreen/pin_setup_prompt_test.dart

Expected: FAIL because showPinSetupPrompt does not exist.

- [ ] **Step 3: Write minimal implementation**

Implement an AlertDialog whose Để sau action only closes it and whose Thiết lập PIN action opens PinSettingsScreen. In _handleSupabaseAuth, after successful sign-in or sign-up, call await context.read PinProvider refresh. Once the main screen is mounted, schedule showPinSetupPrompt through a post-frame callback.

Add /reset-pin to AppRouter. When Supabase emits AuthChangeEvent.passwordRecovery, navigate to /reset-pin instead of /update-password; retain the existing password-update route itself. In recovery mode, redirect to / if currentSession is absent. The PIN screen's Quên PIN action calls sendRecoveryEmail and informs the user that the email link lets them set a new PIN.

- [ ] **Step 4: Run tests to verify they pass**

Run: flutter test test/firstscreen/pin_setup_prompt_test.dart; flutter test

Expected: PASS with no failures.

- [ ] **Step 5: Commit**

~~~powershell
git add lib/firstscreen/pin_setup_prompt.dart lib/firstscreen/onboarding_flow.dart lib/router/app_router.dart lib/main.dart test/firstscreen/pin_setup_prompt_test.dart
git commit -m "feat: prompt for and recover account PIN"
~~~

### Task 5: Format and verify the complete feature

**Files:**
- Modify: only PIN files required to resolve analyzer issues.

- [ ] **Step 1: Format all modified Dart files**

Run: dart format lib/security/pin_codec.dart lib/providers/pin_provider.dart lib/firstscreen/pin_settings_screen.dart lib/firstscreen/pin_setup_prompt.dart lib/firstscreen/onboarding_flow.dart lib/firstscreen/personal_information_screen.dart lib/router/app_router.dart lib/main.dart test/security/pin_codec_test.dart test/providers/pin_provider_test.dart test/firstscreen/pin_settings_screen_test.dart test/firstscreen/pin_setup_prompt_test.dart

Expected: formatting completes without errors.

- [ ] **Step 2: Run static analysis**

Run: flutter analyze

Expected: no analyzer errors or warnings introduced by PIN code.

- [ ] **Step 3: Run the full test suite**

Run: flutter test

Expected: PASS with no failures.

- [ ] **Step 4: Inspect final changes**

Run: git diff --check; git status --short

Expected: no whitespace errors and no unrelated changes beyond pre-existing generated files.

- [ ] **Step 5: Commit any verification-only fixes**

~~~powershell
git add lib/security/pin_codec.dart lib/providers/pin_provider.dart lib/firstscreen/pin_settings_screen.dart lib/firstscreen/pin_setup_prompt.dart lib/firstscreen/onboarding_flow.dart lib/firstscreen/personal_information_screen.dart lib/router/app_router.dart lib/main.dart test/security/pin_codec_test.dart test/providers/pin_provider_test.dart test/firstscreen/pin_settings_screen_test.dart test/firstscreen/pin_setup_prompt_test.dart
git commit -m "test: verify account PIN flow"
~~~
