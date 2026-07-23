import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eagle_esports/feature/auth/presentation/providers/auth_providers.dart';
import 'package:eagle_esports/feature/my_tournaments/presentation/providers/my_tournaments_providers.dart';
import 'package:eagle_esports/feature/profile/data/profile_repository.dart';
import 'package:eagle_esports/feature/wallet/presentation/providers/wallet_providers.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return ProfileRepository(client);
});

class ProfileEditNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> updateProfile({
    required String userId,
    required String fullName,
    required String phone,
    required String avatarUrl,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(profileRepositoryProvider);
      await repo.updateProfile(
        userId: userId,
        fullName: fullName,
        phone: phone,
        avatarUrl: avatarUrl,
      );
      ref.invalidate(profileProvider);
    });
    if (state.hasError) {
      throw state.error!;
    }
  }
}

final profileEditProvider = AsyncNotifierProvider<ProfileEditNotifier, void>(
  ProfileEditNotifier.new,
);

final userWinsProvider = FutureProvider.autoDispose<int>((ref) async {
  final userId = ref.watch(authNotifierProvider).value?.user.id;
  if (userId == null) return 0;

  final repo = ref.watch(profileRepositoryProvider);
  return repo.fetchUserWins(userId);
});

final userProfileStatsProvider = Provider<Map<String, String>>((ref) {
  final wallet = ref.watch(walletStreamProvider).value;
  final balance = wallet?.talonBalance.toInt().toString() ?? '0';

  final active = ref.watch(activeTournamentsProvider).value;
  final completed = ref.watch(completedTournamentsProvider).value;
  final wins = ref.watch(userWinsProvider).value;

  final joinedCount = (active != null || completed != null)
      ? ((active?.length ?? 0) + (completed?.length ?? 0)).toString()
      : '0';

  return {
    'tournamentsJoined': joinedCount,
    'talonBalance': balance,
    'totalWins': wins?.toString() ?? '0',
  };
});
