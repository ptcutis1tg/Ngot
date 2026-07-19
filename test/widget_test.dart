// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/providers/app_settings_provider.dart';
import 'package:flutter_application_1/providers/backup_provider.dart';
import 'package:flutter_application_1/providers/currency_provider.dart';
import 'package:flutter_application_1/providers/transaction_provider.dart';
import 'package:flutter_application_1/providers/userprofileprovider.dart';
import 'package:flutter_application_1/providers/pin_provider.dart';

class _FakePinAuth implements PinAuthClient {
  @override
  Map<String, dynamic>? get userMetadata => {};
  @override
  String? get email => 'test@example.com';
  @override
  Future<void> updateMetadata(Map<String, dynamic> value) async {}
  @override
  Future<void> sendRecoveryEmail(String email, String otp) async {}
}

void main() {
  testWidgets('DailyExpenseApp smoke test', (WidgetTester tester) async {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({
      'userAvatar': 'assets/user/anonymous.jpg',
      'userName': 'Test User',
      'userEmail': 'test@example.com',
      'onboarding_completed': true,
      'settings_language_code': 'en',
    });

    // Initialize Supabase placeholder for test execution
    await Supabase.initialize(
      url: 'https://placeholder.supabase.co',
      anonKey: 'placeholder',
      authOptions: const FlutterAuthClientOptions(
        autoRefreshToken: false,
      ),
    );

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TransactionProvider()),
          ChangeNotifierProvider(create: (_) => UserProfileProvider()),
          ChangeNotifierProvider(create: (_) => BackupProvider()),
          ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
          ChangeNotifierProvider(create: (_) => CurrencyProvider()),
          ChangeNotifierProvider(create: (_) => PinProvider(_FakePinAuth())),
        ],
        child: const MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('vi'),
            Locale('en'),
            Locale('ko'),
          ],
          home: MainNavigationScreen(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    // Verify that the BottomNavigationBar labels are present.
    expect(find.text('TRANG CHỦ'), findsOneWidget);
    expect(find.text('BÁO CÁO'), findsOneWidget);
    expect(find.text('NGÂN QUỸ'), findsOneWidget);
    expect(find.text('CÀI ĐẶT'), findsOneWidget);

    // Verify that the floating action button is present.
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
