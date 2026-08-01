/// Mirrors the `topup_options` table — admin-editable list shown
/// on the Add Money screen.
class TopupOption {
  final String id;
  final double amount;
  final bool isActive;
  final int sortOrder;

  const TopupOption({
    required this.id,
    required this.amount,
    required this.isActive,
    required this.sortOrder,
  });

  factory TopupOption.fromMap(Map<String, dynamic> map) {
    return TopupOption(
      id: map['id'] as String,
      amount: (map['amount'] as num).toDouble(),
      isActive: map['is_active'] as bool,
      sortOrder: map['sort_order'] as int,
    );
  }

  // No toMap() — admin manages this table directly via Supabase
  // dashboard; Flutter only ever reads it.

  TopupOption copyWith({double? amount, bool? isActive, int? sortOrder}) {
    return TopupOption(
      id: id,
      amount: amount ?? this.amount,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
