import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:eagle_esports/models/tournament_room.dart';

class TournamentRepository {
  final SupabaseClient client;

  TournamentRepository(this.client);

  Stream<List<Tournament>> watchTournaments({
    TournamentStatus? status,
    GameMode? mode,
  }) {
    // Supabase Realtime streams support limited filtering, so we filter client-side.
    return client
        .from('tournaments')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) {
          return data
              .map((e) => Tournament.fromMap(e))
              .where((t) => t.status != TournamentStatus.draft)
              .where((t) => status == null || t.status == status)
              .where((t) => mode == null || t.gameMode == mode)
              .toList();
        });
  }

  /// Watches all tournaments organised by a specific organiser (including drafts).
  Stream<List<Tournament>> watchMyOrganisedTournaments(String organiserId) {
    return client
        .from('tournaments')
        .stream(primaryKey: ['id'])
        .eq('organiser_id', organiserId)
        .order('created_at', ascending: false)
        .map((data) => data.map((e) => Tournament.fromMap(e)).toList());
  }

  /// Watches a single tournament by its ID.
  Stream<Tournament> watchTournamentById(String id) {
    return client
        .from('tournaments')
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .where((data) => data.isNotEmpty)
        .map((data) => Tournament.fromMap(data.first));
  }

  /// Creates a new tournament and returns the inserted row parsed as a Tournament.
  Future<Tournament> createTournament(Tournament tournament) async {
    final data = await client
        .from('tournaments')
        .insert(tournament.toMap())
        .select()
        .single();
    return Tournament.fromMap(data);
  }

  /// Starts a tournament by assigning a room ID and password.
  Future<void> startTournament({
    required String tournamentId,
    required String roomId,
    required String roomPassword,
  }) async {
    await client.rpc(
      'start_tournament',
      params: {
        'p_tournament_id': tournamentId,
        'p_room_id': roomId,
        'p_room_password': roomPassword,
      },
    );
  }

  /// Cancels a tournament.
  Future<void> cancelTournament(String tournamentId) async {
    await client.rpc(
      'cancel_tournament',
      params: {'p_tournament_id': tournamentId},
    );
  }

  /// Completes a tournament.
  Future<void> completeTournament(String tournamentId) async {
    await client.rpc(
      'complete_tournament',
      params: {'p_tournament_id': tournamentId},
    );
  }

  /// Watches the tournament room details for a given tournament.
  Stream<TournamentRoom?> watchTournamentRoom(String tournamentId) {
    return client
        .from('tournament_rooms')
        .stream(primaryKey: ['id'])
        .eq('tournament_id', tournamentId)
        .map(
          (data) => data.isEmpty ? null : TournamentRoom.fromMap(data.first),
        );
  }
}
