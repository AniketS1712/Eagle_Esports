import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eagle_esports/core/routes/route_names.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/auth/presentation/providers/auth_providers.dart';

class UserProfileHeader extends ConsumerWidget {
  const UserProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).value;
    final hasAvatar = profile?.avatarUrl != null && profile!.avatarUrl.isNotEmpty;

    return GlassCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: AppDimensions.avatarLg / 2,
            backgroundImage: hasAvatar ? NetworkImage(profile.avatarUrl) : null,
            backgroundColor: AppColors.surfaceContainerHigh,
            child: !hasAvatar
                ? const Icon(
                    Icons.person,
                    size: AppDimensions.iconLg,
                    color: AppColors.outline,
                  )
                : null,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile?.fullName ?? '—',
                  style: AppTextStyles.headlineMd,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  profile?.phone ?? '—',
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                StatusBadge(status: profile?.role.name ?? 'user'),
              ],
            ),
          ),
          IconActionButton(
            icon: Icons.edit_outlined,
            onPressed: () => context.pushNamed(RouteNames.editProfile),
          ),
        ],
      ),
    );
  }
}
