import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:eagle_esports/models/wallet.dart';
import 'package:eagle_esports/models/wallet_transaction.dart';

class WalletRepository {
  final SupabaseClient _client;

  WalletRepository(this._client);

  Stream<Wallet> watchWallet(String userId) {
    return _client
        .from('wallets')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .where((rows) => rows.isNotEmpty)
        .map((rows) => Wallet.fromMap(rows.first));
  }

  Future<List<WalletTransaction>> fetchTransactions(
    String userId, {
    int limit = 50,
  }) {
    return _client
        .from('wallet_transactions')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(limit)
        .then((data) => data.map((r) => WalletTransaction.fromMap(r)).toList());
  }

  Future<List<Map<String, dynamic>>> fetchTopupOptions() {
    return _client
        .from('topup_options')
        .select()
        .eq('is_active', true)
        .order('sort_order', ascending: true);
  }
}
