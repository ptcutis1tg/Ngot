import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class PinCodec {
  static const int _iterations = 120000;
  static const int _keyLength = 32;
  static const int _saltLength = 16;

  final RegExp _pinRegex = RegExp(r'^[0-9]{6}$');

  bool isValidPin(String pin) {
    return _pinRegex.hasMatch(pin);
  }

  String suggestPin() {
    final random = Random.secure();
    final pinVal = random.nextInt(1000000);
    return pinVal.toString().padLeft(6, '0');
  }

  Map<String, dynamic> createRecord(String pin) {
    if (!isValidPin(pin)) {
      throw ArgumentError('Mã PIN phải gồm đúng 6 chữ số.');
    }
    final saltBytes =
        List<int>.generate(_saltLength, (_) => Random.secure().nextInt(256));
    final salt = base64UrlEncode(saltBytes);
    final hashBytes = _pbkdf2(
      pin: pin,
      salt: saltBytes,
      iterations: _iterations,
      keyLength: _keyLength,
    );
    final hash = base64UrlEncode(hashBytes);
    return {
      'version': 1,
      'salt': salt,
      'hash': hash,
    };
  }

  bool hasValidRecord(Object? record) {
    if (record is! Map<String, dynamic>) {
      return false;
    }
    final version = record['version'];
    final salt = record['salt'];
    final hash = record['hash'];
    if (version != 1 || salt is! String || hash is! String) {
      return false;
    }
    return true;
  }

  bool verify(String pin, Object? record) {
    if (!isValidPin(pin) || !hasValidRecord(record)) {
      return false;
    }
    final recordMap = record as Map<String, dynamic>;
    try {
      final saltBytes = base64Url.decode(recordMap['salt'] as String);
      final expectedHash = base64Url.decode(recordMap['hash'] as String);
      final actualHash = _pbkdf2(
        pin: pin,
        salt: saltBytes,
        iterations: _iterations,
        keyLength: expectedHash.length,
      );
      return _constantTimeEquals(actualHash, expectedHash);
    } catch (_) {
      return false;
    }
  }

  List<int> _pbkdf2({
    required String pin,
    required List<int> salt,
    required int iterations,
    int keyLength = 32,
  }) {
    final hmac = Hmac(sha256, utf8.encode(pin));
    final blockCount = (keyLength / sha256.convert([]).bytes.length).ceil();
    final derivedKey = <int>[];

    for (var block = 1; block <= blockCount; block++) {
      final blockSalt = [
        ...salt,
        (block >> 24) & 0xff,
        (block >> 16) & 0xff,
        (block >> 8) & 0xff,
        block & 0xff,
      ];
      var previous = hmac.convert(blockSalt).bytes;
      final output = List<int>.from(previous);

      for (var i = 1; i < iterations; i++) {
        previous = hmac.convert(previous).bytes;
        for (var j = 0; j < output.length; j++) {
          output[j] ^= previous[j];
        }
      }

      derivedKey.addAll(output);
    }

    return derivedKey.take(keyLength).toList();
  }

  bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) {
      return false;
    }

    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }
}
