import 'package:eagle_esports/core/theme/theme.dart';
import 'package:flutter/material.dart';

class TeamRoomEmptySlotCard extends StatelessWidget {
  const TeamRoomEmptySlotCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_add,
              color: AppColors.primary,
              size: AppDimensions.iconMd,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Awaiting Member',
            style: AppTextStyles.labelMd.copyWith(
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.55),
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
