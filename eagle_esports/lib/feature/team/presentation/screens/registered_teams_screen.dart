import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/team/presentation/providers/team_providers.dart';
import 'package:eagle_esports/feature/team/presentation/widgets/team_card.dart';

class RegisteredTeamsScreen extends ConsumerWidget {
  final String tournamentId;

  const RegisteredTeamsScreen({super.key, required this.tournamentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamsAsync = ref.watch(registeredTeamsProvider(tournamentId));

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: AppSpacing.screenPadding,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new),
                      onPressed: () => context.pop(),
                    ),
                    Expanded(
                      child: Text(
                        'Registered Teams',
                        style: AppTextStyles.headlineLgMobile,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: teamsAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.electricCyan,
                    ),
                  ),
                  error: (e, _) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Could not load teams',
                          style: AppTextStyles.bodyMd,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TextButton(
                          onPressed: () => ref.invalidate(
                            registeredTeamsProvider(tournamentId),
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                  data: (teams) => teams.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.people_outline,
                                size: AppDimensions.iconXl,
                                color: AppColors.outline,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                'No teams registered yet',
                                style: AppTextStyles.bodyMd,
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.md,
                            AppSpacing.md,
                            AppSpacing.md,
                            AppSpacing.xxxl,
                          ),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: AppSpacing.md),
                          itemCount: teams.length,
                          itemBuilder: (_, i) => TeamCard(
                            team: teams[i],
                            tournamentId: tournamentId,
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
