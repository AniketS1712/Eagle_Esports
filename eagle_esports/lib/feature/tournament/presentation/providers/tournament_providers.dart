import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eagle_esports/feature/auth/presentation/providers/auth_providers.dart';
import 'package:eagle_esports/feature/tournament/data/tournament_repository.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:eagle_esports/models/tournament_room.dart';

class TournamentFilter {
  final TournamentStatus? status;
  final GameMode? mode;

  const TournamentFilter({this.status, this.mode});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TournamentFilter &&
        other.status == status &&
        other.mode == mode;
  }

  @override
  int get hashCode => status.hashCode ^ mode.hashCode;
}

final tournamentRepositoryProvider = Provider<TournamentRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return TournamentRepository(client);
});

final tournamentListProvider =
    StreamProvider.family<List<Tournament>, TournamentFilter>((ref, filter) {
      final repository = ref.watch(tournamentRepositoryProvider);
      return repository.watchTournaments(
        status: filter.status,
        mode: filter.mode,
      );
    });

final myOrganisedTournamentsProvider = StreamProvider<List<Tournament>>((ref) {
  final session = ref.watch(authNotifierProvider).value;
  final organiserId = session?.user.id;
  if (organiserId == null) {
    return Stream.value([]);
  }

  final repository = ref.watch(tournamentRepositoryProvider);
  return repository.watchMyOrganisedTournaments(organiserId);
});

final tournamentDetailProvider = StreamProvider.family<Tournament, String>((
  ref,
  id,
) {
  final repository = ref.watch(tournamentRepositoryProvider);
  return repository.watchTournamentById(id);
});

final tournamentRoomProvider = StreamProvider.autoDispose
    .family<TournamentRoom?, String>((ref, tournamentId) {
      final repository = ref.watch(tournamentRepositoryProvider);
      return repository.watchTournamentRoom(tournamentId);
    });

class TournamentActionsNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> create(Tournament tournament) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(tournamentRepositoryProvider);
      await repository.createTournament(tournament);
    });
  }

  Future<void> start({
    required String tournamentId,
    required String roomId,
    required String roomPassword,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(tournamentRepositoryProvider);
      await repository.startTournament(
        tournamentId: tournamentId,
        roomId: roomId,
        roomPassword: roomPassword,
      );
    });
  }

  Future<void> cancel(String tournamentId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(tournamentRepositoryProvider);
      await repository.cancelTournament(tournamentId);
    });
  }

  Future<void> complete(String tournamentId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(tournamentRepositoryProvider);
      await repository.completeTournament(tournamentId);
    });
  }
}

final tournamentActionsProvider =
    AsyncNotifierProvider<TournamentActionsNotifier, void>(
      TournamentActionsNotifier.new,
    );
