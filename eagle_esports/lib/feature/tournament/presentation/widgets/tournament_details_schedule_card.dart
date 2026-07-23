import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:flutter/material.dart';

class TournamentDetailsScheduleCard extends StatelessWidget {
  const TournamentDetailsScheduleCard({required this.tournament, super.key});

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Schedule', style: AppTextStyles.headlineMd),
          const SizedBox(height: AppSpacing.md),
          _ScheduleRow(
            icon: Icons.event_available_outlined,
            label: 'Registration Closes',
            value: _formatDateTime(tournament.registrationEndTime),
          ),
          const SizedBox(height: AppSpacing.md),
          _ScheduleRow(
            icon: Icons.play_circle_outline,
            label: 'Start Time',
            value: _formatDateTime(tournament.startTime),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'TBA';
    final month = _monthName(dateTime.month);
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$month ${dateTime.day}, ${dateTime.year} · $hour:$minute';
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[month - 1];
  }
}

class _ScheduleRow extends StatelessWidget {
  const _ScheduleRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.electricCyan, size: AppDimensions.iconSm),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              const SizedBox(height: AppSpacing.xxs),
              Text(value, style: AppTextStyles.bodyMd),
            ],
          ),
        ),
      ],
    );
  }
}
