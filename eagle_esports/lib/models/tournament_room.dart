/// Mirrors the `tournament_rooms` table. Only fetched after payment
/// is confirmed and revealed_at is set (enforced by RLS, not just UI).
class TournamentRoom {
  final String id;
  final String tournamentId;
  final String? roomId;
  final String? roomPassword;
  final DateTime? revealedAt;

  const TournamentRoom({
    required this.id,
    required this.tournamentId,
    this.roomId,
    this.roomPassword,
    this.revealedAt,
  });

  factory TournamentRoom.fromMap(Map<String, dynamic> map) {
    return TournamentRoom(
      id: map['id'] as String,
      tournamentId: map['tournament_id'] as String,
      roomId: map['room_id'] as String?,
      roomPassword: map['room_password'] as String?,
      revealedAt: map['revealed_at'] != null
          ? DateTime.parse(map['revealed_at'] as String)
          : null,
    );
  }

  /// No toMap() — this table is only ever written via the
  /// start_tournament RPC function, never a direct insert/update.

  bool get isRevealed => revealedAt != null;

  TournamentRoom copyWith({
    String? roomId,
    String? roomPassword,
    DateTime? revealedAt,
  }) {
    return TournamentRoom(
      id: id,
      tournamentId: tournamentId,
      roomId: roomId ?? this.roomId,
      roomPassword: roomPassword ?? this.roomPassword,
      revealedAt: revealedAt ?? this.revealedAt,
    );
  }
}
