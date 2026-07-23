import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/tournament/presentation/providers/tournament_providers.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:eagle_esports/shared/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardStatsRow extends ConsumerWidget {
  const DashboardStatsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournaments = ref.watch(myOrganisedTournamentsProvider);

    return tournaments.when(
      loading: () => const Center(child: SegmentedLoader(activeSegment: 2)),
      error: (error, stackTrace) =>
          Text("Couldn't load stats", style: AppTextStyles.bodyMd),
      data: (items) {
        final activeCount = items.where((tournament) {
          return tournament.status == TournamentStatus.upcoming ||
              tournament.status == TournamentStatus.live;
        }).length;

        return Row(
          children: [
            Expanded(
              child: StatCard(
                label: 'Total \nTournaments',
                value: items.length.toString(),
                useLargeValue: true,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: StatCard(
                label: 'Active \nTournaments',
                value: activeCount.toString(),
                useLargeValue: true,
              ),
            ),
          ],
        );
      },
    );
  }
}
