import 'dart:ui';

import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_decorations.dart';
import '../app_dimensions.dart';
import '../app_radius.dart';
import '../app_spacing.dart';
import '../app_text_styles.dart';
import 'app_badge.dart';
import 'app_chip.dart';
import 'app_progress_bar.dart';

/// Free Fire team modes used by tournament listing cards.
enum TournamentMode { solo, duo, squad }

/// Glassmorphism content shell with optional HUD corner accent.
class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child,
    this.padding = AppSpacing.cardPadding,
    this.margin,
    this.borderRadius,
    this.withGlow = false,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final bool withGlow;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppRadius.radiusDefault;

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppDimensions.glassBlurSigma,
          sigmaY: AppDimensions.glassBlurSigma,
        ),
        child: Container(
          margin: margin,
          decoration: AppDecorations.glassCard(
            radius: radius,
            withGlow: withGlow,
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

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
