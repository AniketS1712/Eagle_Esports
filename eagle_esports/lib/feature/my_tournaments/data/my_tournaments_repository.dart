import 'package:supabase_flutter/supabase_flutter.dart';

class MyTournamentsRepository {
  const MyTournamentsRepository(this.client);

  final SupabaseClient client;

  /// Fetches all completed tournaments the user has participated in,
  /// either as a leader or team member.
  Future<List<Map<String, dynamic>>> fetchCompletedParticipatedTournaments(
    String userId,
  ) async {
    final teamMemberRows = await client
        .from('team_members')
        .select('team_id')
        .eq('user_id', userId);

    final teamIds = teamMemberRows
        .map((row) => row['team_id'] as String)
        .toSet()
        .toList();
    if (teamIds.isEmpty) {
      return [];
    }

    final teamRows = await client
        .from('teams')
        .select('tournament_id')
        .inFilter('id', teamIds);

    final tournamentIds = teamRows
        .map((row) => row['tournament_id'] as String)
        .toSet()
        .toList();
    if (tournamentIds.isEmpty) {
      return [];
    }

    final tournamentRows = await client
        .from('tournaments')
        .select()
        .inFilter('id', tournamentIds)
        .eq('status', 'completed')
        .order('start_time', ascending: false);

    return tournamentRows;
  }

  /// Fetches the user's team for a specific tournament.
  /// Returns null if the user has no team in that tournament.
  Future<Map<String, dynamic>?> fetchUserTeamForTournament({
    required String userId,
    required String tournamentId,
  }) async {
    final row = await client
        .from('team_members')
        .select('teams!inner(*)')
        .eq('user_id', userId)
        .eq('teams.tournament_id', tournamentId)
        .maybeSingle();

    final team = row?['teams'];
    return team is Map<String, dynamic> ? team : null;
  }

  /// Fetches upcoming and live tournaments the user has an active
  /// paid registration for (as leader or team member).
  Future<List<Map<String, dynamic>>> fetchActiveTournaments(
    String userId,
  ) async {
    final teamMemberRows = await client
        .from('team_members')
        .select('team_id')
        .eq('user_id', userId);

    final teamIds = teamMemberRows
        .map((row) => row['team_id'] as String)
        .toSet()
        .toList();
    if (teamIds.isEmpty) {
      return [];
    }

    final teamRows = await client
        .from('teams')
        .select('tournament_id')
        .inFilter('id', teamIds)
        .eq('payment_status', 'paid');

    final tournamentIds = teamRows
        .map((row) => row['tournament_id'] as String)
        .toSet()
        .toList();
    if (tournamentIds.isEmpty) {
      return [];
    }

    final tournamentRows = await client
        .from('tournaments')
        .select()
        .inFilter('id', tournamentIds)
        .inFilter('status', ['upcoming', 'live'])
        .order('start_time', ascending: true);

    return tournamentRows;
  }
}
