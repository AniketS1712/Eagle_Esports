import 'package:eagle_esports/core/theme/theme.dart';
import 'package:flutter/material.dart';

class TournamentDetailsStickyCta extends StatelessWidget {
  const TournamentDetailsStickyCta({
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    super.key,
  });

  final VoidCallback onPressed;
  final String text;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.92),
        borderRadius: AppRadius.radiusLg,
        boxShadow: AppColors.glowShadow(
          AppColors.electricCyan,
          blur: 20,
          opacity: 0.22,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: PrimaryGradientButton(
          text: text,
          isLoading: isLoading,
          leadingIcon: const Icon(
            Icons.bolt,
            color: AppColors.onPrimaryContainer,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
