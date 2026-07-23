import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/organiser_dashboard/presentation/widgets/preview_tournament_actions.dart';
import 'package:eagle_esports/feature/organiser_dashboard/presentation/widgets/preview_tournament_banner.dart';
import 'package:eagle_esports/feature/organiser_dashboard/presentation/widgets/preview_tournament_summary.dart';
import 'package:eagle_esports/feature/tournament/presentation/providers/tournament_providers.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:eagle_esports/shared/widgets/app_top_bar.dart';
import 'package:eagle_esports/shared/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eagle_esports/core/routes/route_names.dart';

enum PreviewTournamentResult { publish }

class PreviewTournamentScreen extends ConsumerWidget {
  const PreviewTournamentScreen({
    required this.tournamentId,
    this.initialTournament,
    super.key,
  });

  final String tournamentId;
  final Tournament? initialTournament;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialTournament = this.initialTournament;
    if (initialTournament != null) {
      return Scaffold(
        body: AppBackground(
          child: SafeArea(
            child: _PreviewTournamentBody(
              tournament: initialTournament,
              isLoading: false,
              onEdit: () => context.pop(),
              onPublish: () => context.pop(PreviewTournamentResult.publish),
            ),
          ),
        ),
      );
    }

    final tournamentAsync = ref.watch(tournamentDetailProvider(tournamentId));

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: tournamentAsync.when(
            loading: () =>
                const Center(child: SegmentedLoader(activeSegment: 5)),
            error: (error, stackTrace) => Center(
              child: Text("Couldn't load preview", style: AppTextStyles.bodyMd),
            ),
            data: (tournament) => _PreviewTournamentBody(
              tournament: tournament,
              isLoading: false,
              onEdit: () => context.pop(),
              onPublish: () => context.pop(PreviewTournamentResult.publish),
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewTournamentBody extends StatelessWidget {
  const _PreviewTournamentBody({
    required this.tournament,
    required this.onEdit,
    required this.onPublish,
    required this.isLoading,
  });

  final Tournament tournament;
  final VoidCallback onEdit;
  final VoidCallback onPublish;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppTopBar(
          title: 'Preview',
          backRouteName: RouteNames.createTournament,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.lg),
                PreviewTournamentBanner(tournament: tournament),
                const SizedBox(height: AppSpacing.lg),
                PreviewTournamentSummary(tournament: tournament),
                const SizedBox(height: AppSpacing.xxxl),
              ],
            ),
          ),
        ),
        Padding(
          padding: AppSpacing.screenPadding,
          child: PreviewTournamentActions(
            onEdit: onEdit,
            onPublish: onPublish,
            isLoading: isLoading,
          ),
        ),
      ],
    );
  }
}
