import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActiveTournamentCard extends StatelessWidget {
  const ActiveTournamentCard({
    required this.tournament,
    required this.onTap,
    super.key,
  });

  final Tournament tournament;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (tournament.bannerImageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.defaultRadius),
                  topRight: Radius.circular(AppRadius.defaultRadius),
                ),
                child: Image.network(
                  tournament.bannerImageUrl!,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    height: 120,
                    color: AppColors.surfaceContainerHigh,
                  ),
                ),
              ),
            Padding(
              padding: AppSpacing.cardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          tournament.title,
                          style: AppTextStyles.headlineMd,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      StatusBadge(status: tournament.status.name),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _InfoChip(
                        Icons.sports_esports_outlined,
                        tournament.gameMode.name.toUpperCase(),
                      ),
                      _InfoChip(
                        Icons.people_outline,
                        '${tournament.filledSlots}/${tournament.maxSlots}',
                      ),
                      _InfoChip(
                        Icons.payments_outlined,
                        '${tournament.entryFee.toStringAsFixed(0)}T',
                      ),
                      if (tournament.startTime != null)
                        _InfoChip(
                          Icons.schedule_outlined,
                          DateFormat(
                            'dd MMM • HH:mm',
                          ).format(tournament.startTime!),
                        ),
                    ],
                  ),
                  if (tournament.status == TournamentStatus.live) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.xs,
                        horizontal: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.electricCyan.withValues(alpha: 0.1),
                        borderRadius: AppRadius.radiusSm,
                        border: Border.all(
                          color: AppColors.electricCyan,
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 8,
                            color: AppColors.electricCyan,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            'MATCH IS LIVE — Check room details',
                            style: AppTextStyles.badgeLabel.copyWith(
                              color: AppColors.electricCyan,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip(this.icon, this.label);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: AppDimensions.iconXs, color: AppColors.outline),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
