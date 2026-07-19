import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_1/supabase_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('Test Supabase Initialization', () async {
    // Load env variables
    await dotenv.load(fileName: '.env');

    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});

    debugPrint('URL: ${SupabaseConfig.url}');
    debugPrint('Key: ${SupabaseConfig.publishableKey}');
    
    try {
      SupabaseConfig.validate();
      await Supabase.initialize(
        url: SupabaseConfig.url,
        publishableKey: SupabaseConfig.publishableKey,
      );
      debugPrint('Supabase initialized successfully!');
    } catch (e, stack) {
      debugPrint('Initialization failed: $e');
      debugPrint(stack.toString());
      rethrow;
    }
  });
}
