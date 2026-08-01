import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/models/wallet_transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionListItem extends StatelessWidget {
  final WalletTransaction transaction;
  final VoidCallback onTap;

  const TransactionListItem({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _iconColor(transaction).withValues(alpha: 0.15),
              ),
              child: Icon(
                _iconData(transaction),
                size: AppDimensions.iconSm,
                color: _iconColor(transaction),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_label(transaction), style: AppTextStyles.bodyMd),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat(
                      'dd MMM yyyy • HH:mm',
                    ).format(transaction.createdAt),
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${transaction.type == WalletTxType.credit ? '+' : '-'}${transaction.amount.toStringAsFixed(0)}T',
                  style: AppTextStyles.numberMd.copyWith(
                    color: transaction.type == WalletTxType.credit
                        ? AppColors.statusSuccess
                        : AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                if (transaction.status == WalletTxStatus.pending)
                  Text(
                    'PENDING',
                    style: AppTextStyles.badgeLabel.copyWith(
                      color: AppColors.statusWarning,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconData(WalletTransaction t) {
    switch (t.category) {
      case WalletTxCategory.topup:
        return Icons.add_card_outlined;
      case WalletTxCategory.tournamentEntry:
        return Icons.sports_esports_outlined;
      case WalletTxCategory.tournamentWinBonus:
        return Icons.emoji_events_outlined;
      case WalletTxCategory.merchPurchase:
        return Icons.shopping_bag_outlined;
      case WalletTxCategory.refund:
        return Icons.replay_outlined;
    }
  }

  Color _iconColor(WalletTransaction t) {
    switch (t.category) {
      case WalletTxCategory.topup:
        return AppColors.statusSuccess;
      case WalletTxCategory.tournamentEntry:
        return AppColors.primary;
      case WalletTxCategory.tournamentWinBonus:
        return const Color(0xFFFFD700);
      case WalletTxCategory.merchPurchase:
        return AppColors.tertiary;
      case WalletTxCategory.refund:
        return AppColors.statusWarning;
    }
  }

  String _label(WalletTransaction t) {
    switch (t.category) {
      case WalletTxCategory.topup:
        return 'Wallet Top-up';
      case WalletTxCategory.tournamentEntry:
        return 'Tournament Entry Fee';
      case WalletTxCategory.tournamentWinBonus:
        return 'Prize Won';
      case WalletTxCategory.merchPurchase:
        return 'Merch Purchase';
      case WalletTxCategory.refund:
        return 'Refund';
    }
  }
}
