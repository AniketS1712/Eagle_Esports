import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/tournament/presentation/widgets/tournament_details_entry_fee_card.dart';
import 'package:eagle_esports/feature/tournament/presentation/widgets/tournament_details_locked_room_card.dart';
import 'package:eagle_esports/feature/tournament/presentation/widgets/tournament_details_requirements_card.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:flutter/material.dart';

class TournamentDetailsSidebar extends StatelessWidget {
  const TournamentDetailsSidebar({required this.tournament, super.key});

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TournamentDetailsEntryFeeCard(tournament: tournament),
        const SizedBox(height: AppSpacing.md),
        TournamentDetailsLockedRoomCard(tournamentId: tournament.id),
        const SizedBox(height: AppSpacing.md),
        const TournamentDetailsRequirementsCard(),
      ],
    );
  }
}
