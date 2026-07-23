import 'package:supabase_flutter/supabase_flutter.dart';

/// Data layer for tournament matches, per-match results, and the
/// aggregated leaderboard. The leaderboard table is read-only from
/// Flutter — it is populated by the `complete_tournament()` RPC.
class LeaderboardRepository {
  final SupabaseClient client;

  LeaderboardRepository(this.client);

  /// Fetches all teams for a tournament that have payment_status = 'paid'.
  Future<List<Map<String, dynamic>>> fetchPaidTeams(String tournamentId) async {
    return await client
        .from('teams')
        .select('id, team_name')
        .eq('tournament_id', tournamentId)
        .eq('payment_status', 'paid');
  }

  /// Creates a new match round for a tournament.
  Future<Map<String, dynamic>> createMatch(
    String tournamentId,
    int matchNumber,
  ) async {
    return await client
        .from('tournament_matches')
        .insert({'tournament_id': tournamentId, 'match_number': matchNumber})
        .select()
        .single();
  }

  /// Fetches all matches for a tournament ordered by match_number ascending.
  Future<List<Map<String, dynamic>>> fetchMatches(String tournamentId) async {
    return await client
        .from('tournament_matches')
        .select()
        .eq('tournament_id', tournamentId)
        .order('match_number', ascending: true);
  }

  /// Upserts a match result for one team in one match.
  /// Only sends placement + kills — DB trigger computes the rest.
  Future<void> upsertMatchResult({
    required String matchId,
    required String teamId,
    required int placement,
    required int kills,
  }) async {
    await client.from('match_results').upsert({
      'match_id': matchId,
      'team_id': teamId,
      'placement': placement,
      'kills': kills,
    }, onConflict: 'match_id,team_id');
  }

  /// Fetches all match results for a given match.
  Future<List<Map<String, dynamic>>> fetchMatchResults(String matchId) async {
    return await client.from('match_results').select().eq('match_id', matchId);
  }

  /// Fetches the final leaderboard for a completed tournament,
  /// joining team_name from the teams table.
  /// Returns rows ordered by rank ascending (nulls last).
  Future<List<Map<String, dynamic>>> fetchLeaderboardWithTeams(
    String tournamentId,
  ) async {
    return await client
        .from('leaderboard')
        .select(
          'id, tournament_id, team_id, total_kills, total_points, rank, '
          'prize_awarded, teams(team_name)',
        )
        .eq('tournament_id', tournamentId)
        .order('rank', ascending: true);
  }

  /// Streams the leaderboard for a tournament (realtime — shown to
  /// users live). Ordered by rank ascending.
  Stream<List<Map<String, dynamic>>> watchLeaderboard(String tournamentId) {
    return client
        .from('leaderboard')
        .stream(primaryKey: ['id'])
        .eq('tournament_id', tournamentId)
        .order('rank', ascending: true);
  }
}
