import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_1/supabase_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('Test Supabase Initialization', () async {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});

    print('URL: ${SupabaseConfig.url}');
    print('Key: ${SupabaseConfig.publishableKey}');
    
    try {
      SupabaseConfig.validate();
      await Supabase.initialize(
        url: SupabaseConfig.url,
        anonKey: SupabaseConfig.publishableKey,
      );
      print('Supabase initialized successfully!');
    } catch (e, stack) {
      print('Initialization failed: $e');
      print(stack);
      rethrow;
    }
  });
}
