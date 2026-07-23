import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/team/presentation/widgets/team_room_members_grid.dart';
import 'package:flutter/material.dart';

class TeamRoomMemberCard extends StatelessWidget {
  const TeamRoomMemberCard({required this.member, super.key});

  final TeamRoomMember member;

  @override
  Widget build(BuildContext context) {
    final statusColor = member.isReady
        ? AppColors.electricCyan
        : AppColors.primary.withValues(alpha: 0.5);

    return GlassCard(
      withGlow: member.isLeader,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.surfaceContainerHigh,
                child: Text(
                  member.displayName[0],
                  style: AppTextStyles.headlineMd,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(member.displayName, style: AppTextStyles.headlineMd),
                    Text(member.role, style: AppTextStyles.bodySm),
                  ],
                ),
              ),
              if (member.isLeader) const ProBadge(accented: true),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _MemberMeta(
                  label: 'Status',
                  value: member.isReady ? 'READY' : 'WAITING...',
                  color: statusColor,
                  icon: member.isReady
                      ? Icons.check_circle
                      : Icons.hourglass_empty,
                ),
              ),
              _PaymentBadge(status: member.paymentStatus),
            ],
          ),
        ],
      ),
    );
  }
}

class _MemberMeta extends StatelessWidget {
  const _MemberMeta({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: AppTextStyles.caption),
        const SizedBox(height: AppSpacing.xxs),
        Row(
          children: [
            Icon(icon, color: color, size: AppDimensions.iconSm),
            const SizedBox(width: AppSpacing.xs),
            Text(value, style: AppTextStyles.labelMd.copyWith(color: color)),
          ],
        ),
      ],
    );
  }
}

class _PaymentBadge extends StatelessWidget {
  const _PaymentBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final paid = status.toLowerCase() == 'paid';
    final color = paid ? AppColors.statusSuccess : AppColors.statusWarning;
    return Text(
      status.toUpperCase(),
      style: AppTextStyles.badgeLabel.copyWith(color: color),
    );
  }
}
