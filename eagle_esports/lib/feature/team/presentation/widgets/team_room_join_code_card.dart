import 'package:eagle_esports/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TeamRoomJoinCodeCard extends StatelessWidget {
  const TeamRoomJoinCodeCard({required this.joinCode, super.key});

  final String joinCode;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: AppSpacing.cardPaddingLarge,
      withGlow: true,
      child: Column(
        children: [
          Text(
            'Room Join Code',
            style: AppTextStyles.labelMd.copyWith(
              color: AppColors.onSurfaceVariant,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          InkWell(
            onTap: () => _copyCode(context),
            borderRadius: AppRadius.radiusLg,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.lg,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest.withValues(alpha: 0.5),
                borderRadius: AppRadius.radiusLg,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    joinCode,
                    style: AppTextStyles.numberXl.copyWith(
                      color: AppColors.electricCyan,
                      letterSpacing: 8,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  const Icon(Icons.copy, color: AppColors.primary),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Share this code with your teammates to fill the slots.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySm,
          ),
        ],
      ),
    );
  }

  void _copyCode(BuildContext context) {
    Clipboard.setData(ClipboardData(text: joinCode));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Join code copied')));
  }
}
