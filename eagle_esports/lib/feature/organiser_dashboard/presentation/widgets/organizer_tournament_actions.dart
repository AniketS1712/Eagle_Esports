import 'package:eagle_esports/core/routes/route_names.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrganizerTournamentActions extends StatelessWidget {
  const OrganizerTournamentActions({
    required this.tournament,
    required this.onStart,
    required this.onCancel,
    required this.onComplete,
    required this.onLeaderboard,
    required this.isLoading,
    super.key,
  });

  final Tournament tournament;
  final VoidCallback onStart;
  final VoidCallback onCancel;
  final VoidCallback onComplete;
  final VoidCallback onLeaderboard;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (tournament.status == TournamentStatus.upcoming) ...[
          PrimaryGradientButton(
            text: 'Start Tournament',
            isLoading: isLoading,
            leadingIcon: const Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 18,
            ),
            onPressed: onStart,
          ),
          const SizedBox(height: AppSpacing.sm),
          DangerButton(
            text: 'Cancel Tournament',
            isLoading: isLoading,
            onPressed: onCancel,
          ),
        ],
        if (tournament.status == TournamentStatus.live) ...[
          PrimaryGradientButton(
            text: 'Manage Leaderboard',
            isLoading: isLoading,
            leadingIcon: const Icon(
              Icons.leaderboard,
              color: Colors.white,
              size: 18,
            ),
            onPressed: onLeaderboard,
          ),
          const SizedBox(height: AppSpacing.sm),
          PrimaryGradientButton(
            text: 'Mark Complete',
            isLoading: isLoading,
            leadingIcon: const Icon(Icons.check, color: Colors.white, size: 18),
            onPressed: onComplete,
          ),
        ],
        if (tournament.status == TournamentStatus.draft)
          SecondaryOutlineButton(
            text: 'Preview Tournament',
            onPressed: () => context.pushNamed(
              RouteNames.previewTournament,
              pathParameters: {'id': tournament.id},
            ),
          ),
      ],
    );
  }
}
