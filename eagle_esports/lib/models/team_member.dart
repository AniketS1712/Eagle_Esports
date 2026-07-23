/// Mirrors the `team_members` junction table.
class TeamMember {
  final String id;
  final String teamId;
  final String userId;
  final bool isLeader;
  final DateTime joinedAt;

  const TeamMember({
    required this.id,
    required this.teamId,
    required this.userId,
    required this.isLeader,
    required this.joinedAt,
  });

  factory TeamMember.fromMap(Map<String, dynamic> map) {
    return TeamMember(
      id: map['id'] as String,
      teamId: map['team_id'] as String,
      userId: map['user_id'] as String,
      isLeader: map['is_leader'] as bool,
      joinedAt: DateTime.parse(map['joined_at'] as String),
    );
  }

  /// Use when a teammate joins via invite code. is_leader defaults
  /// to false in DB — the leader's row is auto-created by a trigger
  /// when the team is created, so you never insert that one manually.
  Map<String, dynamic> toMap() {
    return {
      'team_id': teamId,
      'user_id': userId,
    };
  }

  TeamMember copyWith({
    bool? isLeader,
  }) {
    return TeamMember(
      id: id,
      teamId: teamId,
      userId: userId,
      isLeader: isLeader ?? this.isLeader,
      joinedAt: joinedAt,
    );
  }
}
