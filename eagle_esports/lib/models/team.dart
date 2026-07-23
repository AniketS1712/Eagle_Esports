/// Mirrors the `teams` table. Solo mode also creates a team row
/// (1 member, no invite_code) for consistency with duo/squad.
enum TeamPaymentStatus { pending, paid, refunded }

TeamPaymentStatus _paymentStatusFromString(String value) {
  return TeamPaymentStatus.values.firstWhere((e) => e.name == value);
}

class Team {
  final String id;
  final String tournamentId;
  final String teamName;
  final String leaderId;
  final String? inGameLeaderName;
  final String? inviteCode;
  final int? slotNumber;
  final TeamPaymentStatus paymentStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Team({
    required this.id,
    required this.tournamentId,
    required this.teamName,
    required this.leaderId,
    this.inGameLeaderName,
    this.inviteCode,
    this.slotNumber,
    required this.paymentStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      id: map['id'] as String,
      tournamentId: map['tournament_id'] as String,
      teamName: map['team_name'] as String,
      leaderId: map['leader_id'] as String,
      inGameLeaderName: map['in_game_leader_name'] as String?,
      inviteCode: map['invite_code'] as String?,
      slotNumber: map['slot_number'] as int?,
      paymentStatus: _paymentStatusFromString(map['payment_status'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  /// Use for the initial INSERT when creating/joining a team.
  /// invite_code is server-generated (trigger) — omit it here.
  Map<String, dynamic> toMap() {
    return {
      'tournament_id': tournamentId,
      'team_name': teamName,
      'leader_id': leaderId,
      'in_game_leader_name': inGameLeaderName,
    };
  }

  Team copyWith({
    String? teamName,
    String? inGameLeaderName,
    TeamPaymentStatus? paymentStatus,
    int? slotNumber,
  }) {
    return Team(
      id: id,
      tournamentId: tournamentId,
      teamName: teamName ?? this.teamName,
      leaderId: leaderId,
      inGameLeaderName: inGameLeaderName ?? this.inGameLeaderName,
      inviteCode: inviteCode,
      slotNumber: slotNumber ?? this.slotNumber,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
