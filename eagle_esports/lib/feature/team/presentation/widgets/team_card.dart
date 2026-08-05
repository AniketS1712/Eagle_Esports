import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/team/presentation/providers/team_providers.dart';
import 'package:eagle_esports/feature/team/presentation/widgets/team_members_sheet.dart';

class TeamCard extends ConsumerWidget {
  final Map<String, dynamic> team;
  final String tournamentId;

  const TeamCard({super.key, required this.team, required this.tournamentId});

  void _confirmRemove(
    BuildContext context,
    WidgetRef ref,
    String teamId,
    String teamName,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainer,
        title: Text('Remove Team', style: AppTextStyles.headlineMd),
        content: Text(
          'Remove "$teamName" from this tournament? This action cannot be undone.',
          style: AppTextStyles.bodyMd,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: AppTextStyles.bodyMd),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.statusError),
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await ref
                    .read(registeredTeamsActionsProvider.notifier)
                    .removeTeam(teamId: teamId, tournamentId: tournamentId);
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Team removed')));
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: Text('Remove', style: AppTextStyles.bodyMd),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamId = team['id'] as String;
    final teamName = team['team_name'] as String;
    final slotNumber = team['slot_number'] as int?;
    final paymentStatus = team['payment_status'] as String;
    final inGameLeaderName = team['in_game_leader_name'] as String?;
    final membersList = team['team_members'] as List?;
    final memberCount = (membersList != null && membersList.isNotEmpty)
        ? (membersList.first['count'] as int? ?? 0)
        : 0;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (slotNumber != null) ...[
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceContainerHigh,
                  ),
                  child: Center(
                    child: Text(
                      '#$slotNumber',
                      style: AppTextStyles.badgeLabel,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teamName,
                      style: AppTextStyles.headlineMd,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (inGameLeaderName != null)
                      Text(
                        'Leader IGN: $inGameLeaderName',
                        style: AppTextStyles.caption,
                      ),
                  ],
                ),
              ),
              StatusBadge(status: paymentStatus),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(color: AppColors.outlineVariant),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.people_outline,
                    size: AppDimensions.iconSm,
                    color: AppColors.outline,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text('$memberCount members', style: AppTextStyles.bodySm),
                ],
              ),
              Row(
                children: [
                  IconActionButton(
                    icon: Icons.visibility_outlined,
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) =>
                          TeamMembersSheet(teamId: teamId, teamName: teamName),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  if (paymentStatus == 'pending')
                    IconActionButton(
                      icon: Icons.delete_outline,
                      onPressed: () =>
                          _confirmRemove(context, ref, teamId, teamName),
                    )
                  else
                    const Tooltip(
                      message: 'Cannot remove paid teams',
                      child: Icon(
                        Icons.lock_outline,
                        size: AppDimensions.iconMd,
                        color: AppColors.outline,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
