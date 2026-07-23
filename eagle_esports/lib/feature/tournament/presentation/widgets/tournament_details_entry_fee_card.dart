import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:flutter/material.dart';

class TournamentDetailsEntryFeeCard extends StatelessWidget {
  const TournamentDetailsEntryFeeCard({required this.tournament, super.key});

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: AppSpacing.cardPadding,
            color: AppColors.primaryContainer.withValues(alpha: 0.2),
            child: Text(
              'Participation Cost',
              style: AppTextStyles.labelMd.copyWith(color: AppColors.primary),
            ),
          ),
          Padding(
            padding: AppSpacing.cardPaddingLarge,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    '₹${tournament.entryFee.round()}',
                    style: AppTextStyles.numberXl,
                  ),
                ),
                Text(
                  'Eagle Pass: Free',
                  style: AppTextStyles.labelMd.copyWith(
                    color: AppColors.electricCyan,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
