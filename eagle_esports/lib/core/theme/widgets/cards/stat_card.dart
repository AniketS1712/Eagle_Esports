import 'package:flutter/material.dart';

import '../../app_colors.dart';
import '../../app_spacing.dart';
import '../../app_text_styles.dart';
import 'glass_card.dart';

/// Compact glass stat card for dashboards and analytics screens.
class StatCard extends StatelessWidget {
  const StatCard({
    required this.label,
    required this.value,
    this.useLargeValue = false,
    super.key,
  });

  final String label;
  final String value;
  final bool useLargeValue;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: GlassCard(
        withGlow: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(label, style: AppTextStyles.labelMd)],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              value,
              style:
                  (useLargeValue
                          ? AppTextStyles.numberLg
                          : AppTextStyles.numberMd)
                      .copyWith(
                        shadows: [
                          Shadow(
                            color: AppColors.secondary,
                            blurRadius: 16,
                            offset: Offset.zero,
                          ),
                          Shadow(
                            color: AppColors.secondary,
                            blurRadius: 16,
                            offset: Offset.zero,
                          ),
                          Shadow(
                            color: AppColors.onPrimaryFixed,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
