import 'package:eagle_esports/models/team.dart';
import 'package:eagle_esports/models/team_member.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TeamRepository {
  TeamRepository(this.client);

  final SupabaseClient client;

  /// Creates a team for a tournament and returns the inserted team row.
  Future<Team> createTeam({
    required String tournamentId,
    required String teamName,
    required String leaderId,
    String? inGameLeaderName,
  }) async {
    final data = await client
        .from('teams')
        .insert({
          'tournament_id': tournamentId,
          'team_name': teamName,
          'leader_id': leaderId,
          'in_game_leader_name': inGameLeaderName,
        })
        .select()
        .single();

    return Team.fromMap(data);
  }

  /// Finds a team by its invite code, returning null when no match exists.
  Future<Team?> findTeamByInviteCode(String inviteCode) async {
    final data = await client
        .from('teams')
        .select()
        .eq('invite_code', inviteCode.trim().toUpperCase())
        .maybeSingle();

    return data == null ? null : Team.fromMap(data);
  }

  /// Adds a user to an existing team.
  Future<void> joinTeam({
    required String teamId,
    required String userId,
  }) async {
    await client.from('team_members').insert({
      'team_id': teamId,
      'user_id': userId,
    });
  }

  /// Marks a team payment as paid using the temporary payment stub.
  Future<void> markTeamPaid(String teamId) async {
    // TODO: replace with pay_tournament_entry RPC when wallet is built
    await client
        .from('teams')
        .update({'payment_status': 'paid'})
        .eq('id', teamId);
  }

  /// Watches one team row and emits live updates.
  Stream<Team> watchTeam(String teamId) {
    return client
        .from('teams')
        .stream(primaryKey: ['id'])
        .eq('id', teamId)
        .map((rows) => Team.fromMap(rows.first));
  }

  /// Watches all members for a team and emits live updates.
  Stream<List<TeamMember>> watchTeamMembers(String teamId) {
    return client
        .from('team_members')
        .stream(primaryKey: ['id'])
        .eq('team_id', teamId)
        .map((rows) => rows.map((row) => TeamMember.fromMap(row)).toList());
  }

  /// Gets the user's team ID for a specific tournament.
  Future<String?> getUserTeamIdForTournament({
    required String tournamentId,
    required String userId,
  }) async {
    // 1. Fallback: check if they are the leader (in case trigger doesn't add leader to members)
    final leaderData = await client
        .from('teams')
        .select('id')
        .eq('tournament_id', tournamentId)
        .eq('leader_id', userId)
        .maybeSingle();
    if (leaderData != null) return leaderData['id'] as String;

    // 2. Get teams the user is a member of
    final memberData = await client
        .from('team_members')
        .select('team_id, teams(tournament_id)')
        .eq('user_id', userId);
        
    for (final row in memberData) {
      final teams = row['teams'];
      if (teams != null && teams['tournament_id'] == tournamentId) {
        return row['team_id'] as String;
      }
    }

    return null;
  }

  /// Gets all tournament IDs the user has joined.
  Future<Set<String>> getUserJoinedTournamentIds(String userId) async {
    final memberData = await client
        .from('team_members')
        .select('teams(tournament_id)')
        .eq('user_id', userId);

    final leaderData = await client
        .from('teams')
        .select('tournament_id')
        .eq('leader_id', userId);

    final set = <String>{};
    for (var m in memberData) {
      if (m['teams'] != null) {
        set.add(m['teams']['tournament_id'] as String);
      }
    }
    for (var l in leaderData) {
      set.add(l['tournament_id'] as String);
    }
    return set;
  }

  /// Fetches all teams for a tournament with their member count,
  /// ordered by slot_number ascending (nulls last).
  Future<List<Map<String, dynamic>>> fetchTeamsForTournament(
    String tournamentId,
  ) async {
    final response = await client
        .from('teams')
        .select('*, team_members(count)')
        .eq('tournament_id', tournamentId)
        .order('slot_number', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  /// Fetches all members of a team with their profile details.
  Future<List<Map<String, dynamic>>> fetchTeamMembersWithProfiles(
    String teamId,
  ) async {
    final response = await client
        .from('team_members')
        .select('*, profiles(full_name, avatar_url)')
        .eq('team_id', teamId)
        .order('is_leader', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  /// Removes a pending team and its members (cascade handled by DB).
  /// Throws if team is not pending — caller must check before calling.
  Future<void> removeTeam(String teamId) async {
    await client.from('teams').delete().eq('id', teamId);
  }
}
