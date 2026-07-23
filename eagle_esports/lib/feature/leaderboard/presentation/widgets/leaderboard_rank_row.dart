import 'package:eagle_esports/core/theme/theme.dart';
import 'package:flutter/material.dart';

class LeaderboardRankRow extends StatelessWidget {
  const LeaderboardRankRow({
    required this.rank,
    required this.teamName,
    required this.totalKills,
    required this.totalPoints,
    required this.prizeAwarded,
    required this.isTopThree,
    super.key,
  });

  final int? rank;
  final String teamName;
  final int totalKills;
  final int totalPoints;
  final double prizeAwarded;
  final bool isTopThree;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isTopThree
                  ? (rank == 1
                        ? const Color(0xFFFFD700)
                        : rank == 2
                        ? const Color(0xFFC0C0C0)
                        : const Color(0xFFCD7F32))
                  : AppColors.surfaceContainerHigh,
            ),
            child: Center(
              child: Text(
                rank != null ? '$rank' : '—',
                style: AppTextStyles.labelMd.copyWith(
                  color: isTopThree ? Colors.black : AppColors.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              teamName,
              style: AppTextStyles.bodyMd,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${totalPoints}pts',
                style: AppTextStyles.numberMd.copyWith(
                  color: AppColors.electricCyan,
                ),
              ),
              Text('$totalKills kills', style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (prizeAwarded > 0)
                Text(
                  '${prizeAwarded.toStringAsFixed(0)}T',
                  style: AppTextStyles.numberMd.copyWith(
                    color: AppColors.statusSuccess,
                  ),
                )
              else
                Text('—', style: AppTextStyles.caption),
              Text('prize', style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }
}
