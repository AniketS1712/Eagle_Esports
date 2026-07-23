import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:flutter/material.dart';

class OrganizerTournamentHeader extends StatelessWidget {
  const OrganizerTournamentHeader({required this.tournament, super.key});

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.lg),
        Text(tournament.title, style: AppTextStyles.headlineLgMobile),
        const SizedBox(height: AppSpacing.sm),
        FilterChipPill(
          label: tournament.gameMode.name,
          selected: false,
          onTap: null,
        ),
      ],
    );
  }
}
