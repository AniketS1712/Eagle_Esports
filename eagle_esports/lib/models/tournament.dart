/// Mirrors the `tournaments` table.
enum GameMode { solo, duo, squad }

enum TournamentStatus { draft, upcoming, live, completed, cancelled }

GameMode _gameModeFromString(String value) {
  return GameMode.values.firstWhere((e) => e.name == value);
}

TournamentStatus _statusFromString(String value) {
  return TournamentStatus.values.firstWhere((e) => e.name == value);
}

class Tournament {
  final String id;
  final String organiserId;
  final String title;
  final String? description;
  final String? bannerImageUrl;
  final GameMode gameMode;
  final int maxSlots;
  final int filledSlots;
  final double entryFee;
  final double prizePool;

  /// e.g. {"1": 1000, "2": 500, "3": 250} — rank -> Talon amount
  final Map<String, dynamic> prizeDistribution;

  /// e.g. {"1": 12, "2": 9, ...} — in-game placement -> points
  final Map<String, dynamic> placementPointsMap;

  final int killPointValue;
  final TournamentStatus status;
  final String? rules;
  final DateTime? registrationEndTime;
  final DateTime? startTime;

  /// Which of the 5 Flutter-side leaderboard UI templates to render (1-5)
  final int leaderboardTemplate;

  final DateTime createdAt;
  final DateTime updatedAt;

  const Tournament({
    required this.id,
    required this.organiserId,
    required this.title,
    this.description,
    this.bannerImageUrl,
    required this.gameMode,
    required this.maxSlots,
    required this.filledSlots,
    required this.entryFee,
    required this.prizePool,
    required this.prizeDistribution,
    required this.placementPointsMap,
    required this.killPointValue,
    required this.status,
    this.rules,
    this.registrationEndTime,
    this.startTime,
    required this.leaderboardTemplate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Tournament.fromMap(Map<String, dynamic> map) {
    return Tournament(
      id: map['id'] as String,
      organiserId: map['organiser_id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      bannerImageUrl: map['banner_image_url'] as String?,
      gameMode: _gameModeFromString(map['game_mode'] as String),
      maxSlots: map['max_slots'] as int,
      filledSlots: map['filled_slots'] as int,
      entryFee: (map['entry_fee'] as num).toDouble(),
      prizePool: (map['prize_pool'] as num).toDouble(),
      prizeDistribution: Map<String, dynamic>.from(
        map['prize_distribution'] as Map? ?? {},
      ),
      placementPointsMap: Map<String, dynamic>.from(
        map['placement_points_map'] as Map? ?? {},
      ),
      killPointValue: map['kill_point_value'] as int,
      status: _statusFromString(map['status'] as String),
      rules: map['rules'] as String?,
      registrationEndTime: map['registration_end_time'] != null
          ? DateTime.parse(map['registration_end_time'] as String)
          : null,
      startTime: map['start_time'] != null
          ? DateTime.parse(map['start_time'] as String)
          : null,
      leaderboardTemplate: map['leaderboard_template'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  /// Use ONLY for the initial INSERT (create tournament). After
  /// creation, tournaments are immutable from Flutter — room/status
  /// changes happen via start_tournament / cancel_tournament /
  /// complete_tournament RPC calls, not via .update() on this table.
  Map<String, dynamic> toMap() {
    return {
      'organiser_id': organiserId,
      'title': title,
      'description': description,
      'banner_image_url': bannerImageUrl,
      'game_mode': gameMode.name,
      'max_slots': maxSlots,
      'entry_fee': entryFee,
      'prize_pool': prizePool,
      'prize_distribution': prizeDistribution,
      'placement_points_map': placementPointsMap,
      'kill_point_value': killPointValue,
      'rules': rules,
      'registration_end_time': registrationEndTime?.toIso8601String(),
      'start_time': startTime?.toIso8601String(),
      'leaderboard_template': leaderboardTemplate,
      'status': status.name,
    };
  }

  Tournament copyWith({
    String? title,
    String? description,
    String? bannerImageUrl,
    int? filledSlots,
    TournamentStatus? status,
    String? rules,
  }) {
    return Tournament(
      id: id,
      organiserId: organiserId,
      title: title ?? this.title,
      description: description ?? this.description,
      bannerImageUrl: bannerImageUrl ?? this.bannerImageUrl,
      gameMode: gameMode,
      maxSlots: maxSlots,
      filledSlots: filledSlots ?? this.filledSlots,
      entryFee: entryFee,
      prizePool: prizePool,
      prizeDistribution: prizeDistribution,
      placementPointsMap: placementPointsMap,
      killPointValue: killPointValue,
      status: status ?? this.status,
      rules: rules ?? this.rules,
      registrationEndTime: registrationEndTime,
      startTime: startTime,
      leaderboardTemplate: leaderboardTemplate,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
