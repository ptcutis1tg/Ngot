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
