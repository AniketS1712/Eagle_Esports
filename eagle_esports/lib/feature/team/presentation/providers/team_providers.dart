import 'dart:async';

import 'package:eagle_esports/feature/auth/presentation/providers/auth_providers.dart';
import 'package:eagle_esports/feature/team/data/team_repository.dart';
import 'package:eagle_esports/models/team.dart';
import 'package:eagle_esports/models/team_member.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return TeamRepository(client);
});

final teamStreamProvider = StreamProvider.autoDispose.family<Team, String>((
  ref,
  teamId,
) {
  final repository = ref.watch(teamRepositoryProvider);
  return repository.watchTeam(teamId);
});

final teamMembersStreamProvider = StreamProvider.autoDispose
    .family<List<TeamMember>, String>((ref, teamId) {
      final repository = ref.watch(teamRepositoryProvider);
      return repository.watchTeamMembers(teamId);
    });

final userTeamIdForTournamentProvider = FutureProvider.autoDispose
    .family<String?, String>((ref, tournamentId) async {
      final session = await ref.watch(authNotifierProvider.future);
      if (session == null) return null;

      final repository = ref.watch(teamRepositoryProvider);
      return repository.getUserTeamIdForTournament(
        tournamentId: tournamentId,
        userId: session.user.id,
      );
    });

final userJoinedTournamentIdsProvider = FutureProvider.autoDispose<Set<String>>((ref) async {
  final session = await ref.watch(authNotifierProvider.future);
  if (session == null) return {};

  final repository = ref.watch(teamRepositoryProvider);
  return repository.getUserJoinedTournamentIds(session.user.id);
});

final teamActionsProvider = AsyncNotifierProvider<TeamActionsNotifier, void>(
  TeamActionsNotifier.new,
);

class TeamActionsNotifier extends AsyncNotifier<void> {
  String? _lastJoinedTeamId;

  String? get lastJoinedTeamId => _lastJoinedTeamId;

  @override
  FutureOr<void> build() {}

  Future<String> createAndPayTeam({
    required String tournamentId,
    required String teamName,
    required String leaderId,
    String? inGameLeaderName,
  }) async {
    state = const AsyncValue.loading();

    try {
      final repository = ref.read(teamRepositoryProvider);
      final team = await repository.createTeam(
        tournamentId: tournamentId,
        teamName: teamName,
        leaderId: leaderId,
        inGameLeaderName: inGameLeaderName,
      );
      await repository.markTeamPaid(team.id);

      ref.invalidate(userTeamIdForTournamentProvider(tournamentId));

      state = const AsyncValue.data(null);
      return team.id;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> joinAndPayTeam({
    required String inviteCode,
    required String userId,
  }) async {
    state = const AsyncValue.loading();

    try {
      final repository = ref.read(teamRepositoryProvider);
      final team = await repository.findTeamByInviteCode(inviteCode);

      if (team == null) {
        throw Exception('No team found with that code');
      }

      await repository.joinTeam(teamId: team.id, userId: userId);
      await repository.markTeamPaid(team.id);
      _lastJoinedTeamId = team.id;

      ref.invalidate(userTeamIdForTournamentProvider(team.tournamentId));

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }
}

final registeredTeamsProvider = FutureProvider.autoDispose
    .family<List<Map<String, dynamic>>, String>((ref, tournamentId) async {
      final repository = ref.watch(teamRepositoryProvider);
      return repository.fetchTeamsForTournament(tournamentId);
    });

final teamMembersWithProfilesProvider = FutureProvider.autoDispose
    .family<List<Map<String, dynamic>>, String>((ref, teamId) async {
      final repository = ref.watch(teamRepositoryProvider);
      return repository.fetchTeamMembersWithProfiles(teamId);
    });

class RegisteredTeamsActionsNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> removeTeam({
    required String teamId,
    required String tournamentId,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(teamRepositoryProvider);
      await repo.removeTeam(teamId);
      ref.invalidate(registeredTeamsProvider(tournamentId));
    });
    if (state.hasError) {
      throw state.error!;
    }
  }
}

final registeredTeamsActionsProvider =
    AsyncNotifierProvider<RegisteredTeamsActionsNotifier, void>(
      RegisteredTeamsActionsNotifier.new,
    );
