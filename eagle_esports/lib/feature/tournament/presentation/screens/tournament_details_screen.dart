import 'package:eagle_esports/core/routes/route_names.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/team/presentation/providers/team_providers.dart';
import 'package:eagle_esports/feature/tournament/presentation/providers/tournament_providers.dart';
import 'package:eagle_esports/feature/tournament/presentation/widgets/tournament_details_header.dart';
import 'package:eagle_esports/feature/tournament/presentation/widgets/tournament_details_rules_card.dart';
import 'package:eagle_esports/feature/tournament/presentation/widgets/tournament_details_sidebar.dart';
import 'package:eagle_esports/feature/tournament/presentation/widgets/tournament_details_stats_grid.dart';
import 'package:eagle_esports/feature/tournament/presentation/widgets/tournament_details_sticky_cta.dart';
import 'package:eagle_esports/shared/widgets/app_top_bar.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:eagle_esports/shared/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TournamentDetailsScreen extends ConsumerWidget {
  const TournamentDetailsScreen({
    required this.tournamentId,
    this.isJoined = false,
    super.key,
  });

  final String tournamentId;
  final bool isJoined;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournamentAsync = ref.watch(tournamentDetailProvider(tournamentId));

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          bottom: false,
          child: tournamentAsync.when(
            loading: () =>
                const Center(child: SegmentedLoader(activeSegment: 3)),
            error: (error, stackTrace) =>
                _ErrorState(message: error.toString()),
            data: (tournament) => _TournamentDetailsBody(
              tournament: tournament,
              isJoinedHint: isJoined,
            ),
          ),
        ),
      ),
    );
  }
}

class _TournamentDetailsBody extends ConsumerWidget {
  const _TournamentDetailsBody({
    required this.tournament,
    required this.isJoinedHint,
  });

  final Tournament tournament;
  final bool isJoinedHint;

  bool get _canRegister =>
      tournament.status == TournamentStatus.upcoming &&
      tournament.filledSlots < tournament.maxSlots;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If we already know from the home screen filter that the user has joined,
    // use that instantly. Otherwise wait for the provider to resolve.
    final userTeamIdAsync = ref.watch(
      userTeamIdForTournamentProvider(tournament.id),
    );
    final resolvedTeamId = userTeamIdAsync.value;
    final isRegistered = isJoinedHint || resolvedTeamId != null;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: AppDimensions.appBarHeight,
            bottom: 104,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TournamentDetailsHeader(tournament: tournament),
              Padding(
                padding: AppSpacing.screenPadding,
                child: Column(
                  children: [
                    TournamentDetailsStatsGrid(tournament: tournament),
                    const SizedBox(height: AppSpacing.lg),
                    TournamentDetailsRulesCard(tournament: tournament),
                    const SizedBox(height: AppSpacing.lg),
                    TournamentDetailsSidebar(tournament: tournament),
                  ],
                ),
              ),
            ],
          ),
        ),
        const AppTopBar(title: 'EAGLE ESPORTS', backRouteName: RouteNames.home),
        if (tournament.status == TournamentStatus.completed)
          Positioned(
            left: AppSpacing.xl,
            right: AppSpacing.xl,
            bottom: AppSpacing.md,
            child: Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: SecondaryOutlineButton(
                text: 'VIEW LEADERBOARD',
                onPressed: () => context.pushNamed(
                  RouteNames.userLeaderboard,
                  pathParameters: {'tournamentId': tournament.id},
                  extra: tournament.title,
                ),
              ),
            ),
          )
        else if (isRegistered)
          Positioned(
            left: AppSpacing.xl,
            right: AppSpacing.xl,
            bottom: AppSpacing.md,
            child: TournamentDetailsStickyCta(
              text: 'View Team',
              onPressed: () async {
                // Use already-resolved team ID, or fetch it on tap.
                final teamId =
                    resolvedTeamId ??
                    await ref.read(
                      userTeamIdForTournamentProvider(tournament.id).future,
                    );
                if (teamId != null && context.mounted) {
                  context.pushNamed(
                    RouteNames.teamRoom,
                    pathParameters: {'id': teamId},
                  );
                }
              },
            ),
          )
        else if (_canRegister)
          Positioned(
            left: AppSpacing.xl,
            right: AppSpacing.xl,
            bottom: AppSpacing.md,
            child: TournamentDetailsStickyCta(
              text: 'Register for Tournament',
              onPressed: () => context.pushNamed(
                RouteNames.room,
                pathParameters: {'id': tournament.id},
                extra: tournament,
              ),
            ),
          ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Text(
          "Couldn't load tournament details",
          style: AppTextStyles.bodyMd,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
