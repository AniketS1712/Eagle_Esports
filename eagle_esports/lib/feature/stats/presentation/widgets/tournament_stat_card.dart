import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TournamentStatCard extends StatelessWidget {
  const TournamentStatCard({required this.tournament, super.key});

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  tournament.title,
                  style: AppTextStyles.headlineMd,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              StatusBadge(status: tournament.status.name),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _StatColumn(
                  label: 'Mode',
                  value: tournament.gameMode.name.toUpperCase(),
                ),
              ),
              Expanded(
                child: _StatColumn(
                  label: 'Slots',
                  value: '${tournament.filledSlots}/${tournament.maxSlots}',
                ),
              ),
              Expanded(
                child: _StatColumn(
                  label: 'Entry Fee',
                  value: '${tournament.entryFee.toStringAsFixed(0)} T',
                ),
              ),
              Expanded(
                child: _StatColumn(
                  label: 'Revenue',
                  value: '${(tournament.entryFee * tournament.filledSlots).toStringAsFixed(0)} T',
                  isRevenue: true,
                ),
              ),
            ],
          ),
          if (tournament.startTime != null) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: AppDimensions.iconXs,
                  color: AppColors.outline,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  DateFormat('dd MMM yyyy • HH:mm').format(tournament.startTime!),
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
    required this.label,
    required this.value,
    this.isRevenue = false,
  });

  final String label;
  final String value;
  final bool isRevenue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption,
        ),
        Text(
          value,
          style: isRevenue
              ? AppTextStyles.numberMd.copyWith(color: AppColors.statusSuccess)
              : AppTextStyles.labelMd,
        ),
      ],
    );
  }
}
