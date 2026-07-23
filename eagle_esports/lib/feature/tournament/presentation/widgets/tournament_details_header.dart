import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/tournament/presentation/widgets/tournament_details_banner_image.dart';
import 'package:eagle_esports/models/tournament.dart';
import 'package:flutter/material.dart';

class TournamentDetailsHeader extends StatelessWidget {
  const TournamentDetailsHeader({required this.tournament, super.key});

  final Tournament tournament;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TournamentDetailsBannerImage(bannerUrl: tournament.bannerImageUrl),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [StatusBadge(status: tournament.status.name)]),
              const SizedBox(height: AppSpacing.sm),
              Text(tournament.title, style: AppTextStyles.headlineLgMobile),
              Text(
                tournament.description ??
                    'Battle against elite squads for glory and prize credits.',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMd,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
