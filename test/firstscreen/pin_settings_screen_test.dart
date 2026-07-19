import 'package:flutter/material.dart';
import 'package:flutter_application_1/firstscreen/pin_settings_screen.dart';
import 'package:flutter_application_1/providers/pin_provider.dart';
import 'package:flutter_application_1/providers/app_settings_provider.dart';
import 'package:flutter_application_1/security/pin_codec.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

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

void main() {
  testWidgets('requires matching six-digit PIN confirmation before saving', (tester) async {
    final provider = PinProvider(FakePinAuthClient(), codec: PinCodec());
    await provider.refresh();
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: provider),
        ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
      ],
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
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: provider),
        ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
      ],
      child: const MaterialApp(home: PinSettingsScreen()),
    ));
    final suggestion = provider.suggestedPin;
    await tester.tap(find.byKey(const Key('use-suggested-pin')));
    expect(tester.widget<TextFormField>(find.byKey(const Key('pin-input'))).controller!.text, suggestion);
  });
}
