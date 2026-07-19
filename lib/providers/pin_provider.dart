import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../security/pin_codec.dart';

abstract class PinAuthClient {
  Map<String, dynamic>? get userMetadata;
  String? get email;
  Future<void> updateMetadata(Map<String, dynamic> value);
  Future<void> sendRecoveryEmail(String email);
}

class SupabasePinAuthClient implements PinAuthClient {
  @override
  Map<String, dynamic>? get userMetadata =>
      Supabase.instance.client.auth.currentUser?.userMetadata;

  @override
  String? get email => Supabase.instance.client.auth.currentUser?.email;

  @override
  Future<void> updateMetadata(Map<String, dynamic> value) async {
    await Supabase.instance.client.auth.updateUser(
      UserAttributes(data: value),
    );
  }

  @override
  Future<void> sendRecoveryEmail(String email) async {
    await Supabase.instance.client.auth.resetPasswordForEmail(email);
  }
}

class PinProvider extends ChangeNotifier {
  final PinAuthClient auth;
  final PinCodec codec;

  bool _hasPin = false;
  String _suggestedPin = '';

  bool get hasPin => _hasPin;
  String get suggestedPin => _suggestedPin;

  PinProvider(this.auth, {PinCodec? codec}) : codec = codec ?? PinCodec() {
    _suggestedPin = this.codec.suggestPin();
  }

  Future<void> refresh() async {
    final metadata = auth.userMetadata;
    final pinRecord = metadata?['pin'];
    _hasPin = codec.hasValidRecord(pinRecord);
    _suggestedPin = codec.suggestPin();
    notifyListeners();
  }

  Future<String?> savePin({
    required String pin,
    required String confirmation,
    String? currentPin,
  }) async {
    if (!codec.isValidPin(pin)) {
      return 'Mã PIN phải gồm đúng 6 chữ số';
    }
    if (pin != confirmation) {
      return 'PIN xác nhận không khớp';
    }

    final metadata = auth.userMetadata ?? {};
    final existingRecord = metadata['pin'];

    if (codec.hasValidRecord(existingRecord)) {
      if (currentPin == null) {
        return 'Vui lòng nhập PIN hiện tại';
      }
      if (!codec.verify(currentPin, existingRecord)) {
        return 'PIN hiện tại không đúng';
      }
    }

    try {
      final newRecord = codec.createRecord(pin);
      final newMetadata = Map<String, dynamic>.from(metadata);
      newMetadata['pin'] = newRecord;

      await auth.updateMetadata(newMetadata);
      await refresh();
      return null;
    } catch (e) {
      return 'Lỗi lưu PIN: ${e.toString()}';
    }
  }

  Future<String?> removePin(String currentPin) async {
    final metadata = auth.userMetadata ?? {};
    final existingRecord = metadata['pin'];

    if (!codec.hasValidRecord(existingRecord)) {
      return null;
    }

    if (!codec.verify(currentPin, existingRecord)) {
      return 'PIN hiện tại không đúng';
    }

    try {
      final newMetadata = Map<String, dynamic>.from(metadata);
      newMetadata['pin'] = null;

      await auth.updateMetadata(newMetadata);
      await refresh();
      return null;
    } catch (e) {
      return 'Lỗi xóa PIN: ${e.toString()}';
    }
  }

  Future<String?> sendRecoveryEmail() async {
    final email = auth.email;
    if (email == null || email.isEmpty) {
      return 'Không tìm thấy email tài khoản';
    }
    try {
      await auth.sendRecoveryEmail(email);
      return null;
    } catch (e) {
      return 'Lỗi gửi email: ${e.toString()}';
    }
  }
}
