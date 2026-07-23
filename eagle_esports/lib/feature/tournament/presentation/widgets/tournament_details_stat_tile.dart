import 'package:eagle_esports/core/theme/theme.dart';
import 'package:flutter/material.dart';

class TournamentDetailsStatTile extends StatelessWidget {
  const TournamentDetailsStatTile({
    required this.icon,
    required this.label,
    required this.value,
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      withGlow: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.electricCyan),
          const SizedBox(height: AppSpacing.sm),
          Text(label.toUpperCase(), style: AppTextStyles.caption),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value.toUpperCase(),
            textAlign: TextAlign.center,
            style: AppTextStyles.headlineMd.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
