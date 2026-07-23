import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:eagle_esports/models/wallet.dart';
import 'package:eagle_esports/models/wallet_transaction.dart';

/// Read-only data source for wallet, transaction history, and topup options.
///
/// Flutter never writes to `wallets` or `wallet_transactions` directly —
/// all mutations go through server-side Postgres functions or the Node.js
/// backend.
class WalletRepository {
  final SupabaseClient _client;

  WalletRepository(this._client);

  /// Streams the current user's wallet in realtime.
  ///
  /// Uses Supabase Realtime to push balance changes as they happen
  /// (e.g. after a topup or tournament entry processed server-side).
  Stream<Wallet> watchWallet(String userId) {
    return _client
        .from('wallets')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((rows) => Wallet.fromMap(rows.first));
  }

  /// Fetches wallet transaction history for a user, most recent first.
  ///
  /// Optionally limited to [limit] rows (default 50).
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
        .then(
          (data) => data.map((r) => WalletTransaction.fromMap(r)).toList(),
        );
  }

  /// Fetches all active topup options ordered by [sort_order] ascending.
  ///
  /// No auth filtering — any authenticated user can view topup tiers.
  Future<List<Map<String, dynamic>>> fetchTopupOptions() {
    return _client
        .from('topup_options')
        .select()
        .eq('is_active', true)
        .order('sort_order', ascending: true);
  }
}
