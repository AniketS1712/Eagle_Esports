/// Mirrors the `wallets` table. Read-only from Flutter's perspective —
/// balance only ever changes via the credit_wallet/debit_wallet RPC
/// functions, never via a direct UPDATE from the client.
class Wallet {
  final String id;
  final String userId;
  final double talonBalance;
  final DateTime updatedAt;

  const Wallet({
    required this.id,
    required this.userId,
    required this.talonBalance,
    required this.updatedAt,
  });

  factory Wallet.fromMap(Map<String, dynamic> map) {
    return Wallet(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      talonBalance: (map['talon_balance'] as num).toDouble(),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  /// No toMap() provided intentionally — wallets are never written
  /// to directly from Flutter. All balance changes go through
  /// supabase.rpc('pay_tournament_entry', ...) or similar functions.

  Wallet copyWith({
    double? talonBalance,
  }) {
    return Wallet(
      id: id,
      userId: userId,
      talonBalance: talonBalance ?? this.talonBalance,
      updatedAt: updatedAt,
    );
  }
}
