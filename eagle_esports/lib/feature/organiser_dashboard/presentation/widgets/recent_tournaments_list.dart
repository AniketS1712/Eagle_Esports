import 'package:eagle_esports/core/routes/route_names.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/home/presentation/widgets/tournament_list_item.dart';
import 'package:eagle_esports/feature/tournament/presentation/providers/tournament_providers.dart';
import 'package:eagle_esports/shared/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RecentTournamentsList extends ConsumerWidget {
  const RecentTournamentsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournaments = ref.watch(myOrganisedTournamentsProvider);

    return tournaments.when(
      loading: () => const Center(child: SegmentedLoader(activeSegment: 4)),
      error: (error, stackTrace) =>
          Text("Couldn't load recent tournaments", style: AppTextStyles.bodyMd),
      data: (items) {
        final recent = items.take(5).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent Tournaments', style: AppTextStyles.headlineMd),
            const SizedBox(height: AppSpacing.md),
            if (recent.isEmpty)
              Text('No tournaments found', style: AppTextStyles.bodyMd)
            else
              ...recent.map(
                (tournament) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: TournamentListItem(
                    tournament: tournament,
                    onTap: () => context.pushNamed(
                      RouteNames.organizerTournament,
                      pathParameters: {'id': tournament.id},
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
