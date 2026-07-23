import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/home/presentation/widgets/tournament_list_item.dart';
import 'package:eagle_esports/feature/team/presentation/providers/team_providers.dart';
import 'package:eagle_esports/feature/tournament/presentation/providers/tournament_providers.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:eagle_esports/shared/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TournamentList extends ConsumerWidget {
  const TournamentList({
    required this.selectedStatusFilter,
    required this.selectedModeFilter,
    super.key,
  });

  final String selectedStatusFilter;
  final String selectedModeFilter;

  TournamentFilter get _filter {
    final status = switch (selectedStatusFilter) {
      'Upcoming' => TournamentStatus.upcoming,
      'Live' => TournamentStatus.live,
      _ => null,
    };

    final mode = switch (selectedModeFilter) {
      'Solo' => GameMode.solo,
      'Duo' => GameMode.duo,
      'Squad' => GameMode.squad,
      _ => null,
    };

    return TournamentFilter(status: status, mode: mode);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = _filter;
    final tournamentsAsync = ref.watch(tournamentListProvider(filter));
    final joinedIdsAsync = ref.watch(userJoinedTournamentIdsProvider);

    if (tournamentsAsync.isLoading || joinedIdsAsync.isLoading) {
      return const Center(child: SegmentedLoader(activeSegment: 3));
    }

    if (tournamentsAsync.hasError || joinedIdsAsync.hasError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Couldn't load tournaments",
              style: AppTextStyles.bodyMd,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            TextButton(
              onPressed: () {
                ref.invalidate(tournamentListProvider(filter));
                ref.invalidate(userJoinedTournamentIdsProvider);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final items = tournamentsAsync.value ?? [];
    final joinedIds = joinedIdsAsync.value ?? {};

    var filteredItems = items;
    if (selectedStatusFilter == 'Joined') {
      filteredItems = items.where((t) => joinedIds.contains(t.id)).toList();
    } else if (selectedStatusFilter == 'Upcoming' ||
        selectedStatusFilter == 'Live') {
      // Don't show joined tournaments in Upcoming or Live filters
      filteredItems = items.where((t) => !joinedIds.contains(t.id)).toList();
    }

    if (filteredItems.isEmpty) {
      return Center(
        child: Text('No tournaments found', style: AppTextStyles.bodyMd),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.xxxl,
      ),
      itemCount: filteredItems.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.lg),
      itemBuilder: (context, index) {
        final tournament = filteredItems[index];
        return TournamentListItem(
          tournament: tournament,
          isJoined: joinedIds.contains(tournament.id),
        );
      },
    );
  }
}
