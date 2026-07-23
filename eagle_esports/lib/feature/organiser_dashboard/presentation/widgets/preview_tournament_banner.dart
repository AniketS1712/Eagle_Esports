import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:flutter/material.dart';

class PreviewTournamentBanner extends StatelessWidget {
  const PreviewTournamentBanner({required this.tournament, super.key});

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.radiusDefault,
      child: SizedBox(
        height: AppDimensions.tournamentCardImageHeight,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              tournament.bannerImageUrl ?? '',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.surfaceContainerHighest,
                  child: const Icon(
                    Icons.sports_esports,
                    color: AppColors.electricCyan,
                    size: AppDimensions.iconXl,
                  ),
                );
              },
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppColors.background.withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              top: AppSpacing.sm,
              right: AppSpacing.sm,
              child: StatusBadge(status: tournament.status.name),
            ),
            Positioned(
              left: AppSpacing.md,
              bottom: AppSpacing.md,
              right: AppSpacing.md,
              child: Text(
                tournament.title,
                style: AppTextStyles.headlineMd,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
