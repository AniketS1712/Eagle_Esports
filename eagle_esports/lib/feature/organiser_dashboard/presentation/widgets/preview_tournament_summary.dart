import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:flutter/material.dart';

class PreviewTournamentSummary extends StatelessWidget {
  const PreviewTournamentSummary({required this.tournament, super.key});

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Preview Summary', style: AppTextStyles.headlineMd),
          const SizedBox(height: AppSpacing.md),
          _SummaryRow(label: 'Mode', value: tournament.gameMode.name),
          _SummaryRow(
            label: 'Entry Fee',
            value: '₹${tournament.entryFee.round()}',
          ),
          _SummaryRow(
            label: 'Prize Pool',
            value: '₹${tournament.prizePool.round()}',
          ),
          _SummaryRow(
            label: 'Max Slots',
            value: '${tournament.maxSlots}',
          ),
          if (tournament.description?.isNotEmpty == true) ...[
            const SizedBox(height: AppSpacing.md),
            Text('Description', style: AppTextStyles.labelMd),
            const SizedBox(height: AppSpacing.xs),
            Text(tournament.description!, style: AppTextStyles.bodySm),
          ],
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySm),
          Text(value, style: AppTextStyles.labelMd),
        ],
      ),
    );
  }
}
