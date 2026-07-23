import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:flutter/material.dart';

class TournamentDetailsInfoCard extends StatelessWidget {
  const TournamentDetailsInfoCard({required this.tournament, super.key});

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tournament Info', style: AppTextStyles.headlineMd),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  label: 'Entry Fee',
                  value: '₹${tournament.entryFee.round()}',
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _InfoTile(
                  label: 'Prize Pool',
                  value: '₹${tournament.prizePool.round()}',
                  valueColor: AppColors.statusSuccess,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Slots', style: AppTextStyles.labelMd),
          const SizedBox(height: AppSpacing.sm),
          SegmentedProgressBar(
            filled: tournament.filledSlots,
            total: tournament.maxSlots,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${tournament.filledSlots}/${tournament.maxSlots} filled',
            style: AppTextStyles.bodySm,
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          value,
          style: AppTextStyles.numberMd.copyWith(color: valueColor),
        ),
      ],
    );
  }
}
