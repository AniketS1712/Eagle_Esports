import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/team/presentation/widgets/team_room_credentials_card.dart';
import 'package:eagle_esports/feature/team/presentation/providers/team_providers.dart';
import 'package:eagle_esports/feature/tournament/presentation/providers/tournament_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TournamentDetailsLockedRoomCard extends ConsumerWidget {
  const TournamentDetailsLockedRoomCard({
    required this.tournamentId,
    super.key,
  });

  final String tournamentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userTeamIdAsync = ref.watch(
      userTeamIdForTournamentProvider(tournamentId),
    );

    return userTeamIdAsync.when(
      loading: () => const _LockedCard(),
      error: (_, _) => const _LockedCard(),
      data: (userTeamId) {
        if (userTeamId == null) return const _LockedCard();

        return ref
            .watch(tournamentRoomProvider(tournamentId))
            .when(
              data: (room) {
                if (room?.isRevealed == true) {
                  return TeamRoomCredentialsCard(
                    isRevealed: true,
                    roomId: room!.roomId,
                    roomPassword: room.roomPassword,
                  );
                }
                return const _LockedCard();
              },
              loading: () => const _LockedCard(),
              error: (_, _) => const _LockedCard(),
            );
      },
    );
  }
}

class _LockedCard extends StatelessWidget {
  const _LockedCard();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.lock, color: AppColors.electricCyan, size: 32),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Room Details', style: AppTextStyles.headlineMd),
                    Text(
                      'ID and password will be visible here.',
                      style: AppTextStyles.bodyMd,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          FilterChipPill(
            label: 'Unlocks 15 mins before match',
            selected: false,
            onTap: null,
          ),
        ],
      ),
    );
  }
}
