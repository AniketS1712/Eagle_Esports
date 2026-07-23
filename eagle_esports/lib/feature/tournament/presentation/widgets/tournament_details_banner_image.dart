import 'package:eagle_esports/core/theme/theme.dart';
import 'package:flutter/material.dart';

class TournamentDetailsBannerImage extends StatelessWidget {
  const TournamentDetailsBannerImage({required this.bannerUrl, super.key});

  final String? bannerUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 256,
          width: double.infinity,
          child: Image.network(
            bannerUrl ?? '',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: AppColors.surfaceContainerHighest,
              child: const Icon(
                Icons.sports_esports,
                color: AppColors.electricCyan,
                size: AppDimensions.iconXl,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.background.withValues(alpha: 0.35),
                  AppColors.background,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
