import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/team/presentation/providers/team_providers.dart';

class TeamMembersSheet extends ConsumerWidget {
  final String teamId;
  final String teamName;

  const TeamMembersSheet({
    super.key,
    required this.teamId,
    required this.teamName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(teamMembersWithProfilesProvider(teamId));

    return Container(
      padding: AppSpacing.screenPadding,
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: AppRadius.radiusFull,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(teamName, style: AppTextStyles.headlineMd),
          const SizedBox(height: AppSpacing.sm),
          const Divider(color: AppColors.outlineVariant),
          membersAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(AppSpacing.xl),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.electricCyan),
              ),
            ),
            error: (e, st) => const Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Text('Could not load members'),
            ),
            data: (members) => Column(
              children: members.map((member) {
                final profile = member['profiles'] as Map?;
                final fullName = profile?['full_name'] as String?;
                final avatarUrl = profile?['avatar_url'] as String?;
                final isLeader = member['is_leader'] as bool? ?? false;
                final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: AppDimensions.avatarSm / 2,
                        backgroundImage: hasAvatar
                            ? NetworkImage(avatarUrl)
                            : null,
                        backgroundColor: AppColors.surfaceContainerHigh,
                        child: !hasAvatar
                            ? const Icon(
                                Icons.person,
                                size: AppDimensions.iconSm,
                              )
                            : null,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          fullName ?? 'Unknown',
                          style: AppTextStyles.bodyMd,
                        ),
                      ),
                      if (isLeader) const StatusBadge(status: 'leader'),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
        ],
      ),
    );
  }
}
