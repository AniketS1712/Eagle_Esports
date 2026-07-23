/// Mirrors the `leaderboard` table — final aggregated standings.
/// Read-only from Flutter; written only by the complete_tournament
/// RPC function.
class LeaderboardEntry {
  final String id;
  final String tournamentId;
  final String teamId;
  final int totalKills;
  final int totalPoints;
  final int? rank;
  final double prizeAwarded;

  const LeaderboardEntry({
    required this.id,
    required this.tournamentId,
    required this.teamId,
    required this.totalKills,
    required this.totalPoints,
    this.rank,
    required this.prizeAwarded,
  });

  factory LeaderboardEntry.fromMap(Map<String, dynamic> map) {
    return LeaderboardEntry(
      id: map['id'] as String,
      tournamentId: map['tournament_id'] as String,
      teamId: map['team_id'] as String,
      totalKills: map['total_kills'] as int,
      totalPoints: map['total_points'] as int,
      rank: map['rank'] as int?,
      prizeAwarded: (map['prize_awarded'] as num).toDouble(),
    );
  }

  // No toMap() — this table is never written to directly from Flutter.

  LeaderboardEntry copyWith({
    int? totalKills,
    int? totalPoints,
    int? rank,
    double? prizeAwarded,
  }) {
    return LeaderboardEntry(
      id: id,
      tournamentId: tournamentId,
      teamId: teamId,
      totalKills: totalKills ?? this.totalKills,
      totalPoints: totalPoints ?? this.totalPoints,
      rank: rank ?? this.rank,
      prizeAwarded: prizeAwarded ?? this.prizeAwarded,
    );
  }
}
