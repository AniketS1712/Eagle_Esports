import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/tournament/presentation/widgets/tournament_details_stat_tile.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:flutter/material.dart';

class TournamentDetailsStatsGrid extends StatelessWidget {
  const TournamentDetailsStatsGrid({required this.tournament, super.key});

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    final percent = tournament.maxSlots == 0
        ? 0
        : ((tournament.filledSlots / tournament.maxSlots) * 100).round();

    return Column(
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 1.18,
          children: [
            TournamentDetailsStatTile(
              icon: Icons.schedule,
              label: 'Start Time',
              value: _formatTime(tournament.startTime),
            ),
            TournamentDetailsStatTile(
              icon: Icons.payments_outlined,
              label: 'Prize Pool',
              value: '₹${tournament.prizePool.round()}',
            ),
            TournamentDetailsStatTile(
              icon: Icons.groups_outlined,
              label: 'Slots',
              value: '${tournament.filledSlots}/${tournament.maxSlots}',
            ),
            TournamentDetailsStatTile(
              icon: Icons.sports_esports,
              label: 'Mode',
              value: tournament.gameMode.name,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        GlassCard(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Entry Registration Status',
                      style: AppTextStyles.labelMd,
                    ),
                  ),
                  Text('$percent% FULL', style: AppTextStyles.badgeLabel),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              SegmentedProgressBar(
                filled: tournament.filledSlots,
                total: tournament.maxSlots,
                height: 6,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime? value) {
    if (value == null) return 'TBA';
    return '${value.hour.toString().padLeft(2, '0')}:'
        '${value.minute.toString().padLeft(2, '0')}';
  }
}
