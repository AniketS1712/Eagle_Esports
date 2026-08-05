import 'package:flutter/material.dart';

import '../../app_colors.dart';
import '../../app_dimensions.dart';
import '../../app_radius.dart';
import '../../app_spacing.dart';
import '../../app_text_styles.dart';
import '../app_badge.dart';
import '../app_chip.dart';
import '../app_progress_bar.dart';
import 'glass_card.dart';

/// Free Fire team modes used by tournament listing cards.
enum TournamentMode { solo, duo, squad }

/// Specialized listing card for Free Fire tournaments.
class TournamentCard extends StatelessWidget {
  const TournamentCard({
    required this.title,
    required this.bannerUrl,
    required this.mode,
    required this.entryFee,
    required this.prizePool,
    required this.slotsTotal,
    required this.slotsFilled,
    required this.status,
    this.onTap,
    super.key,
  });

  final String title;
  final String bannerUrl;
  final TournamentMode mode;
  final int entryFee;
  final int prizePool;
  final int slotsTotal;
  final int slotsFilled;
  final String status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.radiusDefault,
        child: GlassCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TournamentBanner(bannerUrl: bannerUrl, status: status),
              Padding(
                padding: AppSpacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.headlineMd,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    FilterChipPill(
                      label: mode.name,
                      selected: false,
                      onTap: null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: _MetricBlock(
                            label: 'Entry',
                            value: '₹$entryFee',
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _MetricBlock(
                            label: 'Prize Pool',
                            value: '₹$prizePool',
                            icon: Icons.emoji_events_outlined,
                            valueColor: AppColors.statusSuccess,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SegmentedProgressBar(
                      filled: slotsFilled,
                      total: slotsTotal,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '$slotsFilled/$slotsTotal',
                      style: AppTextStyles.bodySm,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TournamentBanner extends StatelessWidget {
  const _TournamentBanner({required this.bannerUrl, required this.status});

  final String bannerUrl;
  final String status;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(AppRadius.defaultRadius),
        topRight: Radius.circular(AppRadius.defaultRadius),
      ),
      child: SizedBox(
        height: AppDimensions.tournamentCardImageHeight,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              bannerUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.surfaceContainerHighest,
                        AppColors.surfaceContainerLow,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
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
                    AppColors.background.withValues(alpha: 0.6),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              top: AppSpacing.sm,
              right: AppSpacing.sm,
              child: StatusBadge(status: status),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricBlock extends StatelessWidget {
  const _MetricBlock({
    required this.label,
    required this.value,
    this.icon,
    this.valueColor,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: AppSpacing.xxs),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: valueColor, size: AppDimensions.iconSm),
              const SizedBox(width: AppSpacing.xxs),
            ],
            Flexible(
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.numberMd.copyWith(color: valueColor),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
