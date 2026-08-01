/// Mirrors the `tournament_matches` table — one row per round.
class TournamentMatch {
  final String id;
  final String tournamentId;
  final int matchNumber;
  final DateTime createdAt;

  const TournamentMatch({
    required this.id,
    required this.tournamentId,
    required this.matchNumber,
    required this.createdAt,
  });

  factory TournamentMatch.fromMap(Map<String, dynamic> map) {
    return TournamentMatch(
      id: map['id'] as String,
      tournamentId: map['tournament_id'] as String,
      matchNumber: map['match_number'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {'tournament_id': tournamentId, 'match_number': matchNumber};
  }

  TournamentMatch copyWith({int? matchNumber}) {
    return TournamentMatch(
      id: id,
      tournamentId: tournamentId,
      matchNumber: matchNumber ?? this.matchNumber,
      createdAt: createdAt,
    );
  }
}
