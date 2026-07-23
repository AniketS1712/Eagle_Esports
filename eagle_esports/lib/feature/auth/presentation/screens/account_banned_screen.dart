import 'package:eagle_esports/core/routes/route_names.dart';
import 'package:eagle_esports/shared/widgets/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eagle_esports/feature/auth/presentation/providers/auth_providers.dart';

class AccountBannedScreen extends ConsumerWidget {
  const AccountBannedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Color warningRed = AppColors.statusError;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTopBar(
                  title: 'EAGLE ESPORTS',
                  backRouteName: RouteNames.login,
                ),
                const SizedBox(height: AppSpacing.xxxl),
                const SizedBox(height: AppSpacing.xxxl),

                // Banned Screen Card
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: GlassCard(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    borderRadius: BorderRadius.circular(16),
                    child: Column(
                      children: [
                        Text(
                          'ACCOUNT SUSPENDED',
                          style: AppTextStyles.headlineLg.copyWith(
                            color: warningRed,
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(
                                color: warningRed.withValues(alpha: 0.4),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        // Red Gradient Divider
                        Container(
                          width: 120,
                          height: 2,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                warningRed,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        Text(
                          'Your account access has been revoked due to a violation of the Eagle Esports Fair Play Policy.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyLg.copyWith(
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Reason panel
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLowest.withValues(
                              alpha: 0.5,
                            ),
                            border: Border.all(
                              color: AppColors.outlineVariant.withValues(
                                alpha: 0.3,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'REASON FOR BAN:',
                                style: AppTextStyles.labelMd.copyWith(
                                  color: warningRed.withValues(alpha: 0.8),
                                  fontSize: 11,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'Use of unauthorized third-party software detected during a match. Eagle Esports maintains a zero-tolerance policy regarding integrity breaches.',
                                style: AppTextStyles.bodyMd.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        Text(
                          'This suspension is permanent and applies to all affiliated league participation.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodySm.copyWith(
                            color: AppColors.onSurfaceVariant.withValues(
                              alpha: 0.6,
                            ),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxl),

                        // Actions
                        Row(
                          children: [
                            Expanded(
                              child: DangerButton(
                                text: 'SUPPORT',
                                leadingIcon: const Icon(
                                  Icons.support_agent_outlined,
                                  color: Colors.white,
                                  size: AppDimensions.iconSm,
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Support ticket EE-9982-X opened.',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: SecondaryOutlineButton(
                                text: 'LOGOUT',
                                leadingIcon: const Icon(
                                  Icons.logout_outlined,
                                  size: AppDimensions.iconSm,
                                ),
                                onPressed: () {
                                  ref
                                      .read(authNotifierProvider.notifier)
                                      .signOut();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
