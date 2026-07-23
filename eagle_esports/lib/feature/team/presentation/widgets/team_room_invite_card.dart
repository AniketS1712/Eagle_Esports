import 'package:eagle_esports/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TeamRoomInviteCard extends StatelessWidget {
  const TeamRoomInviteCard({
    required this.inviteCode,
    super.key,
  });

  final String inviteCode;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Invite Teammates', style: AppTextStyles.headlineMd),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Share this code so teammates can join your squad.',
            style: AppTextStyles.bodySm,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    borderRadius: AppRadius.radiusDefault,
                    border: Border.all(color: AppColors.outlineVariant),
                  ),
                  child: Text(
                    inviteCode,
                    style: AppTextStyles.numberMd.copyWith(
                      letterSpacing: 4,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              IconActionButton(
                icon: Icons.copy,
                tooltip: 'Copy code',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: inviteCode));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invite code copied')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
