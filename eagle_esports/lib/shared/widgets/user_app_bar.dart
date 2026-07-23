import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/feature/wallet/presentation/providers/wallet_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserAppBar extends ConsumerWidget {
  const UserAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletAsync = ref.watch(walletStreamProvider);

    // Show balance as integer Talons, or '—' while loading/error
    final balanceLabel = walletAsync.when(
      data: (wallet) =>
          wallet != null ? wallet.talonBalance.toStringAsFixed(0) : '—',
      loading: () => '...',
      error: (_, _) => '—',
    );

    return Container(
      padding: AppSpacing.screenPadding,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.outlineVariant, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'EAGLE ESPORTS',
              style: AppTextStyles.headlineMd.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: AppRadius.radiusFull,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.account_balance_wallet,
                  color: AppColors.secondary,
                  size: AppDimensions.iconSm,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  balanceLabel,
                  style: AppTextStyles.labelMd.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
