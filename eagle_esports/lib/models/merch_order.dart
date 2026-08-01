/// Mirrors the `merch_orders` table — digital redemption only,
/// no shipping/refund fields since items are gift cards/top-up codes.
enum MerchOrderStatus { pending, fulfilled }

MerchOrderStatus _orderStatusFromString(String value) {
  return MerchOrderStatus.values.firstWhere((e) => e.name == value);
}

class MerchOrder {
  final String id;
  final String userId;
  final String merchItemId;
  final int quantity;
  final double talonSpent;
  final MerchOrderStatus status;
  final String? fulfillmentNote;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MerchOrder({
    required this.id,
    required this.userId,
    required this.merchItemId,
    required this.quantity,
    required this.talonSpent,
    required this.status,
    this.fulfillmentNote,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MerchOrder.fromMap(Map<String, dynamic> map) {
    return MerchOrder(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      merchItemId: map['merch_item_id'] as String,
      quantity: map['quantity'] as int,
      talonSpent: (map['talon_spent'] as num).toDouble(),
      status: _orderStatusFromString(map['status'] as String),
      fulfillmentNote: map['fulfillment_note'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  /// Use for the initial INSERT (redeeming an item). talon_spent is
  /// computed server-side by a trigger (price × quantity) — you can
  /// still send a client-side estimate for optimistic UI, but the DB
  /// value is authoritative and will overwrite it.
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'merch_item_id': merchItemId,
      'quantity': quantity,
    };
  }

  MerchOrder copyWith({MerchOrderStatus? status, String? fulfillmentNote}) {
    return MerchOrder(
      id: id,
      userId: userId,
      merchItemId: merchItemId,
      quantity: quantity,
      talonSpent: talonSpent,
      status: status ?? this.status,
      fulfillmentNote: fulfillmentNote ?? this.fulfillmentNote,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
