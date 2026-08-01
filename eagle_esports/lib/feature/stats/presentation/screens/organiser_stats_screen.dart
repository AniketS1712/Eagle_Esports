import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/stats/presentation/widgets/stats_overview_row.dart';
import 'package:eagle_esports/feature/stats/presentation/widgets/tournament_stats_list.dart';
import 'package:eagle_esports/feature/tournament/presentation/providers/tournament_providers.dart';
import 'package:eagle_esports/shared/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrganiserStatsScreen extends ConsumerWidget {
  const OrganiserStatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournamentsAsync = ref.watch(myOrganisedTournamentsProvider);

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: tournamentsAsync.when(
            loading: () =>
                const Center(child: SegmentedLoader(activeSegment: 3)),
            error: (error, stackTrace) => Center(
              child: Text(
                'Failed to load statistics',
                style: AppTextStyles.bodyMd,
              ),
            ),
            data: (tournaments) => SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Statistics',
                    style: AppTextStyles.headlineLgMobile,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  StatsOverviewRow(tournaments: tournaments),
                  const SizedBox(height: AppSpacing.lg),
                  const Text(
                    'Tournament Breakdown',
                    style: AppTextStyles.labelMd,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TournamentStatsList(tournaments: tournaments),
                  const SizedBox(height: AppSpacing.xxxl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
