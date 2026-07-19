import 'package:flutter_application_1/providers/pin_provider.dart';
import 'package:flutter_application_1/security/pin_codec.dart';
import 'package:flutter_test/flutter_test.dart';

class FakePinAuthClient implements PinAuthClient {
  FakePinAuthClient(
      {this.metadata = const {}, this.email = 'user@example.com'});
  Map<String, dynamic> metadata;
  @override
  String? email;
  Map<String, dynamic>? lastUpdate;
  String? recoveryEmail;
  String? recoveryOtp;

  @override
  Map<String, dynamic>? get userMetadata => metadata;
  @override
  Future<void> updateMetadata(Map<String, dynamic> value) async {
    lastUpdate = value;
    metadata = value;
  }

  @override
  Future<void> sendRecoveryEmail(String emailValue, String otp) async {
    recoveryEmail = emailValue;
    recoveryOtp = otp;
  }
}

void main() {
  test('save writes only a valid PIN record to metadata', () async {
    final auth = FakePinAuthClient();
    final provider = PinProvider(auth, codec: PinCodec());
    expect(
        await provider.savePin(pin: '012345', confirmation: '012345'), isNull);
    expect(auth.lastUpdate!['pin']['hash'], isNot('012345'));
    expect(provider.hasPin, isTrue);
  });

  test('change and removal require the current correct PIN', () async {
    final codec = PinCodec();
    final auth =
        FakePinAuthClient(metadata: {'pin': codec.createRecord('012345')});
    final provider = PinProvider(auth, codec: codec);
    await provider.refresh();
    expect(
        await provider.savePin(
            pin: '654321', confirmation: '654321', currentPin: '000000'),
        'PIN hiện tại không đúng');
    expect(await provider.removePin('012345'), isNull);
    expect(auth.lastUpdate!['pin'], isNull);
  });
}
