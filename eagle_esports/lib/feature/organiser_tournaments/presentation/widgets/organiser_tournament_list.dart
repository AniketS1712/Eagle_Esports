import 'package:eagle_esports/core/routes/route_names.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/home/presentation/widgets/tournament_list_item.dart';
import 'package:eagle_esports/feature/tournament/presentation/providers/tournament_providers.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:eagle_esports/shared/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OrganiserTournamentList extends ConsumerWidget {
  const OrganiserTournamentList({required this.selectedStatus, super.key});

  final String selectedStatus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournamentsAsync = ref.watch(myOrganisedTournamentsProvider);

    return tournamentsAsync.when(
      loading: () => const Center(child: SegmentedLoader(activeSegment: 4)),
      error: (error, stackTrace) => Center(
        child: Text("Couldn't load tournaments", style: AppTextStyles.bodyMd),
      ),
      data: (tournaments) {
        final filteredTournaments = tournaments.where((t) {
          switch (selectedStatus) {
            case 'All':
              return true;
            case 'Live':
              return t.status == TournamentStatus.live;
            case 'Upcoming':
              return t.status == TournamentStatus.upcoming;
            case 'Completed':
              return t.status == TournamentStatus.completed;
            case 'Draft':
              return t.status == TournamentStatus.draft;
            default:
              return true;
          }
        }).toList();

        if (filteredTournaments.isEmpty) {
          return const Center(
            child: Text('No tournaments found', style: AppTextStyles.bodyMd),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            0,
            AppSpacing.xs,
            0,
            AppSpacing.xxxl,
          ),
          itemCount: filteredTournaments.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppSpacing.lg),
          itemBuilder: (context, index) {
            final tournament = filteredTournaments[index];
            return TournamentListItem(
              tournament: tournament,
              onTap: () => context.pushNamed(
                RouteNames.organizerTournament,
                pathParameters: {'id': tournament.id},
              ),
            );
          },
        );
      },
    );
  }
}
