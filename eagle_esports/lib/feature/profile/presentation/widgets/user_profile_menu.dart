import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eagle_esports/core/routes/route_names.dart';
import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/models/profile.dart';
import 'package:eagle_esports/feature/auth/presentation/providers/auth_providers.dart';
import 'package:eagle_esports/shared/widgets/eagle_logo.dart';

class UserProfileMenu extends ConsumerWidget {
  final UserRole role;

  const UserProfileMenu({super.key, required this.role});

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainer,
        title: Text('Logout', style: AppTextStyles.headlineMd),
        content: Text(
          'Are you sure you want to log out?',
          style: AppTextStyles.bodyMd,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('CANCEL', style: AppTextStyles.bodyMd),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(authNotifierProvider.notifier).signOut();
            },
            child: Text(
              'LOGOUT',
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.statusError,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _AboutBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = [
      _MenuItemData(
        icon: Icons.edit_outlined,
        label: 'Edit Profile',
        onTap: () => context.pushNamed(RouteNames.editProfile),
      ),
      _MenuItemData(
        icon: Icons.notifications_outlined,
        label: 'Notifications',
        onTap: () => ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Coming soon'))),
      ),
      _MenuItemData(
        icon: Icons.info_outlined,
        label: 'About Eagle Esport',
        onTap: () => _showAbout(context),
      ),
      _MenuItemData(
        icon: Icons.privacy_tip_outlined,
        label: 'Privacy Policy',
        onTap: () => ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Coming soon'))),
      ),
      _MenuItemData(
        icon: Icons.gavel_outlined,
        label: 'Terms & Conditions',
        onTap: () => ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Coming soon'))),
      ),
      _MenuItemData(
        icon: Icons.logout,
        label: 'Logout',
        textColor: AppColors.statusError,
        iconColor: AppColors.statusError,
        onTap: () => _confirmLogout(context, ref),
      ),
    ];

    return Column(children: items.map((item) => _MenuRow(item: item)).toList());
  }
}

class _MenuItemData {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? iconColor;

  const _MenuItemData({
    required this.icon,
    required this.label,
    required this.onTap,
    this.textColor,
    this.iconColor,
  });
}

class _MenuRow extends StatelessWidget {
  final _MenuItemData item;

  const _MenuRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.lg,
        ),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.outlineVariant, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              size: AppDimensions.iconMd,
              color: item.iconColor ?? AppColors.primary,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                item.label,
                style: AppTextStyles.bodyMd.copyWith(color: item.textColor),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: AppDimensions.iconXs,
              color: AppColors.outline,
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutBottomSheet extends StatelessWidget {
  const _AboutBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.screenPadding,
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppSpacing.md),
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
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: EagleLogo(
              logoSize: 80,
              showGlow: false,
              subtitle: 'Tournament Platform',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Center(child: Text('Eagle Esport', style: AppTextStyles.headlineMd)),
          Center(child: Text('Version 1.0.0', style: AppTextStyles.caption)),
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: Text(
              'A Free Fire tournament management platform.',
              style: AppTextStyles.bodyMd,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Center(
            child: Text(
              'support@eagleesport.in',
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.electricCyan,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
        ],
      ),
    );
  }
}
