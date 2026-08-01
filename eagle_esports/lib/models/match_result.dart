/// Mirrors the `match_results` table — per-team score for one match.
/// placement_points, kill_points, match_total are computed by a DB
/// trigger from the tournament's placement_points_map/kill_point_value
/// — Flutter only needs to send `placement` and `kills` on insert.
class MatchResult {
  final String id;
  final String matchId;
  final String teamId;
  final int placement;
  final int placementPoints;
  final int kills;
  final int killPoints;
  final int matchTotal;

  const MatchResult({
    required this.id,
    required this.matchId,
    required this.teamId,
    required this.placement,
    required this.placementPoints,
    required this.kills,
    required this.killPoints,
    required this.matchTotal,
  });

  factory MatchResult.fromMap(Map<String, dynamic> map) {
    return MatchResult(
      id: map['id'] as String,
      matchId: map['match_id'] as String,
      teamId: map['team_id'] as String,
      placement: map['placement'] as int,
      placementPoints: map['placement_points'] as int,
      kills: map['kills'] as int,
      killPoints: map['kill_points'] as int,
      matchTotal: map['match_total'] as int,
    );
  }

  /// Only send placement + kills — the rest are server-computed.
  Map<String, dynamic> toMap() {
    return {
      'match_id': matchId,
      'team_id': teamId,
      'placement': placement,
      'kills': kills,
    };
  }

  MatchResult copyWith({int? placement, int? kills}) {
    return MatchResult(
      id: id,
      matchId: matchId,
      teamId: teamId,
      placement: placement ?? this.placement,
      placementPoints: placementPoints,
      kills: kills ?? this.kills,
      killPoints: killPoints,
      matchTotal: matchTotal,
    );
  }
}
