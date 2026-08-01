import 'package:eagle_esports/core/theme/theme.dart';
import 'package:eagle_esports/models/wallet_transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final WalletTransaction transaction;

  const TransactionDetailsScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.xl),
          topRight: Radius.circular(AppRadius.xl),
        ),
      ),
      padding: AppSpacing.cardPaddingLarge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
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
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _statusColor(transaction).withValues(alpha: 0.15),
              ),
              child: Icon(
                _statusIcon(transaction),
                size: AppDimensions.iconLg,
                color: _statusColor(transaction),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Text(
              '${transaction.type == WalletTxType.credit ? '+' : '-'}${transaction.amount.toStringAsFixed(0)} T',
              style: AppTextStyles.numberXl.copyWith(
                color: transaction.type == WalletTxType.credit
                    ? AppColors.statusSuccess
                    : AppColors.onSurface,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Center(
            child: Text(
              _label(transaction),
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const Divider(color: AppColors.dividerColor),
          const SizedBox(height: AppSpacing.md),
          _DetailRow(
            label: 'Transaction ID',
            value: transaction.id.substring(0, 8).toUpperCase(),
          ),
          _DetailRow(
            label: 'Date',
            value: DateFormat(
              'dd MMM yyyy • HH:mm',
            ).format(transaction.createdAt),
          ),
          _DetailRow(label: 'Type', value: transaction.type.name.toUpperCase()),
          _DetailRow(label: 'Category', value: _label(transaction)),
          _DetailRow(
            label: 'Status',
            value: transaction.status.name.toUpperCase(),
          ),
          _DetailRow(
            label: 'Balance After',
            value: '${transaction.balanceAfter.toStringAsFixed(0)} T',
          ),
          if (transaction.description != null)
            _DetailRow(label: 'Note', value: transaction.description!),
        ],
      ),
    );
  }

  Color _statusColor(WalletTransaction t) {
    if (t.status == WalletTxStatus.failed) return AppColors.error;
    if (t.status == WalletTxStatus.pending) return AppColors.statusWarning;
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

  IconData _statusIcon(WalletTransaction t) {
    if (t.status == WalletTxStatus.failed) return Icons.error_outline;
    if (t.status == WalletTxStatus.pending) return Icons.pending_outlined;
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

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.caption),
          Text(value, style: AppTextStyles.bodyMd),
        ],
      ),
    );
  }
}
