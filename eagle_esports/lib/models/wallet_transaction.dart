/// Mirrors the `wallet_transactions` table — an immutable audit log.
/// Read-only from Flutter; rows are inserted only by DB functions.
enum WalletTxType { credit, debit }

enum WalletTxCategory {
  topup,
  tournamentEntry,
  tournamentWinBonus,
  merchPurchase,
  refund,
}

enum WalletTxStatus { pending, completed, failed }

WalletTxType _txTypeFromString(String value) {
  return WalletTxType.values.firstWhere((e) => e.name == value);
}

WalletTxCategory _txCategoryFromString(String value) {
  // category values in DB use snake_case (e.g. tournament_entry)
  switch (value) {
    case 'topup':
      return WalletTxCategory.topup;
    case 'tournament_entry':
      return WalletTxCategory.tournamentEntry;
    case 'tournament_win_bonus':
      return WalletTxCategory.tournamentWinBonus;
    case 'merch_purchase':
      return WalletTxCategory.merchPurchase;
    case 'refund':
      return WalletTxCategory.refund;
    default:
      throw ArgumentError('Unknown wallet_tx_category: $value');
  }
}

WalletTxStatus _txStatusFromString(String value) {
  return WalletTxStatus.values.firstWhere((e) => e.name == value);
}

class WalletTransaction {
  final String id;
  final String walletId;
  final String userId;
  final WalletTxType type;
  final WalletTxCategory category;
  final double amount;
  final double balanceAfter;
  final String? referenceId;
  final String? description;
  final WalletTxStatus status;
  final DateTime createdAt;

  const WalletTransaction({
    required this.id,
    required this.walletId,
    required this.userId,
    required this.type,
    required this.category,
    required this.amount,
    required this.balanceAfter,
    this.referenceId,
    this.description,
    required this.status,
    required this.createdAt,
  });

  factory WalletTransaction.fromMap(Map<String, dynamic> map) {
    return WalletTransaction(
      id: map['id'] as String,
      walletId: map['wallet_id'] as String,
      userId: map['user_id'] as String,
      type: _txTypeFromString(map['type'] as String),
      category: _txCategoryFromString(map['category'] as String),
      amount: (map['amount'] as num).toDouble(),
      balanceAfter: (map['balance_after'] as num).toDouble(),
      referenceId: map['reference_id'] as String?,
      description: map['description'] as String?,
      status: _txStatusFromString(map['status'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  // No toMap() — this table is never written to directly from Flutter.

  WalletTransaction copyWith({
    WalletTxStatus? status,
  }) {
    return WalletTransaction(
      id: id,
      walletId: walletId,
      userId: userId,
      type: type,
      category: category,
      amount: amount,
      balanceAfter: balanceAfter,
      referenceId: referenceId,
      description: description,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}
