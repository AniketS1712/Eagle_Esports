import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:flutter/material.dart';

class StatsOverviewRow extends StatelessWidget {
  const StatsOverviewRow({required this.tournaments, super.key});

  final List<Tournament> tournaments;

  @override
  Widget build(BuildContext context) {
    final int totalHosted = tournaments.length;

    int activeTournaments = 0;
    int completedTournaments = 0;
    double totalRevenue = 0;
    int totalPlayers = 0;

    for (final t in tournaments) {
      if (t.status == TournamentStatus.live ||
          t.status == TournamentStatus.upcoming) {
        activeTournaments++;
      }
      if (t.status == TournamentStatus.completed) {
        completedTournaments++;
        totalRevenue += (t.entryFee * t.filledSlots);
      }
      totalPlayers += t.filledSlots;
    }

    final String avgPlayers = totalHosted > 0
        ? (totalPlayers / totalHosted).toStringAsFixed(1)
        : '0';

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: AppSpacing.md,
      mainAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        StatCard(label: 'Total Hosted', value: totalHosted.toString()),
        StatCard(label: 'Active Now', value: activeTournaments.toString()),
        StatCard(label: 'Completed', value: completedTournaments.toString()),
        StatCard(
          label: 'Total Revenue',
          value: '${totalRevenue.toStringAsFixed(0)} T',
        ),
        StatCard(label: 'Total Players', value: totalPlayers.toString()),
        StatCard(label: 'Avg Players', value: avgPlayers),
      ],
    );
  }
}
