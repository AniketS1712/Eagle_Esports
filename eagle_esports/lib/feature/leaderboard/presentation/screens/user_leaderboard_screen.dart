import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/leaderboard/presentation/providers/leaderboard_providers.dart';
import 'package:eagle_esports/feature/leaderboard/presentation/widgets/leaderboard_rank_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UserLeaderboardScreen extends ConsumerWidget {
  const UserLeaderboardScreen({
    required this.tournamentId,
    required this.tournamentTitle,
    super.key,
  });

  final String tournamentId;
  final String tournamentTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboard = ref.watch(leaderboardWithTeamsProvider(tournamentId));

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: AppSpacing.screenPadding,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new),
                      color: AppColors.onSurface,
                      onPressed: context.pop,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        'Leaderboard',
                        style: AppTextStyles.headlineLgMobile,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Text(
                  tournamentTitle,
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: leaderboard.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.electricCyan,
                    ),
                  ),
                  error: (_, _) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Could not load leaderboard',
                          style: AppTextStyles.bodyMd,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TextButton(
                          onPressed: () => ref.invalidate(
                            leaderboardWithTeamsProvider(tournamentId),
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                  data: (items) {
                    if (items.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.emoji_events_outlined,
                              size: AppDimensions.iconXl,
                              color: AppColors.outline,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text('No results yet', style: AppTextStyles.bodyMd),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.md,
                        0,
                        AppSpacing.md,
                        AppSpacing.xxxl,
                      ),
                      itemCount: items.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final row = items[index];
                        final teamName =
                            (row['teams'] as Map?)?['team_name'] as String? ??
                            'Unknown Team';
                        final rank = row['rank'] as int?;
                        return LeaderboardRankRow(
                          rank: rank,
                          teamName: teamName,
                          totalKills: row['total_kills'] as int? ?? 0,
                          totalPoints: row['total_points'] as int? ?? 0,
                          prizeAwarded:
                              (row['prize_awarded'] as num?)?.toDouble() ?? 0,
                          isTopThree: rank != null && rank <= 3,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
