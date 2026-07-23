import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/my_tournaments/presentation/providers/my_tournaments_providers.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CompletedTournamentCard extends ConsumerWidget {
  const CompletedTournamentCard({required this.tournament, super.key});

  final Tournament tournament;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final team = ref.watch(userTeamForTournamentProvider(tournament.id));
    final startDate = tournament.startTime != null
        ? DateFormat('dd MMM yyyy').format(tournament.startTime!)
        : '—';

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  tournament.title,
                  style: AppTextStyles.headlineMd,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const StatusBadge(status: 'completed'),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (tournament.bannerImageUrl != null)
            ClipRRect(
              borderRadius: AppRadius.radiusSm,
              child: Image.network(
                tournament.bannerImageUrl!,
                height: 120,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (_, _, _) => Container(
                  height: 120,
                  color: AppColors.surfaceContainerHigh,
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _InfoChip(
                Icons.sports_esports_outlined,
                tournament.gameMode.name.toUpperCase(),
              ),
              _InfoChip(Icons.calendar_today_outlined, startDate),
              _InfoChip(
                Icons.emoji_events_outlined,
                '${tournament.prizePool.toStringAsFixed(0)} T',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          team.when(
            loading: () =>
                const SizedBox(height: 20, child: LinearProgressIndicator()),
            error: (_, _) => const SizedBox.shrink(),
            data: (team) {
              if (team == null) {
                return const SizedBox.shrink();
              }

              return Row(
                children: [
                  const Icon(
                    Icons.group_outlined,
                    size: AppDimensions.iconSm,
                    color: AppColors.outline,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      'Team: ${team.teamName}',
                      style: AppTextStyles.bodySm,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip(this.icon, this.label);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: AppDimensions.iconXs, color: AppColors.outline),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
