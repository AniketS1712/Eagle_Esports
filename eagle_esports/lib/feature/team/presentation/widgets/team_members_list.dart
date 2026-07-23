import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/auth/presentation/providers/auth_providers.dart';
import 'package:eagle_esports/models/team_member.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamMembersList extends ConsumerWidget {
  const TeamMembersList({required this.members, super.key});

  final List<TeamMember> members;

  String _initials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    return trimmed.substring(0, trimmed.length >= 2 ? 2 : 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: members.map((member) {
        final profileAsync = ref.watch(profileByIdProvider(member.userId));
        final profile = profileAsync.value;
        final displayName = profile?.fullName ?? member.userId;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: GlassCard(
            padding: AppSpacing.listItemPadding,
            child: Row(
              children: [
                SizedBox(
                  width: AppDimensions.avatarSm,
                  height: AppDimensions.avatarSm,
                  child: CircleAvatar(
                    backgroundColor: AppColors.surfaceContainerHighest,
                    child: Text(
                      _initials(displayName),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.electricCyan,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    displayName,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMd,
                  ),
                ),
                if (member.isLeader) ...[
                  const SizedBox(width: AppSpacing.sm),
                  const StatusBadge(status: 'LEADER'),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
