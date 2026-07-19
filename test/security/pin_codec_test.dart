import 'package:flutter_application_1/security/pin_codec.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
}
