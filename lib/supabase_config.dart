import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  static String get url => dotenv.env['SUPABASE_URL'] ?? '';

  static String get publishableKey => dotenv.env['SUPABASE_PUBLISHABLE_KEY'] ?? '';

  static void validate() {
    if (url.isEmpty || publishableKey.isEmpty) {
      throw StateError(
        'Missing Supabase environment values. Please make sure .env file is correctly configured.',
      );
    }
  }
}
