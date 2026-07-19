import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/transaction_provider.dart';

class SyncService {
  final _supabase = Supabase.instance.client;

  Future<void> syncTransactions(TransactionProvider provider) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;
    
    // Basic structural skeleton for future sync logic
    // 1. Fetch remote data > last sync
    // 2. Resolve conflicts
    // 3. Upsert local changes to remote
  }
}
