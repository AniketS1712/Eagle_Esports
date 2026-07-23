import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eagle_esports/feature/auth/presentation/providers/auth_providers.dart';
import 'package:eagle_esports/feature/leaderboard/data/leaderboard_repository.dart';

/// Provides a singleton [LeaderboardRepository] backed by the
/// Supabase client from auth_providers.
final leaderboardRepositoryProvider = Provider<LeaderboardRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return LeaderboardRepository(client);
});

/// Paid teams for a tournament, keyed by tournamentId.
final paidTeamsProvider = FutureProvider.autoDispose
    .family<List<Map<String, dynamic>>, String>((ref, tournamentId) {
      final repository = ref.watch(leaderboardRepositoryProvider);
      return repository.fetchPaidTeams(tournamentId);
    });

/// All matches for a tournament, keyed by tournamentId.
final tournamentMatchesProvider = FutureProvider.autoDispose
    .family<List<Map<String, dynamic>>, String>((ref, tournamentId) {
      final repository = ref.watch(leaderboardRepositoryProvider);
      return repository.fetchMatches(tournamentId);
    });

/// All results for a single match, keyed by matchId.
final matchResultsProvider = FutureProvider.autoDispose
    .family<List<Map<String, dynamic>>, String>((ref, matchId) {
      final repository = ref.watch(leaderboardRepositoryProvider);
      return repository.fetchMatchResults(matchId);
    });

/// Realtime leaderboard stream for a tournament.
final leaderboardStreamProvider = StreamProvider.autoDispose
    .family<List<Map<String, dynamic>>, String>((ref, tournamentId) {
      final repository = ref.watch(leaderboardRepositoryProvider);
      return repository.watchLeaderboard(tournamentId);
    });

/// Notifier for leaderboard write operations (create match, save results).
class LeaderboardActionsNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    return;
  }

  /// Creates a new match round for a tournament.
  Future<void> createMatch(String tournamentId, int matchNumber) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(leaderboardRepositoryProvider);
      await repository.createMatch(tournamentId, matchNumber);
      ref.invalidate(tournamentMatchesProvider(tournamentId));
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Saves match results for all teams in one match.
  /// Each entry in [results] must contain `teamId`, `placement`, `kills`.
  Future<void> saveMatchResults({
    required String matchId,
    required List<Map<String, dynamic>> results,
  }) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(leaderboardRepositoryProvider);
      for (final r in results) {
        await repository.upsertMatchResult(
          matchId: matchId,
          teamId: r['teamId'] as String,
          placement: r['placement'] as int,
          kills: r['kills'] as int,
        );
      }
      ref.invalidate(matchResultsProvider(matchId));
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

final leaderboardActionsProvider =
    AsyncNotifierProvider<LeaderboardActionsNotifier, void>(
      LeaderboardActionsNotifier.new,
    );

final leaderboardWithTeamsProvider = FutureProvider.autoDispose
    .family<List<Map<String, dynamic>>, String>((ref, tournamentId) {
      final repository = ref.watch(leaderboardRepositoryProvider);
      return repository.fetchLeaderboardWithTeams(tournamentId);
    });
