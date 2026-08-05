import 'package:flutter/material.dart';
import 'package:eagle_esports/core/theme/theme.dart';

class TopupSummaryCard extends StatelessWidget {
  final double selectedAmount;

  const TopupSummaryCard({
    super.key,
    required this.selectedAmount,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'You will receive',
                style: AppTextStyles.bodyMd,
              ),
              Text(
                '${selectedAmount.toStringAsFixed(0)} Talons',
                style: AppTextStyles.numberMd.copyWith(
                  color: AppColors.electricCyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Amount payable',
                style: AppTextStyles.bodyMd,
              ),
              Text(
                '₹${selectedAmount.toStringAsFixed(0)}',
                style: AppTextStyles.numberMd,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            '* 1 Talon = ₹1. Payment via Razorpay.',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}
