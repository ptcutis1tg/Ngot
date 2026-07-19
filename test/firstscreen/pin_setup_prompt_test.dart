import 'package:flutter/material.dart';
import 'package:flutter_application_1/firstscreen/pin_setup_prompt.dart';
import 'package:flutter_application_1/providers/pin_provider.dart';
import 'package:flutter_application_1/providers/app_settings_provider.dart';
import 'package:flutter_application_1/security/pin_codec.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

class FakePinAuthClient implements PinAuthClient {
  FakePinAuthClient(
      {this.metadata = const {}, this.email = 'user@example.com'});
  Map<String, dynamic> metadata;
  @override
  String? email;
  Map<String, dynamic>? lastUpdate;
  String? recoveryEmail;

  @override
  Map<String, dynamic>? get userMetadata => metadata;
  @override
  Future<void> updateMetadata(Map<String, dynamic> value) async {
    lastUpdate = value;
    metadata = value;
  }

  @override
  Future<void> sendRecoveryEmail(String value) async => recoveryEmail = value;
}

void main() {
  testWidgets('shows setup prompt when the account has no PIN', (tester) async {
    final provider = PinProvider(FakePinAuthClient(), codec: PinCodec());
    await provider.refresh();
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: provider),
        ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
      ],
      child: MaterialApp(
          home: Builder(
              builder: (context) => ElevatedButton(
                    onPressed: () => showPinSetupPrompt(context),
                    child: const Text('open'),
                  ))),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('Thiết lập PIN'), findsOneWidget);
    expect(find.text('Để sau'), findsOneWidget);
  });

  testWidgets('does not show setup prompt when account has a PIN',
      (tester) async {
    final codec = PinCodec();
    final provider = PinProvider(
      FakePinAuthClient(metadata: {'pin': codec.createRecord('012345')}),
      codec: codec,
    );
    await provider.refresh();
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: provider),
        ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
      ],
      child: MaterialApp(
          home: Builder(
              builder: (context) => ElevatedButton(
                    onPressed: () => showPinSetupPrompt(context),
                    child: const Text('open'),
                  ))),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('Thiết lập PIN'), findsNothing);
  });
}
