import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/stats/presentation/widgets/tournament_stat_card.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:flutter/material.dart';

class TournamentStatsList extends StatelessWidget {
  const TournamentStatsList({required this.tournaments, super.key});

  final List<Tournament> tournaments;

  @override
  Widget build(BuildContext context) {
    final filteredTournaments = tournaments
        .where((t) => t.status != TournamentStatus.draft)
        .toList();

    filteredTournaments.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (filteredTournaments.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Text('No tournaments yet', style: AppTextStyles.bodyMd),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredTournaments.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: TournamentStatCard(tournament: filteredTournaments[index]),
        );
      },
    );
  }
}
