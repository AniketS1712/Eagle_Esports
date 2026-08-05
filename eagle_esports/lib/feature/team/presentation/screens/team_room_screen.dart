import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/team/presentation/providers/team_providers.dart';
import 'package:eagle_esports/feature/team/presentation/widgets/team_invite_code_card.dart';
import 'package:eagle_esports/feature/team/presentation/widgets/team_members_list.dart';
import 'package:eagle_esports/shared/widgets/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eagle_esports/core/routes/route_names.dart';

class TeamRoomScreen extends ConsumerStatefulWidget {
  const TeamRoomScreen({required this.teamId, super.key});

  final String teamId;

  @override
  ConsumerState<TeamRoomScreen> createState() => _TeamRoomScreenState();
}

class _TeamRoomScreenState extends ConsumerState<TeamRoomScreen> {
  @override
  Widget build(BuildContext context) {
    final teamAsync = ref.watch(teamStreamProvider(widget.teamId));
    final membersAsync = ref.watch(teamMembersStreamProvider(widget.teamId));

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const AppTopBar(
                title: 'Team Room',
                backRouteName: RouteNames.home,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 640),
                      child: teamAsync.when(
                        loading: () => const _LoadingState(),
                        error: (error, stackTrace) =>
                            _ErrorState(message: error.toString()),
                        data: (team) {
                          return membersAsync.when(
                            loading: () => const _LoadingState(),
                            error: (error, stackTrace) =>
                                _ErrorState(message: error.toString()),
                            data: (members) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const SizedBox(height: AppSpacing.xxl),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          team.teamName,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTextStyles.headlineMd,
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.md),
                                      StatusBadge(
                                        status: team.paymentStatus.name,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.lg),

                                  TeamInviteCodeCard(inviteCode: team.inviteCode),
                                  const SizedBox(height: AppSpacing.lg),
                                  Text('Players', style: AppTextStyles.labelMd),
                                  const SizedBox(height: AppSpacing.sm),
                                  TeamMembersList(members: members),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxl),
        child: CircularProgressIndicator(color: AppColors.electricCyan),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyMd.copyWith(color: AppColors.statusError),
      ),
    );
  }
}
