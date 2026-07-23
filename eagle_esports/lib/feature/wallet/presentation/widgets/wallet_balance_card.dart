import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/models/wallet.dart';
import 'package:flutter/material.dart';

class WalletBalanceCard extends StatelessWidget {
  final Wallet? wallet;
  final bool isLoading;

  const WalletBalanceCard({
    super.key,
    required this.wallet,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      withGlow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TALON BALANCE',
            style: AppTextStyles.badgeLabel.copyWith(
              color: AppColors.onSurfaceVariant,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          if (isLoading)
            const SizedBox(
              height: 48,
              child: CircularProgressIndicator(
                color: AppColors.electricCyan,
                strokeWidth: 2,
              ),
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  wallet != null ? wallet!.talonBalance.toStringAsFixed(0) : '—',
                  style: AppTextStyles.numberXl.copyWith(
                    color: AppColors.electricCyan,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    'T',
                    style: AppTextStyles.headlineMd.copyWith(
                      color: AppColors.electricCyan.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            '1 Talon = ₹1',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}
