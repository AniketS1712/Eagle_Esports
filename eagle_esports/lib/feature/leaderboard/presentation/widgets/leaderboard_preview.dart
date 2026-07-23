import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/leaderboard/presentation/providers/leaderboard_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shows the realtime leaderboard stream for a tournament.
/// Read-only — data is populated by the `complete_tournament()` RPC.
class LeaderboardPreview extends ConsumerWidget {
  const LeaderboardPreview({required this.tournamentId, super.key});

  final String tournamentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboard = ref.watch(leaderboardStreamProvider(tournamentId));

    return leaderboard.when(
      loading: () =>
          const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text('Error: $e', style: AppTextStyles.bodyMd),
      ),
      data: (rows) {
        if (rows.isEmpty) {
          return Center(
            child: Text(
              'No results yet — complete a match first',
              style: AppTextStyles.bodyMd,
            ),
          );
        }
        return _LeaderboardList(rows: rows);
      },
    );
  }
}

class _LeaderboardList extends StatelessWidget {
  const _LeaderboardList({required this.rows});

  final List<Map<String, dynamic>> rows;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(
        top: AppSpacing.sm,
        bottom: AppSpacing.xxxl,
      ),
      itemCount: rows.length,
      separatorBuilder: (_, _) =>
          const SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, i) => _LeaderboardRow(entry: rows[i]),
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({required this.entry});

  final Map<String, dynamic> entry;

  @override
  Widget build(BuildContext context) {
    final rank = entry['rank'];
    final teamName = entry['team_name'] as String? ?? '—';
    final kills = entry['total_kills'] ?? 0;
    final points = entry['total_points'] ?? 0;
    final prize = (entry['prize_awarded'] as num?)?.toDouble() ?? 0;

    return GlassCard(
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              '${rank ?? '—'}',
              style: AppTextStyles.numberMd.copyWith(
                color: AppColors.electricCyan,
              ),
            ),
          ),
          Expanded(
            child: Text(
              teamName,
              style: AppTextStyles.bodyMd,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '$kills K',
            style: AppTextStyles.bodySm.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          SizedBox(
            width: 48,
            child: Text(
              '$points',
              style: AppTextStyles.numberMd,
              textAlign: TextAlign.end,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          SizedBox(
            width: 64,
            child: Text(
              prize > 0 ? prize.toStringAsFixed(0) : '—',
              style: AppTextStyles.numberMd.copyWith(
                color: prize > 0
                    ? AppColors.statusSuccess
                    : AppColors.outline,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
