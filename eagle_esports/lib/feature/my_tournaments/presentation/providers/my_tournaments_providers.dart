import 'package:eagle_esports/feature/auth/presentation/providers/auth_providers.dart';
import 'package:eagle_esports/feature/my_tournaments/data/my_tournaments_repository.dart';
import 'package:eagle_esports/models/team.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final myTournamentsRepositoryProvider = Provider<MyTournamentsRepository>((
  ref,
) {
  final client = ref.watch(supabaseClientProvider);
  return MyTournamentsRepository(client);
});

final completedTournamentsProvider =
    FutureProvider.autoDispose<List<Tournament>>((ref) async {
      final userId = ref.watch(authNotifierProvider).value?.user.id;
      if (userId == null) {
        return [];
      }

      final repository = ref.watch(myTournamentsRepositoryProvider);
      final rows = await repository.fetchCompletedParticipatedTournaments(
        userId,
      );
      return rows.map(Tournament.fromMap).toList();
    });

final activeTournamentsProvider = FutureProvider.autoDispose<List<Tournament>>((
  ref,
) async {
  final userId = ref.watch(authNotifierProvider).value?.user.id;
  if (userId == null) {
    return [];
  }

  final repository = ref.watch(myTournamentsRepositoryProvider);
  final rows = await repository.fetchActiveTournaments(userId);
  return rows.map(Tournament.fromMap).toList();
});

final userTeamForTournamentProvider = FutureProvider.autoDispose
    .family<Team?, String>((ref, tournamentId) async {
      final userId = ref.watch(authNotifierProvider).value?.user.id;
      if (userId == null) {
        return null;
      }

      final repository = ref.watch(myTournamentsRepositoryProvider);
      final data = await repository.fetchUserTeamForTournament(
        userId: userId,
        tournamentId: tournamentId,
      );
      return data == null ? null : Team.fromMap(data);
    });
