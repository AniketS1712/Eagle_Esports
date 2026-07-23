import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:flutter/material.dart';

class OrganizerTournamentStats extends StatelessWidget {
  const OrganizerTournamentStats({required this.tournament, super.key});

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    final revenue = tournament.filledSlots * tournament.entryFee;

    return Row(
      children: [
        Expanded(
          child: StatCard(
            label: 'Registered',
            value: '${tournament.filledSlots}/${tournament.maxSlots}',
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: StatCard(label: 'Revenue', value: '₹${revenue.round()}'),
        ),
      ],
    );
  }
}
