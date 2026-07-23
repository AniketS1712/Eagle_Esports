import 'package:eagle_esports/core/theme/theme.dart';
import 'package:flutter/material.dart';

class TeamRoomHeader extends StatelessWidget {
  const TeamRoomHeader({
    required this.roomName,
    required this.region,
    super.key,
  });

  final String roomName;
  final String region;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CURRENT ROOM',
          style: AppTextStyles.labelMd.copyWith(
            color: AppColors.electricCyan,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          roomName,
          style: AppTextStyles.displayLg.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            const StatusBadge(status: 'live'),
            const SizedBox(width: AppSpacing.sm),
            FilterChipPill(label: region, selected: false, onTap: null),
          ],
        ),
      ],
    );
  }
}
